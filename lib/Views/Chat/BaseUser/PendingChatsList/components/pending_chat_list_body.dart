import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sApport/Views/components/top_bar.dart';
import 'package:sApport/ViewModel/chat_view_model.dart';
import 'package:sApport/Views/Chat/components/chat_list_constructor.dart';

/// Body of the pending chat list page.
///
/// It contains the top bar and the chat list constructor of the pending chats.
class PendingChatListBody extends StatefulWidget {
  /// Body of the pending chat list page.
  ///
  /// It contains the top bar and the chat list constructor of the pending chats.
  const PendingChatListBody({Key? key}) : super(key: key);

  @override
  _PendingChatListBodyState createState() => _PendingChatListBodyState();
}

class _PendingChatListBodyState extends State<PendingChatListBody> {
  // View Models
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TopBar(back: chatViewModel.resetCurrentChat, text: "Requests"),
          ChatListConstructor(valueNotifier: chatViewModel.pendingChats),
        ],
      ),
    );
  }
}
