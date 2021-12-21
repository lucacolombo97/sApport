import 'package:provider/provider.dart';
import 'package:sApport/Model/Chat/chat.dart';
import 'package:sApport/Router/app_router_delegate.dart';
import 'package:sApport/ViewModel/chat_view_model.dart';
import 'package:sApport/Views/Chat/BaseUser/ChatWithExperts/components/expert_chats_list_body.dart';
import 'package:flutter/material.dart';
import 'package:sApport/Views/Chat/ChatPage/components/chat_page_body.dart';
import 'package:sApport/Views/components/empty_landscape_body.dart';
import 'package:sApport/Views/components/vertical_split_view.dart';
import 'package:sApport/constants.dart';

class ExpertChatsListScreen extends StatefulWidget {
  static const route = '/expertChatsListScreen';
  final Widget? chatPage;

  const ExpertChatsListScreen({Key? key, this.chatPage}) : super(key: key);

  @override
  State<ExpertChatsListScreen> createState() => _ExpertChatsListScreenState();
}

class _ExpertChatsListScreenState extends State<ExpertChatsListScreen> {
  late ChatViewModel chatViewModel;

  @override
  void initState() {
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? ExpertChatsListBody()
          : VerticalSplitView(
              left: ExpertChatsListBody(),
              right: ValueListenableBuilder(
                valueListenable: chatViewModel.currentChat,
                builder: (context, Chat? chat, child) {
                  if (chat != null) {
                    return ChatPageBody(key: ValueKey(chat.peerUser!.id));
                  } else {
                    return EmptyLandscapeBody();
                  }
                },
              ),
              ratio: 0.35,
              dividerWidth: 0.3,
              dividerColor: kPrimaryGreyColor,
            ),
    );
  }
}
