import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_colombo_ghiazzi/Model/BaseUser/base_user.dart';
import 'package:dima_colombo_ghiazzi/Model/Chat/active_chat.dart';
import 'package:dima_colombo_ghiazzi/ViewModel/chat_view_model.dart';
import 'package:dima_colombo_ghiazzi/Views/Chat/BaseUser/AnonymousChat/PendingChatsList/pending_chats_list_screen.dart';
import 'package:dima_colombo_ghiazzi/Views/Chat/ChatPage/chat_page_screen.dart';
import 'package:dima_colombo_ghiazzi/Views/Chat/components/chats_list_constructor.dart';
import 'package:dima_colombo_ghiazzi/Views/Chat/components/top_bar.dart';
import 'package:dima_colombo_ghiazzi/Views/components/loading_dialog.dart';
import 'package:dima_colombo_ghiazzi/constants.dart';
import 'package:flutter/material.dart';

class ActiveChatsListBody extends StatefulWidget {
  final ChatViewModel chatViewModel;

  ActiveChatsListBody({Key key, @required this.chatViewModel})
      : super(key: key);

  @override
  _ActiveChatsListBodyState createState() => _ActiveChatsListBodyState();
}

class _ActiveChatsListBodyState extends State<ActiveChatsListBody> {
  bool newPendingChats;
  @override
  void initState() {
    initChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TopBar(
                text: 'Anonymous',
                button: InkWell(
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 8, right: 8, top: 2, bottom: 2),
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: kPrimaryLightColor,
                    ),
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.archive,
                          color: kPrimaryColor,
                          size: 20,
                        ),
                        SizedBox(
                          width: 2,
                        ),
                        Text(
                          "Requests",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kPrimaryColor),
                        ),
                        FutureBuilder(
                          future: widget.chatViewModel.hasPendingChats(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data) {
                                return Text('+1');
                              }
                            }
                            return Container();
                          },
                        )
                      ],
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PendingChatsListScreen(
                              chatViewModel: widget.chatViewModel)),
                    ).then((value) {
                      initChats();
                      setState(() {});
                    });
                  },
                ),
              ),
              ChatsListConstructor(
                  chatViewModel: widget.chatViewModel,
                  createUserCallback: createUserCallback),
            ],
          ),
        ),
        Align(
          alignment:
              Alignment.lerp(Alignment.bottomRight, Alignment.center, 0.1),
          child: FloatingActionButton(
            onPressed: () async {
              LoadingDialog.show(context,
                  text: 'Looking for new random user...');
              widget.chatViewModel.newRandomChat().then((value) {
                LoadingDialog.hide(context);
                if (value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPageScreen(
                        chatViewModel: widget.chatViewModel,
                      ),
                    ),
                  ).then((value) {
                    initChats();
                    setState(() {});
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('No more users.'),
                    duration: const Duration(seconds: 5),
                  ));
                }
              });
            },
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: Colors.lightBlue[200],
            child: const Icon(
              Icons.add,
              size: 40.0,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    ));
  }

  BaseUser createUserCallback(DocumentSnapshot doc) {
    BaseUser user = BaseUser();
    user.setFromDocument(doc);
    return user;
  }

  void initChats() {
    widget.chatViewModel.conversation.senderUserChat = ActiveChat();
    widget.chatViewModel.conversation.peerUserChat = ActiveChat();
  }
}
