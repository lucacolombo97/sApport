import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dima_colombo_ghiazzi/ViewModel/chat_view_model.dart';
import 'package:dima_colombo_ghiazzi/Views/components/loading_dialog.dart';
import 'package:dima_colombo_ghiazzi/constants.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  final ChatViewModel chatViewModel;

  Body({Key key, @required this.chatViewModel}) : super(key: key);

  @override
  _BodyState createState() => _BodyState(chatViewModel: chatViewModel);
}

class _BodyState extends State<Body> with WidgetsBindingObserver {
  _BodyState({@required this.chatViewModel});

  final ChatViewModel chatViewModel;
  bool firstMessageSent = true;
  int _limitIncrement = 20;
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    listScrollController.addListener(_scrollListener);
    widget.chatViewModel.updateChattingWith();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessages(),
              // Input content
              buildInput(),
            ],
          ),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    if (document != null) {
      if (document.get('idFrom') == chatViewModel.senderId) {
        // Right (my message)
        return Row(
          children: <Widget>[
            Container(
              child: Text(
                document.get('content'),
                style: TextStyle(color: kPrimaryColor),
              ),
              padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
              width: 200.0,
              decoration: BoxDecoration(
                  color: lightGreyColor,
                  borderRadius: BorderRadius.circular(8.0)),
              margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        );
      } else {
        // Left (peer message)
        return Container(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  widget.chatViewModel.isLastMessageLeft(index)
                      ? Material(
                          child: widget.chatViewModel.peerAvatar != null
                              ? Image.network(
                                  widget.chatViewModel.peerAvatar,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: kPrimaryColor,
                                        value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null &&
                                                loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes
                                            : null,
                                      ),
                                    );
                                  },
                                )
                              : Icon(
                                  Icons.account_circle,
                                  size: 35,
                                  color: greyColor,
                                ))
                      : Container(width: 35.0),
                  Container(
                    child: Text(
                      document.get('content'),
                      style: TextStyle(color: Colors.white),
                    ),
                    padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    width: 200.0,
                    decoration: BoxDecoration(
                        color: kPrimaryColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    margin: EdgeInsets.only(left: 10.0),
                  )
                ],
              ),

              // Time
              // widget.chatViewModel.isLastMessageLeft(index)
              //     ? Container(
              //         child: Text(
              //           DateFormat('dd MMM kk:mm').format(
              //               DateTime.fromMillisecondsSinceEpoch(
              //                   int.parse(document.get('timestamp')))),
              //           style: TextStyle(
              //               color: greyColor,
              //               fontSize: 12.0,
              //               fontStyle: FontStyle.italic),
              //         ),
              //         margin:
              //             EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
              //       )
              //     : Container()
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: EdgeInsets.only(bottom: 10.0),
        );
      }
    } else {
      return SizedBox.shrink();
    }
  }

  Widget buildInput() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        child: Row(
          children: <Widget>[
            // Edit text
            Flexible(
              child: Container(
                child: TextField(
                  onSubmitted: (value) {
                    listScrollController.animateTo(0.0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeOut);
                  },
                  style: TextStyle(color: kPrimaryColor, fontSize: 15.0),
                  controller: chatViewModel.textController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: greyColor),
                  ),
                  focusNode: focusNode,
                ),
              ),
            ),

            // Button send message
            Material(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.0),
                child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (chatViewModel.textController.text.trim() != '') {
                      widget.chatViewModel.sendMessageToExpert();
                      focusNode.requestFocus();
                      firstMessageSent = true;
                    }
                  },
                  color: kPrimaryColor,
                ),
              ),
              color: Colors.white,
            ),
          ],
        ),
        width: double.infinity,
        height: 50.0,
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: lightGreyColor, width: 0.5)),
            color: Colors.white),
      )
    ]);
  }

  Widget buildListMessages() {
    return Flexible(
        child: StreamBuilder(
      stream: widget.chatViewModel.loadMessages(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemBuilder: (context, index) =>
                buildItem(index, snapshot.data?.docs[index]),
            itemCount: snapshot.data.docs.length,
            reverse: true,
            controller: listScrollController,
          );
        } else {
          return LoadingDialog(text: 'Loading messages...');
        }
      },
    ));
  }

  _scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limitIncrement += _limitIncrement;
      });
    }
  }

  Future<bool> onBackPress() {
    widget.chatViewModel.resetChat();
    if (!firstMessageSent) widget.chatViewModel.deleteChat();
    Navigator.pop(context);
    return Future.value(false);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      widget.chatViewModel.updateChattingWith();
    } else {
      widget.chatViewModel.resetChat();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
