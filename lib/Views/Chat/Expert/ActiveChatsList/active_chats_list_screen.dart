import 'package:provider/provider.dart';
import 'package:sApport/Router/app_router_delegate.dart';
import 'package:sApport/ViewModel/chat_view_model.dart';
import 'package:flutter/material.dart';
import 'package:sApport/Views/Chat/ChatPage/components/chat_page_body.dart';
import 'package:sApport/Views/Chat/Expert/ActiveChatsList/components/active_chats_list_body.dart';
import 'package:sApport/Views/components/empty_landscape_body.dart';
import 'package:sApport/Views/components/vertical_split_view.dart';
import 'package:sApport/constants.dart';

class ActiveChatsListScreen extends StatefulWidget {
  static const route = '/activeChatsListScreen';

  const ActiveChatsListScreen({Key key}) : super(key: key);

  @override
  State<ActiveChatsListScreen> createState() => _ActiveChatsListScreenState();
}

class _ActiveChatsListScreenState extends State<ActiveChatsListScreen> {
  ChatViewModel chatViewModel;
  AppRouterDelegate routerDelegate;

  @override
  void initState() {
    routerDelegate = Provider.of<AppRouterDelegate>(context, listen: false);
    chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: MediaQuery.of(context).orientation == Orientation.portrait
          ? ActiveChatsListBody()
          : VerticalSplitView(
              left: ActiveChatsListBody(),
              right: Consumer<ChatViewModel>(
                builder: (context, chatViewModel, child) {
                  if (chatViewModel.currentChat != null) {
                    return ChatPageBody(key: ValueKey(chatViewModel.currentChat.peerUser.id));
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