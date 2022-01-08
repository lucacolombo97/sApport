import 'dart:async';
import 'dart:developer';
import 'dart:collection';
import 'package:get_it/get_it.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sApport/Model/utils.dart';
import 'package:sApport/Model/Chat/chat.dart';
import 'package:sApport/Model/Chat/request.dart';
import 'package:sApport/Model/DBItems/message.dart';
import 'package:sApport/Model/Chat/active_chat.dart';
import 'package:sApport/Model/Chat/expert_chat.dart';
import 'package:sApport/Model/Chat/pending_chat.dart';
import 'package:sApport/Model/Chat/anonymous_chat.dart';
import 'package:sApport/Model/Services/user_service.dart';
import 'package:sApport/Model/DBItems/BaseUser/base_user.dart';
import 'package:sApport/Model/Services/firestore_service.dart';

class ChatViewModel extends ChangeNotifier {
  // Services
  final FirestoreService _firestoreService = GetIt.I<FirestoreService>();
  final UserService _userService = GetIt.I<UserService>();

  // Text Controllers
  final TextEditingController contentTextCtrl = TextEditingController();

  // Stream Controllers
  var _newRandomUserCtrl = StreamController<bool>.broadcast();

  // Stream Subscriptions
  StreamSubscription? _anonymousChatsSubscriber;
  StreamSubscription? _pendingChatsSubscriber;
  StreamSubscription? _expertsChatsSubscriber;
  StreamSubscription? _activeChatsSubscriber;

  // Current chat of the user
  ValueNotifier<Chat?> _currentChat = ValueNotifier(null);

  // List of the chats of the user saved as Linked Hash Map
  ValueNotifier<LinkedHashMap<String, AnonymousChat>>? _anonymousChats;
  ValueNotifier<LinkedHashMap<String, PendingChat>>? _pendingChats;
  ValueNotifier<LinkedHashMap<String, ExpertChat>>? _expertsChats;
  ValueNotifier<LinkedHashMap<String, ActiveChat>>? _activeChats;

  /// Update the ChattingWith field of the [senderUser] inside the DB.
  ///
  /// It is used in order to show or not the notification on new messages.
  Future<void> updateChattingWith() {
    return _firestoreService.updateUserFieldIntoDB(_userService.loggedUser!, "chattingWith", _currentChat.value?.peerUser?.id);
  }

  /// Reset the ChattingWith field of the [senderUser] inside the DB.
  ///
  /// It is used in order to show or not the notification on new messages.
  Future<void> resetChattingWith() {
    return _firestoreService.updateUserFieldIntoDB(_userService.loggedUser!, "chattingWith", null);
  }

  /// Send a message to the [peerUser] of the [_currentChat].
  void sendMessage() {
    if (contentTextCtrl.text.trim().isNotEmpty) {
      _currentChat.value!.lastMessage = contentTextCtrl.text.trim();
      _currentChat.value!.lastMessageDateTime = DateTime.now();
      _firestoreService.addMessageIntoDB(
        _userService.loggedUser!,
        _currentChat.value!,
        Message(
          idFrom: _userService.loggedUser!.id,
          idTo: _currentChat.value!.peerUser!.id,
          timestamp: _currentChat.value!.lastMessageDateTime!,
          content: _currentChat.value!.lastMessage,
        ),
      );
      contentTextCtrl.clear();
    }
  }

  /// Set the [notReadMessages] of the logged user with the [peerUser] of the [_currentChat] to `0`.
  Future<void> setMessagesHasRead() {
    _currentChat.value!.notReadMessages = 0;
    return _firestoreService.setMessagesHasRead(_userService.loggedUser!, _currentChat.value!);
  }

  /// Subscribe to the anomymous chats stream of the [loggedUser] from the Firebase DB and
  /// update the [_anonymousChats] linked hash map with the chats.
  ///
  /// It also retrieve the [peerUser] info for every new chat from the Firebase DB.
  ///
  /// Finally it calls the [notifyListeners] on the [_anonymousChats] value notifier to notify the changes
  /// to all the listeners.
  void loadAnonymousChats() async {
    _anonymousChats = ValueNotifier<LinkedHashMap<String, AnonymousChat>>(LinkedHashMap<String, AnonymousChat>());
    _anonymousChatsSubscriber = _firestoreService.getChatsStreamFromDB(_userService.loggedUser!, AnonymousChat.COLLECTION).listen(
      (snapshot) async {
        for (var docChange in snapshot.docChanges) {
          var chat = AnonymousChat.fromDocument(docChange.doc);
          // If oldIndex == -1, the document is added, so its new and it has to retrieve the peer user from the DB
          // and load the messages
          if (docChange.oldIndex == -1) {
            getPeerUserDoc(chat.peerUser!.collection, chat.peerUser!.id).then((value) {
              chat.peerUser!.setFromDocument(value.docs[0]);
              chat.loadMessages();
              _anonymousChats!.value[docChange.doc.id] = chat;
              _anonymousChats!.notifyListeners();
            });
          } else {
            // Otherwise, update the lastMessage, lastMessageDateTime and notReadmessages fields
            var removedChat = _anonymousChats!.value.remove(docChange.doc.id);
            removedChat?.lastMessage = chat.lastMessage;
            removedChat?.lastMessageDateTime = chat.lastMessageDateTime;
            removedChat?.notReadMessages = chat.notReadMessages;
            _anonymousChats!.value[docChange.doc.id] = removedChat!;
            _anonymousChats!.notifyListeners();
          }
        }
      },
      onError: (error) => log("Failed to get the stream of anonymous chats: $error"),
    );
  }

