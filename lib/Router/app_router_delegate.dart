import 'package:sApport/Model/BaseUser/report.dart';
import 'package:sApport/ViewModel/BaseUser/base_user_info_view_model.dart';
import 'package:sApport/ViewModel/BaseUser/report_view_model.dart';
import 'package:sApport/ViewModel/user_view_model.dart';
import 'package:sApport/Views/Chat/BaseUser/AnonymousChat/ActiveChatsList/active_chats_list_screen.dart';
import 'package:sApport/Views/Chat/BaseUser/AnonymousChat/PendingChatsList/pending_chats_list_screen.dart';
import 'package:sApport/Views/Chat/BaseUser/ChatWithExperts/expert_chats_list_screen.dart';
import 'package:sApport/Views/Chat/ChatPage/chat_page_screen.dart';
import 'package:sApport/Views/Home/Expert/expert_home_page_screen.dart';
import 'package:sApport/Views/Diary/diary_page_screen.dart';
import 'package:sApport/Views/Diary/diary_screen.dart';
import 'package:sApport/Views/Home/BaseUser/base_user_home_page_screen.dart';
import 'package:sApport/Views/Login/forgot_password_screen.dart';
import 'package:sApport/Views/Login/login_screen.dart';
import 'package:sApport/Views/Map/map_screen.dart';
import 'package:sApport/Views/Profile/expert_profile_screen.dart';
import 'package:sApport/Views/Report/create_report_screen.dart';
import 'package:sApport/Views/Report/report_details_screen.dart';
import 'package:sApport/Views/Report/reports_list_screen.dart';
import 'package:sApport/Views/Settings/user_settings_screen.dart';
import 'package:sApport/Views/Signup/BaseUser/base_users_signup_screen.dart';
import 'package:sApport/Views/Signup/Expert/experts_signup_screen.dart';
import 'package:sApport/Views/Signup/credential_screen.dart';
import 'package:sApport/Views/Welcome/welcome_screen.dart';

import 'package:flutter/material.dart';

class InfoArguments {
  final BaseUserInfoViewModel userInfoViewModel;
  final UserViewModel userViewModel;

  InfoArguments(this.userInfoViewModel, this.userViewModel);
}

class ReportArguments {
  final Widget reportPage;
  final ReportViewModel reportViewModel;

  ReportArguments(this.reportPage, this.reportViewModel);
}

class ReportDetailsArguments {
  final Report report;
  final ReportViewModel reportViewModel;

  ReportDetailsArguments(this.report, this.reportViewModel);
}

class AppRouterDelegate extends RouterDelegate<List<RouteSettings>> with ChangeNotifier, PopNavigatorRouterDelegateMixin<List<RouteSettings>> {
  final _pages = <Page>[];
  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: List.of(_pages),
      onPopPage: _onPopPage,
    );
  }

  bool _onPopPage(Route route, dynamic result) {
    if (!route.didPop(result)) return false;
    popRoute();
    return true;
  }

  @override
  Future<bool> popRoute() {
    if (_pages.length > 1 && _pages.last.name != BaseUserHomePageScreen.route && _pages.last.name != ExpertHomePageScreen.route) {
      _pages.removeLast();
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  MaterialPage _createPage(RouteSettings routeSettings) {
    Widget child;
    switch (routeSettings.name) {
      case WelcomeScreen.route:
        child = WelcomeScreen();
        break;
      case CredentialScreen.route:
        child = CredentialScreen(
            infoViewModel: (routeSettings.arguments as InfoArguments).userInfoViewModel,
            userViewModel: (routeSettings.arguments as InfoArguments).userViewModel);
        break;
      case ExpertsSignUpScreen.route:
        child = ExpertsSignUpScreen();
        break;
      case BaseUsersSignUpScreen.route:
        child = BaseUsersSignUpScreen();
        break;
      case ReportsListScreen.route:
        child = ReportsListScreen(
          reportPage: (routeSettings.arguments as ReportArguments).reportPage,
          reportViewModel: (routeSettings.arguments as ReportArguments).reportViewModel,
        );
        break;
      case ReportDetailsScreen.route:
        child = ReportDetailsScreen(
          reportViewModel: (routeSettings.arguments as ReportDetailsArguments).reportViewModel,
        );
        break;
      case CreateReportScreen.route:
        child = CreateReportScreen();
        break;
      case ExpertProfileScreen.route:
        child = ExpertProfileScreen(expert: routeSettings.arguments);
        break;
      case MapScreen.route:
        child = MapScreen();
        break;
      case LoginScreen.route:
        child = LoginScreen();
        break;
      case ForgotPasswordScreen.route:
        child = ForgotPasswordScreen();
        break;
      case UserSettingsScreen.route:
        child = UserSettingsScreen(user: routeSettings.arguments);
        break;
      case ExpertHomePageScreen.route:
        child = ExpertHomePageScreen(
          pageIndex: routeSettings.arguments,
        );
        break;
      case BaseUserHomePageScreen.route:
        child = BaseUserHomePageScreen(
          pageIndex: routeSettings.arguments,
        );
        break;
      case ChatPageScreen.route:
        child = ChatPageScreen();
        break;
      case ExpertChatsListScreen.route:
        child = ExpertChatsListScreen(
          chatPage: routeSettings.arguments,
        );
        break;
      case PendingChatsListScreen.route:
        child = PendingChatsListScreen();
        break;
      case ActiveChatsListScreen.route:
        child = ActiveChatsListScreen(
          chatPage: routeSettings.arguments,
        );
        break;
      case DiaryScreen.route:
        child = DiaryScreen();
        break;
      case DiaryPageScreen.route:
        child = DiaryPageScreen(
          diaryNote: routeSettings.arguments,
        );
        break;
    }
    return MaterialPage(
      child: child,
      key: Key(routeSettings.name),
      name: routeSettings.name,
      arguments: routeSettings.arguments,
    );
  }

  void pushPage({@required String name, dynamic arguments}) {
    if (_pages.isEmpty || _pages.last.name != name) {
      _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
      notifyListeners();
    }
  }

  void pop() {
    popRoute();
  }

  void replace({@required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.removeLast();
    }
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  void replaceAll({@required String name, dynamic arguments}) {
    if (_pages.isNotEmpty) {
      _pages.clear();
    }
    _pages.add(_createPage(RouteSettings(name: name, arguments: arguments)));
    notifyListeners();
  }

  void replaceAllButNumber(int start, List<RouteSettings> list) {
    if (_pages.isNotEmpty) {
      _pages.removeRange(start, _pages.length);
    }
    list.forEach((item) {
      _pages.add(_createPage(RouteSettings(name: item.name, arguments: item.arguments)));
    });
    notifyListeners();
  }

  void addAll(List<RouteSettings> list) {
    _pages.clear();
    list.forEach((item) {
      _pages.add(_createPage(RouteSettings(name: item.name, arguments: item.arguments)));
    });
    notifyListeners();
  }

  @override
  Future<void> setNewRoutePath(configuration) async {/* Do Nothing */}
}
