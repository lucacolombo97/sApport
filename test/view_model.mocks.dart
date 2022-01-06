// Mocks generated by Mockito 5.0.17 from annotations
// in sApport/test/Views/Profile/expert_profile_screen_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i11;
import 'dart:collection' as _i4;
import 'dart:ui' as _i12;

import 'package:cloud_firestore/cloud_firestore.dart' as _i5;
import 'package:flutter/widgets.dart' as _i3;
import 'package:geolocator/geolocator.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:permission_handler/permission_handler.dart' as _i20;
import 'package:sApport/Model/Chat/chat.dart' as _i18;
import 'package:sApport/Model/DBItems/BaseUser/diary_page.dart' as _i10;
import 'package:sApport/Model/DBItems/BaseUser/report.dart' as _i14;
import 'package:sApport/Model/DBItems/user.dart' as _i16;
import 'package:sApport/Model/Map/place.dart' as _i7;
import 'package:sApport/Model/Services/map_service.dart' as _i6;
import 'package:sApport/ViewModel/auth_view_model.dart' as _i15;
import 'package:sApport/ViewModel/BaseUser/Diary/diary_form.dart' as _i2;
import 'package:sApport/ViewModel/BaseUser/Diary/diary_view_model.dart' as _i9;
import 'package:sApport/ViewModel/BaseUser/report_view_model.dart' as _i13;
import 'package:sApport/ViewModel/chat_view_model.dart' as _i17;
import 'package:sApport/ViewModel/map_view_model.dart' as _i19;
import 'package:sApport/ViewModel/user_view_model.dart' as _i21;
import 'package:sApport/Views/Forms/Authentication/base_user_signup_form.dart'
    as _i22;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeDiaryForm_0 extends _i1.Fake implements _i2.DiaryForm {}

class _FakeTextEditingController_1 extends _i1.Fake
    implements _i3.TextEditingController {}

class _FakeValueNotifier_2<T> extends _i1.Fake implements _i3.ValueNotifier<T> {
}

class _FakeLinkedHashMap_3<K, V> extends _i1.Fake
    implements _i4.LinkedHashMap<K, V> {}

class _FakeQuerySnapshot_4<T extends Object?> extends _i1.Fake
    implements _i5.QuerySnapshot<T> {}

class _FakeMapService_5 extends _i1.Fake implements _i6.MapService {}

class _FakePlace_6 extends _i1.Fake implements _i7.Place {}

class _FakePosition_7 extends _i1.Fake implements _i8.Position {}