  /// Subscribe to the pending chats stream of the [loggedUser] from the Firebase DB and
  /// update the [_pendingChats] linked hash map with the chats.
  ///
  /// It also retrieve the [peerUser] info for every new chat from the Firebase DB.
  ///
  /// Finally it calls the [notifyListeners] on the [_pendingChats] value notifier to notify the changes
  /// to all the listeners.
  void loadPendingChats() async {
    _pendingChats = ValueNotifier<LinkedHashMap<String, PendingChat>>(LinkedHashMap<String, PendingChat>());
    _pendingChatsSubscriber = _firestoreService.getChatsStreamFromDB(_userService.loggedUser!, PendingChat.COLLECTION).listen(
      (snapshot) async {
        for (var docChange in snapshot.docChanges) {
          // If oldIndex == -1, the document is added, so its new and it has to retrieve the peer user from the DB
          if (docChange.oldIndex == -1) {
            var chat = PendingChat.fromDocument(docChange.doc);
            getPeerUserDoc(chat.peerUser!.collection, chat.peerUser!.id).then((value) {
              chat.peerUser!.setFromDocument(value.docs[0]);
              chat.loadMessages();
              _pendingChats!.value[docChange.doc.id] = chat;
              _pendingChats!.notifyListeners();
            });
          }
        }
      },
      onError: (error) => log("Failed to get the stream of pending chats: $error"),
    );
  }

  /// Subscribe to the experts chats stream of the [loggedUser] from the Firebase DB and
  /// update the [_expertChats] linked hash map with the chats.
  ///
  /// It also retrieve the [peerUser] info for every new chat from the Firebase DB.
  ///
  /// Finally it calls the [notifyListeners] on the [_expertChats] value notifier to notify the changes
  /// to all the listeners.
  void loadExpertsChats() async {
    _expertsChats = ValueNotifier<LinkedHashMap<String, ExpertChat>>(LinkedHashMap<String, ExpertChat>());
    _expertsChatsSubscriber = _firestoreService.getChatsStreamFromDB(_userService.loggedUser!, ExpertChat.COLLECTION).listen(
      (snapshot) async {
        for (var docChange in snapshot.docChanges) {
          var chat = ExpertChat.fromDocument(docChange.doc);
          // If oldIndex == -1, the document is added, so its new and it has to retrieve the peer user from the DB
          if (docChange.oldIndex == -1) {
            getPeerUserDoc(chat.peerUser!.collection, chat.peerUser!.id).then((value) {
              chat.peerUser!.setFromDocument(value.docs[0]);
              chat.loadMessages();
              _expertsChats!.value[docChange.doc.id] = chat;
              _expertsChats!.notifyListeners();
            });
          } else {
            // Otherwise, update the lastMessage, lastMessageDateTime and notReadmessages fields
            var removedChat = _expertsChats!.value.remove(docChange.doc.id);
            removedChat?.lastMessage = chat.lastMessage;
            removedChat?.lastMessageDateTime = chat.lastMessageDateTime;
            removedChat?.notReadMessages = chat.notReadMessages;
            _expertsChats!.value[docChange.doc.id] = removedChat!;
            _expertsChats!.notifyListeners();
          }
        }
      },
      onError: (error) => log("Failed to get the stream of expert chats: $error"),
    );
  }

  /// Subscribe to the active chats stream of the [loggedUser] from the Firebase DB and
  /// update the [_activeChats] linked hash map with the chats.
  ///
  /// It also retrieve the [peerUser] info for every new chat from the Firebase DB.
  ///
  /// Finally it calls the [notifyListeners] on the [_activeChats] value notifier to notify the changes
  /// to all the listeners.
  void loadActiveChats() async {
    _activeChats = ValueNotifier<LinkedHashMap<String, ActiveChat>>(LinkedHashMap<String, ActiveChat>());
    _activeChatsSubscriber = _firestoreService.getChatsStreamFromDB(_userService.loggedUser!, ActiveChat.COLLECTION).listen(
      (snapshot) async {
        for (var docChange in snapshot.docChanges) {
          var chat = ActiveChat.fromDocument(docChange.doc);
          // If oldIndex == -1, the document is added, so its new and it has to retrieve the peer user from the DB
          if (docChange.oldIndex == -1) {
            getPeerUserDoc(chat.peerUser!.collection, chat.peerUser!.id).then((value) {
              chat.peerUser!.setFromDocument(value.docs[0]);
              chat.loadMessages();
              _activeChats!.value[docChange.doc.id] = chat;
              _activeChats!.notifyListeners();
            });
          } else {
            // Otherwise, update the lastMessage, lastMessageDateTime and notReadmessages fields
            var removedChat = _activeChats!.value.remove(docChange.doc.id);
            removedChat?.lastMessage = chat.lastMessage;
            removedChat?.lastMessageDateTime = chat.lastMessageDateTime;
            removedChat?.notReadMessages = chat.notReadMessages;
            _activeChats!.value[docChange.doc.id] = removedChat!;
            _activeChats!.notifyListeners();
          }
        }
      },
      onError: (error) => log("Failed to get the stream of active chats: $error"),
    );
  }

