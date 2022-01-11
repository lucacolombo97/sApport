import 'dart:async';
import 'package:test/test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:sApport/Model/Services/user_service.dart';
import 'package:sApport/Model/Services/firestore_service.dart';
import 'package:sApport/Model/DBItems/BaseUser/diary_page.dart';
import 'package:sApport/ViewModel/BaseUser/Diary/diary_form.dart';
import 'package:sApport/ViewModel/BaseUser/Diary/diary_view_model.dart';
import '../../../service.mocks.dart';
import '../../../test_helper.dart';
import '../../chat_view_model_test.dart';
import 'diary_view_model_test.mocks.dart';

@GenerateMocks([DiaryForm])
void main() async {
  /// Fake Firebase
  final fakeFirebase = FakeFirebaseFirestore();

  /// Mock Services
  final mockFirestoreService = MockFirestoreService();
  final mockUserService = MockUserService();
  final mockDiaryForm = MockDiaryForm();

  var getIt = GetIt.I;
  getIt.registerSingleton<FirestoreService>(mockFirestoreService);
  getIt.registerSingleton<UserService>(mockUserService);

  /// Test Helper
  final testHelper = TestHelper();
  await testHelper.attachDB(fakeFirebase);

  /// Mock User Service responses
  when(mockUserService.loggedUser).thenAnswer((_) => testHelper.loggedUser);

  /// Mock FirestoreService responses
  when(mockFirestoreService.getDiaryPagesStreamFromDB(testHelper.loggedUser.id)).thenAnswer((_) => testHelper.diaryPagesStream);

  final diaryViewModel = DiaryViewModel();
  var now = DateTime.now();

  group("DiaryViewModel initialization:", () {
    test("Check that the diary form is correctly initialized", () {
      expect(diaryViewModel.diaryForm, isA<DiaryForm>());
    });

    test("Check that the title text controller is correctly initialized and has the listener attached", () {
      expect(diaryViewModel.titleTextCtrl, isA<TextEditingController>());
      // ignore: invalid_use_of_protected_member
      expect(diaryViewModel.titleTextCtrl.hasListeners, true);
    });

    test("Check that the content text controller is correctly initialized", () {
      expect(diaryViewModel.contentTextCtrl, isA<TextEditingController>());
      // ignore: invalid_use_of_protected_member
      expect(diaryViewModel.contentTextCtrl.hasListeners, true);
    });

    test("Check that the current diary page is correctly initialized to the value notifier with null value", () {
      expect(diaryViewModel.currentDiaryPage, isA<ValueNotifier<DiaryPage?>>());
      expect(diaryViewModel.currentDiaryPage.value, isNull);
    });

    test("Check that the diary pages list is correctly initialized to the value notifier with an empty list", () {
      expect(diaryViewModel.diaryPages, isA<ValueNotifier<List<DiaryPage>>>());
      expect(diaryViewModel.diaryPages.value, isEmpty);
    });

    test("Check that is editing is correctly initialized to false", () {
      expect(diaryViewModel.isEditing, isFalse);
    });
  });

  group("DiaryViewModel interaction with services:", () {
    setUp(() => clearInteractions(mockFirestoreService));

    group("Load diary pages:", () {
      var modifiedDiaryPage = DiaryPage(
        id: testHelper.diaryPage.id,
        title: testHelper.diaryPage.title,
        content: testHelper.diaryPage.content,
        dateTime: testHelper.diaryPage.dateTime,
      );
      var diaryPage4 = DiaryPage(
        id: DateTime(2022, 1, 8).millisecondsSinceEpoch.toString(),
        title: "Diary page fourth title",
        content: "Diary page fourth content",
        dateTime: DateTime(2022, 1, 8),
      );

      setUp(() async {
        diaryViewModel.resetViewModel();

        /// Removes the new added diary page from the DB
        fakeFirebase
            .collection(DiaryPage.COLLECTION)
            .doc(testHelper.loggedUser.id)
            .collection("diaryPages")
            .doc(diaryPage4.dateTime.millisecondsSinceEpoch.toString())
            .delete();

        await fakeFirebase.collection("support").doc("${modifiedDiaryPage.id}").delete();
      });

      test("Check the subscription of the diaryPagesSubscriber to the diary page stream of the firestore service", () async {
        /// Load the diary pages
        diaryViewModel.loadDiaryPages();
        await Future.delayed(Duration.zero);

        expect(diaryViewModel.diaryPagesSubscriber, isA<StreamSubscription<QuerySnapshot>>());
      });

      test("Check that the value notifier notify the listeners every time a new diary page is added into the list of diary pages", () async {
        int counter = 0;
        var listener = () => counter++;
        diaryViewModel.diaryPages.addListener(listener);

        /// Load the anonymous chats
        diaryViewModel.loadDiaryPages();
        await Future.delayed(Duration.zero);

        expect(counter, testHelper.diaryPages.length);
        diaryViewModel.diaryPages.removeListener(listener);
      });

      test("Check that the initially inserted diary pages are correctly parsed and added to the list of diary pages in the correct order", () async {
        /// Load the diary pages
        diaryViewModel.loadDiaryPages();
        await Future.delayed(Duration.zero);

        for (int i = 0; i < testHelper.diaryPages.length; i++) {
          expect(diaryViewModel.diaryPages.value[i].id, testHelper.diaryPages[i].id);
          expect(diaryViewModel.diaryPages.value[i].title, testHelper.diaryPages[i].title);
          expect(diaryViewModel.diaryPages.value[i].content, testHelper.diaryPages[i].content);
          expect(diaryViewModel.diaryPages.value[i].dateTime, testHelper.diaryPages[i].dateTime);
          expect(diaryViewModel.diaryPages.value[i].favourite, testHelper.diaryPages[i].favourite);
        }
      });

      test("Modifying an old diary page will trigger the listener that should update the page in the list", () async {
        var modifiedList = testHelper.diaryPages;
        modifiedList[0] = modifiedDiaryPage;
        diaryViewModel.diaryPages.value = modifiedList;

        modifiedDiaryPage.title = "New title";
        modifiedDiaryPage.content = "New content";
        modifiedDiaryPage.favourite = !modifiedDiaryPage.favourite;

        /// Add the page in a support collection of the DB
        await fakeFirebase.collection("support").doc("${modifiedDiaryPage.id}").set(modifiedDiaryPage.data);

        var listener;
        var callback = expectAsync1((int lastPos) {
          /// The modified diary page should be updated and should be in the same position as before (0)
          expect(diaryViewModel.diaryPages.value[0].id, modifiedDiaryPage.id);
          expect(diaryViewModel.diaryPages.value[0].title, modifiedDiaryPage.title);
          expect(diaryViewModel.diaryPages.value[0].content, modifiedDiaryPage.content);
          expect(diaryViewModel.diaryPages.value[0].dateTime, modifiedDiaryPage.dateTime);
          expect(diaryViewModel.diaryPages.value[0].favourite, modifiedDiaryPage.favourite);

          for (int i = 1; i < lastPos; i++) {
            /// The other diary pages should be in their precedent positions, but the first one should be modified
            expect(diaryViewModel.diaryPages.value[i].id, testHelper.diaryPages[i].id);
          }
          diaryViewModel.diaryPages.removeListener(listener);
        }, count: 1);

        listener = () => callback(diaryViewModel.diaryPages.value.length - 1);
        diaryViewModel.diaryPages.addListener(listener);

        /// The fake firestore doc changes doesn't work properly, so we need to manually simulate the response
        /// with docChanges
        when(mockFirestoreService.getDiaryPagesStreamFromDB(testHelper.loggedUser.id)).thenAnswer((_) async* {
          var snapshot = await testHelper.diaryPagesStream.first;
          var mockSnapshot = MockQuerySnapshot();
          var newDocChanges = <MockDocumentChange>[];

          /// We need to manually change the old index of the old chat that has been modified
          for (var docChange in snapshot.docChanges) {
            /// We simulate that diaryPageThatWillBeModified that was in position 0 is modified
            if (docChange.doc.id == modifiedDiaryPage.id) {
              var newDocChange = MockDocumentChange();
              newDocChange.oldIndex = 0;
              newDocChange.doc = await fakeFirebase.collection("support").doc("${modifiedDiaryPage.id}").get();
              newDocChanges.add(newDocChange);
            }
          }
          mockSnapshot.docChanges.clear();
          mockSnapshot.docChanges = newDocChanges;
          yield mockSnapshot;
        });

        /// Load the diary pages
        diaryViewModel.loadDiaryPages();
      });

      test("Add a diary page into the DB will trigger the listener that should add this new diary page into the diary pages list", () async {
        diaryViewModel.diaryPages.value = testHelper.diaryPages;

        fakeFirebase
            .collection(DiaryPage.COLLECTION)
            .doc(testHelper.loggedUser.id)
            .collection("diaryPages")
            .doc(diaryPage4.dateTime.millisecondsSinceEpoch.toString())
            .set(diaryPage4.data);

        var listener;
        var callback = expectAsync1((int lastPos) async {
          for (int i = 0; i < lastPos - 1; i++) {
            /// The old diary pages should be in the same position as before
            expect(diaryViewModel.diaryPages.value[i].id, testHelper.diaryPages[i].id);
          }

          /// The new page should be in the last position of the list
          expect(diaryViewModel.diaryPages.value[lastPos].id, diaryPage4.id);
          expect(diaryViewModel.diaryPages.value[lastPos].title, diaryPage4.title);
          expect(diaryViewModel.diaryPages.value[lastPos].content, diaryPage4.content);
          expect(diaryViewModel.diaryPages.value[lastPos].dateTime, diaryPage4.dateTime);
          expect(diaryViewModel.diaryPages.value[lastPos].favourite, diaryPage4.favourite);

          diaryViewModel.diaryPages.removeListener(listener);
        }, count: 1);

        listener = () => callback(diaryViewModel.diaryPages.value.length - 1);
        diaryViewModel.diaryPages.addListener(listener);

        /// The fake firestore doc changes doesn't work properly, so we need to manually simulate the response
        /// with docChanges
        when(mockFirestoreService.getDiaryPagesStreamFromDB(testHelper.loggedUser.id)).thenAnswer((_) async* {
          var snapshot = await testHelper.diaryPagesStream.first;
          var mockSnapshot = MockQuerySnapshot();
          var newDocChanges = <MockDocumentChange>[];

          /// We need to manually remove the old chats from the docChanges list
          for (var docChange in snapshot.docChanges) {
            /// Elements will contain the diary page of the current docChange if it was one of the initially inserted
            /// diary pages, otherwise it will be empty
            var elements = testHelper.diaryPages.where((element) => element.id == docChange.doc.id);
            if (elements.isEmpty) {
              var newDocChange = MockDocumentChange();
              newDocChange.oldIndex = -1;
              newDocChange.doc = docChange.doc;
              newDocChanges.add(newDocChange);
            }
          }
          mockSnapshot.docChanges.clear();
          mockSnapshot.docChanges = newDocChanges;
          yield mockSnapshot;
        });

        /// Load the anonymous chats
        diaryViewModel.loadDiaryPages();
      });

      test("Check that if an error occurs when loading the diary pages it catches the error", () {
        /// Mock Firebase error
        when(mockFirestoreService.getDiaryPagesStreamFromDB(testHelper.loggedUser.id)).thenAnswer((_) async* {
          throw Exception("Firebase stream not allowed");
        });

        diaryViewModel.loadDiaryPages();
      });
    });

    group("Submit page:", () {
      test("Check that submit page sets the current diary page with the correct values", () {
        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.submitPage();

        expect(diaryViewModel.currentDiaryPage.value, isNotNull);
        expect(diaryViewModel.currentDiaryPage.value!.title, title);
        expect(diaryViewModel.currentDiaryPage.value!.content, content);
        expect(diaryViewModel.currentDiaryPage.value!.dateTime.day, now.day);
        expect(diaryViewModel.currentDiaryPage.value!.dateTime.month, now.month);
        expect(diaryViewModel.currentDiaryPage.value!.dateTime.year, now.year);
      });

      test("Submit page should set the is editing flag to false", () {
        diaryViewModel.editPage();
        diaryViewModel.submitPage();

        expect(diaryViewModel.isEditing, isFalse);
      });

      test("Submit page should call the submit diary page method of the firestore service", () {
        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.submitPage();

        var verification = verify(mockFirestoreService.addDiaryPageIntoDB(testHelper.loggedUser.id, captureAny));
        verification.called(1);

        /// Parameter Verification
        expect(verification.captured[0].title, title);
        expect(verification.captured[0].content, content);
        expect(verification.captured[0].dateTime.day, now.day);
        expect(verification.captured[0].dateTime.month, now.month);
        expect(verification.captured[0].dateTime.year, now.year);
      });

      test("Submit page should add true to the isAddedPageController if the submission was successful", () {
        expect(diaryViewModel.isPageAdded, emits(isTrue));

        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.submitPage();
      });

      test("Submit page should add false to the isAddedPageController if an error is occured", () {
        /// Mock Firebase error
        when(mockFirestoreService.addDiaryPageIntoDB(testHelper.loggedUser.id, any)).thenAnswer((_) async {
          return Future.error(Error);
        });

        expect(diaryViewModel.isPageAdded, emits(isFalse));

        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.submitPage();
      });
    });

    group("Update page:", () {
      setUp(() => diaryViewModel.setCurrentDiaryPage(testHelper.diaryPage));

      test("Check that update page sets the current diary page with the correct values", () {
        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.updatePage();

        expect(diaryViewModel.currentDiaryPage.value!.title, title);
        expect(diaryViewModel.currentDiaryPage.value!.content, content);
        expect(diaryViewModel.currentDiaryPage.value!.dateTime.day, now.day);
        expect(diaryViewModel.currentDiaryPage.value!.dateTime.month, now.month);
        expect(diaryViewModel.currentDiaryPage.value!.dateTime.year, now.year);
      });

      test("Update page should set the is editing flag to false", () {
        diaryViewModel.editPage();
        diaryViewModel.updatePage();

        expect(diaryViewModel.isEditing, isFalse);
      });

      test("Update page should call the update diary page method of the firestore service", () {
        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.updatePage();

        var verification = verify(mockFirestoreService.updateDiaryPageIntoDB(testHelper.loggedUser.id, captureAny));
        verification.called(1);

        /// Parameter Verification
        expect(verification.captured[0].title, title);
        expect(verification.captured[0].content, content);
        expect(verification.captured[0].dateTime.day, now.day);
        expect(verification.captured[0].dateTime.month, now.month);
        expect(verification.captured[0].dateTime.year, now.year);
      });

      test("Update page should add true to the isAddedPageController if the update was successful", () {
        expect(diaryViewModel.isPageAdded, emits(isTrue));

        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.updatePage();
      });

      test("Update page should add false to the isAddedPageController if an error is occured", () {
        /// Mock Firebase error
        when(mockFirestoreService.updateDiaryPageIntoDB(testHelper.loggedUser.id, any)).thenAnswer((_) async {
          return Future.error(Error);
        });

        expect(diaryViewModel.isPageAdded, emits(isFalse));

        /// Test Fields
        var title = "Title";
        var content = "Content";

        diaryViewModel.titleTextCtrl.text = title;
        diaryViewModel.contentTextCtrl.text = content;

        diaryViewModel.updatePage();
      });
    });

    group("Set favourite:", () {
      var favourite = true;
      setUp(() => diaryViewModel.setCurrentDiaryPage(testHelper.diaryPage));

      test("Check that set favourite sets the favourite flag of the current diary page", () {
        diaryViewModel.setFavourite(favourite);

        expect(diaryViewModel.currentDiaryPage.value!.favourite, favourite);
      });

      test("Set favourite should call the set diary page as favourite method of the firestore service", () {
        diaryViewModel.setFavourite(favourite);

        var verification = verify(mockFirestoreService.setDiaryPageAsFavouriteIntoDB(testHelper.loggedUser.id, captureAny));
        verification.called(1);

        /// Parameter Verification
        expect(verification.captured[0].favourite, favourite);
      });

      test("Check that if an error occurs when setting the favourite flag it catches the error and restore the old values", () async {
        /// Mock Firebase error
        when(mockFirestoreService.setDiaryPageAsFavouriteIntoDB(testHelper.loggedUser.id, any)).thenAnswer((_) async {
          return Future.error(Error);
        });

        await diaryViewModel.setFavourite(favourite);

        expect(diaryViewModel.currentDiaryPage.value!.favourite, isNot(favourite));
      });
    });
  });

  group("DiaryViewModel internal managment:", () {
    group("Edit page:", () {
      test("Edit page should set to true the corresponding flag", () {
        diaryViewModel.editPage();

        expect(diaryViewModel.isEditing, isTrue);
      });
    });

    group("Set current diary page:", () {
      setUp(() => diaryViewModel.resetCurrentDiaryPage());

      test("Check that set current diary page sets the correct field of the value notifier", () {
        diaryViewModel.setCurrentDiaryPage(testHelper.diaryPage);

        expect(diaryViewModel.currentDiaryPage.value, testHelper.diaryPage);
      });

      test("Check that set current diary page sets the values of the text controllers", () {
        diaryViewModel.setCurrentDiaryPage(testHelper.diaryPage);

        expect(diaryViewModel.titleTextCtrl.text, testHelper.diaryPage.title);
        expect(diaryViewModel.contentTextCtrl.text, testHelper.diaryPage.content);
      });
    });

    group("Reset current diary page:", () {
      test("Check that reset current diary page sets the field of the value notifier to null", () {
        diaryViewModel.currentDiaryPage.value = testHelper.diaryPage;
        diaryViewModel.resetCurrentDiaryPage();

        expect(diaryViewModel.currentDiaryPage.value, isNull);
      });

      test("Check that reset current diary page clears the values of the text controllers", () {
        diaryViewModel.titleTextCtrl.text = testHelper.diaryPage.title;
        diaryViewModel.contentTextCtrl.text = testHelper.diaryPage.content;
        diaryViewModel.resetCurrentDiaryPage();

        expect(diaryViewModel.titleTextCtrl.text, isEmpty);
        expect(diaryViewModel.contentTextCtrl.text, isEmpty);
      });

      test("Check that reset current diary page calls the resetControllers of the diary form", () {
        diaryViewModel.diaryForm = mockDiaryForm;

        /// Mock DiaryForm responses
        when(mockDiaryForm.title).thenAnswer((_) => StreamController<String>.broadcast());
        when(mockDiaryForm.content).thenAnswer((_) => StreamController<String>.broadcast());

        diaryViewModel.resetCurrentDiaryPage();

        verify(mockDiaryForm.resetControllers()).called(1);
      });
    });

    group("Reset view model:", () {
      test("Reset view model should clear the old values of the diary pages value notifier", () {
        diaryViewModel.diaryPages.value = testHelper.diaryPages;
        diaryViewModel.resetViewModel();

        expect(diaryViewModel.diaryPages.value, isEmpty);
      });

      test("Close listener should reset the current diary page", () {
        diaryViewModel.currentDiaryPage.value = testHelper.diaryPage;
        diaryViewModel.resetViewModel();

        expect(diaryViewModel.currentDiaryPage.value, isNull);
      });
    });
  });
}