/// A class which mocks [DiaryViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockDiaryViewModel extends _i1.Mock implements _i9.DiaryViewModel {
  MockDiaryViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.DiaryForm get diaryForm =>
      (super.noSuchMethod(Invocation.getter(#diaryForm),
          returnValue: _FakeDiaryForm_0()) as _i2.DiaryForm);
  @override
  _i3.TextEditingController get titleTextCtrl =>
      (super.noSuchMethod(Invocation.getter(#titleTextCtrl),
              returnValue: _FakeTextEditingController_1())
          as _i3.TextEditingController);
  @override
  _i3.TextEditingController get contentTextCtrl =>
      (super.noSuchMethod(Invocation.getter(#contentTextCtrl),
              returnValue: _FakeTextEditingController_1())
          as _i3.TextEditingController);
  @override
  _i3.ValueNotifier<_i10.DiaryPage?> get currentDiaryPage =>
      (super.noSuchMethod(Invocation.getter(#currentDiaryPage),
              returnValue: _FakeValueNotifier_2<_i10.DiaryPage?>())
          as _i3.ValueNotifier<_i10.DiaryPage?>);
  @override
  bool get isEditing =>
      (super.noSuchMethod(Invocation.getter(#isEditing), returnValue: false)
          as bool);
  @override
  _i11.Stream<bool> get isPageAdded =>
      (super.noSuchMethod(Invocation.getter(#isPageAdded),
          returnValue: Stream<bool>.empty()) as _i11.Stream<bool>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i11.Future<void> submitPage() => (super.noSuchMethod(
      Invocation.method(#submitPage, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  _i11.Future<void> updatePage() => (super.noSuchMethod(
      Invocation.method(#updatePage, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  _i11.Future<void> setFavourite(bool? isFavourite) => (super.noSuchMethod(
      Invocation.method(#setFavourite, [isFavourite]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void loadDiaryPages() =>
      super.noSuchMethod(Invocation.method(#loadDiaryPages, []),
          returnValueForMissingStub: null);
  @override
  void editPage() => super.noSuchMethod(Invocation.method(#editPage, []),
      returnValueForMissingStub: null);
  @override
  void setCurrentDiaryPage(_i10.DiaryPage? diaryPage) =>
      super.noSuchMethod(Invocation.method(#setCurrentDiaryPage, [diaryPage]),
          returnValueForMissingStub: null);
  @override
  void resetCurrentDiaryPage() =>
      super.noSuchMethod(Invocation.method(#resetCurrentDiaryPage, []),
          returnValueForMissingStub: null);
  @override
  void closeListeners() =>
      super.noSuchMethod(Invocation.method(#closeListeners, []),
          returnValueForMissingStub: null);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [ReportViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockReportViewModel extends _i1.Mock implements _i13.ReportViewModel {
  MockReportViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.ValueNotifier<_i14.Report?> get currentReport =>
      (super.noSuchMethod(Invocation.getter(#currentReport),
              returnValue: _FakeValueNotifier_2<_i14.Report?>())
          as _i3.ValueNotifier<_i14.Report?>);
  @override
  _i4.LinkedHashMap<String, _i14.Report> get reports =>
      (super.noSuchMethod(Invocation.getter(#reports),
              returnValue: _FakeLinkedHashMap_3<String, _i14.Report>())
          as _i4.LinkedHashMap<String, _i14.Report>);
  @override
  void setCurrentReport(_i14.Report? report) =>
      super.noSuchMethod(Invocation.method(#setCurrentReport, [report]),
          returnValueForMissingStub: null);
  @override
  void resetCurrentReport() =>
      super.noSuchMethod(Invocation.method(#resetCurrentReport, []),
          returnValueForMissingStub: null);
  @override
  void closeListeners() =>
      super.noSuchMethod(Invocation.method(#closeListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [AuthViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthViewModel extends _i1.Mock implements _i15.AuthViewModel {
  MockAuthViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i11.Stream<bool> get isUserLogged =>
      (super.noSuchMethod(Invocation.getter(#isUserLogged),
          returnValue: Stream<bool>.empty()) as _i11.Stream<bool>);
  @override
  _i11.Stream<bool> get isUserCreated =>
      (super.noSuchMethod(Invocation.getter(#isUserCreated),
          returnValue: Stream<bool>.empty()) as _i11.Stream<bool>);
  @override
  _i11.Stream<String?> get authMessage =>
      (super.noSuchMethod(Invocation.getter(#authMessage),
          returnValue: Stream<String?>.empty()) as _i11.Stream<String?>);
  @override
  _i11.Future<void> logIn(String? email, String? password) =>
      (super.noSuchMethod(Invocation.method(#logIn, [email, password]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i11.Future<void>);
  @override
  _i11.Future<void> signUpUser(
          String? email, String? password, _i16.User? newUser) =>
      (super.noSuchMethod(
              Invocation.method(#signUpUser, [email, password, newUser]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i11.Future<void>);
  @override
  _i11.Future<void> logInWithGoogle({bool? link = false}) => (super
          .noSuchMethod(Invocation.method(#logInWithGoogle, [], {#link: link}),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
      as _i11.Future<void>);
  @override
  _i11.Future<void> logInWithFacebook({bool? link = false}) =>
      (super.noSuchMethod(
              Invocation.method(#logInWithFacebook, [], {#link: link}),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i11.Future<void>);
  @override
  void resetPassword(String? email) =>
      super.noSuchMethod(Invocation.method(#resetPassword, [email]),
          returnValueForMissingStub: null);
  @override
  String authProvider() =>
      (super.noSuchMethod(Invocation.method(#authProvider, []), returnValue: '')
          as String);
  @override
  _i11.Future<bool> hasPasswordAuthentication(String? email) => (super
      .noSuchMethod(Invocation.method(#hasPasswordAuthentication, [email]),
          returnValue: Future<bool>.value(false)) as _i11.Future<bool>);
  @override
  _i11.Future<void> logOut() => (super.noSuchMethod(
      Invocation.method(#logOut, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void setNotification(_i16.User? loggedUser) =>
      super.noSuchMethod(Invocation.method(#setNotification, [loggedUser]),
          returnValueForMissingStub: null);
  @override
  _i11.Future<void> deleteUser(_i16.User? loggedUser) => (super.noSuchMethod(
      Invocation.method(#deleteUser, [loggedUser]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void clearAuthMessage() =>
      super.noSuchMethod(Invocation.method(#clearAuthMessage, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [ChatViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockChatViewModel extends _i1.Mock implements _i17.ChatViewModel {
  MockChatViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.TextEditingController get contentTextCtrl =>
      (super.noSuchMethod(Invocation.getter(#contentTextCtrl),
              returnValue: _FakeTextEditingController_1())
          as _i3.TextEditingController);
  @override
  _i3.ValueNotifier<_i18.Chat?> get currentChat =>
      (super.noSuchMethod(Invocation.getter(#currentChat),
              returnValue: _FakeValueNotifier_2<_i18.Chat?>())
          as _i3.ValueNotifier<_i18.Chat?>);
  @override
  _i11.Stream<bool> get newRandomUser =>
      (super.noSuchMethod(Invocation.getter(#newRandomUser),
          returnValue: Stream<bool>.empty()) as _i11.Stream<bool>);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  _i11.Future<void> updateChattingWith() => (super.noSuchMethod(
      Invocation.method(#updateChattingWith, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  _i11.Future<void> resetChattingWith() => (super.noSuchMethod(
      Invocation.method(#resetChattingWith, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void sendMessage() => super.noSuchMethod(Invocation.method(#sendMessage, []),
      returnValueForMissingStub: null);
  @override
  _i11.Future<void> setMessagesHasRead() => (super.noSuchMethod(
      Invocation.method(#setMessagesHasRead, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void loadAnonymousChats() =>
      super.noSuchMethod(Invocation.method(#loadAnonymousChats, []),
          returnValueForMissingStub: null);
  @override
  void loadPendingChats() =>
      super.noSuchMethod(Invocation.method(#loadPendingChats, []),
          returnValueForMissingStub: null);
  @override
  void loadExpertsChats() =>
      super.noSuchMethod(Invocation.method(#loadExpertsChats, []),
          returnValueForMissingStub: null);
  @override
  void loadActiveChats() =>
      super.noSuchMethod(Invocation.method(#loadActiveChats, []),
          returnValueForMissingStub: null);
  @override
  _i11.Future<_i5.QuerySnapshot<Object?>> getPeerUserDoc(
          String? collection, String? id) =>
      (super.noSuchMethod(Invocation.method(#getPeerUserDoc, [collection, id]),
              returnValue: Future<_i5.QuerySnapshot<Object?>>.value(
                  _FakeQuerySnapshot_4<Object?>()))
          as _i11.Future<_i5.QuerySnapshot<Object?>>);
  @override
  _i11.Future<void> getNewRandomUser() => (super.noSuchMethod(
      Invocation.method(#getNewRandomUser, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void acceptPendingChat() =>
      super.noSuchMethod(Invocation.method(#acceptPendingChat, []),
          returnValueForMissingStub: null);
  @override
  void denyPendingChat() =>
      super.noSuchMethod(Invocation.method(#denyPendingChat, []),
          returnValueForMissingStub: null);
  @override
  void addNewChat(_i18.Chat? chat) =>
      super.noSuchMethod(Invocation.method(#addNewChat, [chat]),
          returnValueForMissingStub: null);
  @override
  void setCurrentChat(_i18.Chat? chat) =>
      super.noSuchMethod(Invocation.method(#setCurrentChat, [chat]),
          returnValueForMissingStub: null);
  @override
  void resetCurrentChat() =>
      super.noSuchMethod(Invocation.method(#resetCurrentChat, []),
          returnValueForMissingStub: null);
  @override
  void closeListeners() =>
      super.noSuchMethod(Invocation.method(#closeListeners, []),
          returnValueForMissingStub: null);
  @override
  void addListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i12.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [MapViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockMapViewModel extends _i1.Mock implements _i19.MapViewModel {
  MockMapViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.MapService get mapService =>
      (super.noSuchMethod(Invocation.getter(#mapService),
          returnValue: _FakeMapService_5()) as _i6.MapService);
  @override
  _i3.TextEditingController get searchTextCtrl =>
      (super.noSuchMethod(Invocation.getter(#searchTextCtrl),
              returnValue: _FakeTextEditingController_1())
          as _i3.TextEditingController);
  @override
  _i20.PermissionStatus get positionPermission =>
      (super.noSuchMethod(Invocation.getter(#positionPermission),
          returnValue: _i20.PermissionStatus.denied) as _i20.PermissionStatus);
  @override
  set positionPermission(_i20.PermissionStatus? _positionPermission) => super
      .noSuchMethod(Invocation.setter(#positionPermission, _positionPermission),
          returnValueForMissingStub: null);
  @override
  _i11.Stream<_i7.Place?> get selectedPlace =>
      (super.noSuchMethod(Invocation.getter(#selectedPlace),
          returnValue: Stream<_i7.Place?>.empty()) as _i11.Stream<_i7.Place?>);
  @override
  _i11.Stream<List<_i7.Place>?> get autocompletedPlaces =>
      (super.noSuchMethod(Invocation.getter(#autocompletedPlaces),
              returnValue: Stream<List<_i7.Place>?>.empty())
          as _i11.Stream<List<_i7.Place>?>);
  @override
  _i11.Future<bool> askPermission() =>
      (super.noSuchMethod(Invocation.method(#askPermission, []),
          returnValue: Future<bool>.value(false)) as _i11.Future<bool>);
  @override
  _i11.Future<void> autocompleteSearchedPlace() => (super.noSuchMethod(
      Invocation.method(#autocompleteSearchedPlace, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  _i11.Future<_i7.Place> firstSimilarPlace(String? input) =>
      (super.noSuchMethod(Invocation.method(#firstSimilarPlace, [input]),
              returnValue: Future<_i7.Place>.value(_FakePlace_6()))
          as _i11.Future<_i7.Place>);
  @override
  _i11.Future<void> searchPlace(String? placeId) => (super.noSuchMethod(
      Invocation.method(#searchPlace, [placeId]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  _i11.Future<_i8.Position> loadCurrentPosition() =>
      (super.noSuchMethod(Invocation.method(#loadCurrentPosition, []),
              returnValue: Future<_i8.Position>.value(_FakePosition_7()))
          as _i11.Future<_i8.Position>);
  @override
  _i11.Future<_i5.QuerySnapshot<Object?>?> loadExperts() =>
      (super.noSuchMethod(Invocation.method(#loadExperts, []),
              returnValue: Future<_i5.QuerySnapshot<Object?>?>.value())
          as _i11.Future<_i5.QuerySnapshot<Object?>?>);
  @override
  void clearControllers() =>
      super.noSuchMethod(Invocation.method(#clearControllers, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [UserViewModel].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserViewModel extends _i1.Mock implements _i21.UserViewModel {
  MockUserViewModel() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i11.Future<void> loadLoggedUser() => (super.noSuchMethod(
      Invocation.method(#loadLoggedUser, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i11.Future<void>);
  @override
  void createUser(_i22.BaseUserSignUpForm? baseUserSignUpForm) =>
      super.noSuchMethod(Invocation.method(#createUser, [baseUserSignUpForm]),
          returnValueForMissingStub: null);
}