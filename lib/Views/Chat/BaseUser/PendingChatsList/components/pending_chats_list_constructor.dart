import 'dart:collection';

import 'package:sApport/Model/Chat/chat.dart';
import 'package:sApport/ViewModel/chat_view_model.dart';
import 'package:sApport/Views/Chat/components/chat_list_item.dart';
import 'package:sApport/Views/components/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PendingChatsListConstructor extends StatefulWidget {
  const PendingChatsListConstructor({Key? key}) : super(key: key);

  @override
  _PendingChatsListConstructorState createState() => _PendingChatsListConstructorState();
}

class _PendingChatsListConstructorState extends State<PendingChatsListConstructor> {
  // View Models
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ValueListenableBuilder(
        valueListenable: chatViewModel.pendingChats,
        builder: (context, LinkedHashMap<String, Chat> pendingChats, child) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) {
              // The index for the linked hash map runs from pendingChats.length - 1 to 0 because the hash map
              // is ordered by the time of insertion, so the last inserted element (the newer chat) is the first element
              // to show in the list.
              Chat _chatItem = pendingChats.values.elementAt(pendingChats.length - 1 - index);
              return ChatListItem(
                  chatItem: _chatItem,
                  selectedItemCallback: () => setState(() {}),
                  isSelected: chatViewModel.currentChat.value?.peerUser?.id == _chatItem.peerUser!.id);
            },
            itemCount: pendingChats.length,
          );
        },
      ),
    );
  }
}
