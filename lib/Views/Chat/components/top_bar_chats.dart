import 'package:sApport/Model/DBItems/Expert/expert.dart';
import 'package:sApport/Router/app_router_delegate.dart';
import 'package:sApport/ViewModel/chat_view_model.dart';
import 'package:sApport/Views/components/network_avatar.dart';
import 'package:sApport/Views/Profile/expert_profile_screen.dart';
import 'package:sApport/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TopBarChats extends StatelessWidget {
  final String text;
  final CircleAvatar? circleAvatar;
  final NetworkAvatar? networkAvatar;

  TopBarChats({Key? key, required this.text, this.circleAvatar, this.networkAvatar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRouterDelegate routerDelegate = Provider.of<AppRouterDelegate>(context, listen: false);
    ChatViewModel chatViewModel = Provider.of<ChatViewModel>(context, listen: false);
    Size size = MediaQuery.of(context).size;
    return Container(
      color: kPrimaryColor,
      child: SafeArea(
        child: Container(
          height: size.height / 10,
          decoration: BoxDecoration(color: kPrimaryColor),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Row(
                  children: <Widget>[
                    if (MediaQuery.of(context).orientation == Orientation.portrait) ...[
                      SizedBox(
                        width: size.width * 0.01,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          FocusScope.of(context).unfocus();
                          chatViewModel.resetChattingWith();
                          chatViewModel.resetCurrentChat();
                          routerDelegate.pop();
                        },
                      ),
                    ] else ...[
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                    ],
                    SizedBox(
                      width: size.width * 0.01,
                    ),
                    Flexible(
                      child: GestureDetector(
                        child: Row(
                          children: [
                            circleAvatar ?? networkAvatar ?? Container(),
                            circleAvatar != null || networkAvatar != null
                                ? SizedBox(
                                    width: size.width * 0.03,
                                  )
                                : Container(),
                            Text(
                              text,
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        onTap: () {
                          if (networkAvatar != null) {
                            routerDelegate.pushPage(name: ExpertProfileScreen.route, arguments: chatViewModel.currentChat.value!.peerUser as Expert);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
