import 'package:mockito/mockito.dart';
import 'package:sApport/Model/DBItems/Expert/expert.dart';
import 'package:sApport/Model/Services/firebase_auth_service.dart';
import 'package:test/test.dart';
import 'package:get_it/get_it.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:sApport/Model/utils.dart';
import 'package:sApport/Model/Services/user_service.dart';
import 'package:sApport/Model/DBItems/BaseUser/base_user.dart';
import 'package:sApport/Model/Services/firestore_service.dart';
import '../../service.mocks.dart';
import 'user_service_test.mocks.dart';

void main() async {
  /// Fake Firebase
  final fakeFirebase = FakeFirebaseFirestore();

  /// Mock Services
  final mockFirebaseAuthService = MockFirebaseAuthService();
  final mockBaseUserSignUpForm = MockBaseUserSignUpForm();
  final mockExpertSignUpForm = MockExpertSignUpForm();

  /// Register Services
  var getIt = GetIt.I;
  getIt.registerSingleton<FirestoreService>(FirestoreService(fakeFirebase));
  getIt.registerSingleton<FirebaseAuthService>(mockFirebaseAuthService);

  var loggedUser = BaseUser(
    id: Utils.randomId(),
    name: "Luca",
    surname: "Colombo",
    email: "luca.colombo@prova.it",
    birthDate: DateTime(1997, 10, 19),
  );

  var loggedExpert = Expert(
    id: Utils.randomId(),
    name: "Luca",
    surname: "Colombo",
    email: "luca.colombo@prova.it",
    birthDate: DateTime(1997, 10, 19),
    address: "Piazza Leonardo da Vinci, Milano, Italia",
    latitude: 45.478195,
    longitude: 9.2256787,
    phoneNumber: "331331331",
    profilePhoto: "Link to the profile photo",
  );

  /// Add the logged user and logged expert to the fakeFirebase
  fakeFirebase.collection(BaseUser.COLLECTION).doc(loggedUser.id).set(loggedUser.data);
  fakeFirebase.collection(Expert.COLLECTION).doc(loggedExpert.id).set(loggedExpert.data);

  /// Mock SignUp Form responses
  when(mockBaseUserSignUpForm.user).thenAnswer((_) => loggedUser);
  when(mockExpertSignUpForm.user).thenAnswer((_) => loggedExpert);

  UserService userService = UserService();

  group("UserService initialization", () {
    test("Logged user initially set to null", () {
      expect(userService.loggedUser, null);
    });
  });

  group("UserService loading base user", () {
    test("Load the signed in base user from the firestore DB and set it as the logged user", () async {
      /// Mock Firebase Auth Service responses
      when(mockFirebaseAuthService.currentUserId).thenAnswer((_) => loggedUser.id);

      await userService.loadLoggedUserFromDB();
      expect(userService.loggedUser, isA<BaseUser>());
    });

    test("Try to load a user with an ID that is not present into the firebase DB and check that the logged user is null", () async {
      /// Mock Firebase Auth Service responses
      when(mockFirebaseAuthService.currentUserId).thenAnswer((_) => "FAKE_ID");

      await userService.loadLoggedUserFromDB();
      expect(userService.loggedUser, null);
    });

    test("Try to load a user that is not logged in and check that the logged user is null", () async {
      /// Mock Firebase Auth Service responses
      when(mockFirebaseAuthService.currentUserId).thenAnswer((_) => null);

      await userService.loadLoggedUserFromDB();
      expect(userService.loggedUser, null);
    });

    test("Create a new logged user from the base user sign up form", () {
      userService.createUserFromSignUpForm(mockBaseUserSignUpForm);

      expect(userService.loggedUser, isA<BaseUser>());
      expect(userService.loggedUser, loggedUser);
    });
  });

  group("UserService loading expert", () {
    test("Load the signed in expert from the firestore DB and set it as the logged user", () async {
      /// Mock Firebase Auth Service responses
      when(mockFirebaseAuthService.currentUserId).thenAnswer((_) => loggedExpert.id);

      await userService.loadLoggedUserFromDB();
      expect(userService.loggedUser, isA<Expert>());
    });

    test("Create a new logged expert from the expert sign up form", () {
      userService.createUserFromSignUpForm(mockExpertSignUpForm);

      expect(userService.loggedUser, isA<Expert>());
      expect(userService.loggedUser, loggedExpert);
    });
  });
}