  /// Return the doc of the peer user with all the info based on the [id]
  /// and the [collection].
  Future<QuerySnapshot> getPeerUserDoc(String collection, String id) {
    return _firestoreService.getUserByIdFromDB(collection, id);
  }

  /// Look for a new random anonymous user into the DB.
  Future<void> getNewRandomUser() {
    return _firestoreService.getRandomUserFromDB(_userService.loggedUser as BaseUser, Utils.randomId()).then((doc) {
      if (doc != null) {
        // Create the random user and update the chat
        var randomUser = BaseUser.fromDocument(doc);
        // Add the listeners for new messages
        addNewChat(Request(peerUser: randomUser));
        // Add the "true" value to the new random user stream controller
        _newRandomUserCtrl.add(true);
      } else {
        // Add the "false" value to the new random user stream controller
        _newRandomUserCtrl.add(false);
      }
    });
  }

  /// Accept a new pending chat request.
  void acceptPendingChat() {
    _pendingChats!.value.remove(_currentChat.value!.peerUser!.id);
    _firestoreService.upgradePendingToActiveChatIntoDB(_userService.loggedUser!, _currentChat.value!);
    addNewChat(AnonymousChat(peerUser: _currentChat.value!.peerUser as BaseUser));
    _pendingChats!.notifyListeners();
  }

  /// Deny a pending chat.
  ///
  /// It deletes the chat between the 2 users and all the messages.
  void denyPendingChat() {
    _pendingChats!.value.remove(_currentChat.value!.peerUser!.id);
    _firestoreService.removeChatFromDB(_userService.loggedUser!, _currentChat.value!);
    _firestoreService.removeMessagesFromDB(Utils.pairChatId(_userService.loggedUser!.id, _currentChat.value!.peerUser!.id));
    resetCurrentChat();
    _pendingChats!.notifyListeners();
  }

  /// Set the [chat] as the [_currentChat] and add the listener for new messages.
  void addNewChat(Chat chat) {
    chat.loadMessages();
    setCurrentChat(chat);
  }

  /// Set the [chat] as the [_currentChat].
  void setCurrentChat(Chat chat) {
    _currentChat.value = chat;
    log("Current chat setted");
  }

  /// Reset the [_currentChat] and clear the [contentTextCtrl].
  ///
  /// It must be called after all the other reset methods.
  void resetCurrentChat() {
    _currentChat.value = null;
    contentTextCtrl.clear();
    log("Current chat resetted");
  }

  /// Cancel all the value listeners and clear their contents.
  void closeListeners() {
    // Cancel chat list subscribers
    _anonymousChatsSubscriber?.cancel();
    _pendingChatsSubscriber?.cancel();
    _expertsChatsSubscriber?.cancel();
    _activeChatsSubscriber?.cancel();

    // Cancel chat subscribers and clear theri values
    _anonymousChats?.value.values.forEach((chat) => chat.closeListeners());
    _pendingChats?.value.values.forEach((chat) => chat.closeListeners());
    _expertsChats?.value.values.forEach((chat) => chat.closeListeners());
    _activeChats?.value.values.forEach((chat) => chat.closeListeners());

    // Clear chat list values
    _anonymousChats?.value.clear();
    _pendingChats?.value.clear();
    _expertsChats?.value.clear();
    _activeChats?.value.clear();

    // Reset current chat
    _currentChat = ValueNotifier(null);
    log("Chat listeners closed");
  }

  /// Get the [_currentChat] value notifier.
  ValueNotifier<Chat?> get currentChat => _currentChat;

  /// Get the [_anonymousChats] value notifier.
  ///
  /// **The function [loadAnonymousChats] must be called before getting
  /// the [anonymousChats].**
  ValueNotifier<LinkedHashMap<String, Chat>>? get anonymousChats => _anonymousChats;

  /// Get the [_pendingChats] value notifier.
  ///
  /// **The function [loadPendingChats] must be called before getting
  /// the [pendingChats].**
  ValueNotifier<LinkedHashMap<String, Chat>>? get pendingChats => _pendingChats;

  /// Get the [_expertsChats] value notifier.
  ///
  /// **The function [loadExpertsChats] must be called before getting
  /// the [expertsChats].**
  ValueNotifier<LinkedHashMap<String, Chat>>? get expertsChats => _expertsChats;

  /// Get the [_activeChats] value notifier.
  ///
  /// **The function [loadActiveChats] must be called before getting
  /// the [activeChats].**
  ValueNotifier<LinkedHashMap<String, Chat>>? get activeChats => _activeChats;

  /// Stream of the new random user controller.
  Stream<bool> get newRandomUser => _newRandomUserCtrl.stream;
}
