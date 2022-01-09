import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:sApport/Model/DBItems/BaseUser/report.dart';
import 'package:sApport/Model/Services/firebase_auth_service.dart';
import 'package:sApport/Model/Services/firestore_service.dart';
import 'package:sApport/Model/Services/user_service.dart';
import 'package:sApport/Model/utils.dart';
import 'package:sApport/Router/app_router_delegate.dart';
import 'package:sApport/ViewModel/BaseUser/report_view_model.dart';
import 'package:sApport/ViewModel/user_view_model.dart';
import 'package:sApport/Views/Report/components/report_details_body.dart';
import 'package:sApport/Views/components/top_bar.dart';
import 'package:sizer/sizer.dart';

import '../../../Model/Services/firebase_auth_service_test.mocks.dart';
import '../../../navigator.mocks.dart';
import '../../../view_model.mocks.dart';
import '../../widget_test_helper.dart';

void main() {
  final mockReportViewModel = MockReportViewModel();
  final mockRouterDelegate = MockAppRouterDelegate();
  final mockUserViewMoel = MockUserViewModel();

  /// Register Services
  var getIt = GetIt.I;
  getIt.registerSingleton<FirestoreService>(FirestoreService(FakeFirebaseFirestore()));
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService(MockFirebaseAuth()));
  getIt.registerSingleton<UserService>(UserService());

  /// Get MultiProvider Widget for creating the test
  Widget getMultiProvider({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppRouterDelegate>(create: (_) => mockRouterDelegate),
        Provider<ReportViewModel>(create: (context) => mockReportViewModel),
        Provider<UserViewModel>(create: (context) => mockUserViewMoel),
      ],
      child: Sizer(builder: (context, orientation, deviceType) {
        return child;
      }),
    );
  }

  ///Mocking a report
  var id = Utils.randomId();
  var category = "Threats";
  var description = "Test";
  var mockReport = Report(id: id, category: category, description: description, dateTime: DateTime.now());

  when(mockReportViewModel.currentReport).thenAnswer((_) => ValueNotifier<Report?>(mockReport));

  group("Correct rendering:", () {
    testWidgets('Mock report details', (tester) async {
      /// Set the device dimensions for the test
      WidgetTestHelper.setPortraitDimensions(tester);

      await tester.pumpWidget(getMultiProvider(
          child: new MaterialApp(
              home: new Scaffold(
        body: ReportDetailsBody(),
      ))));

      final topBarfinder = find.widgetWithText(TopBar, "Threats");
      final dateFinder = find.text(DateFormat("dd MMM yyyy").format(mockReport.dateTime!));
      final descriptionFinder = find.text(description);

      expect(topBarfinder, findsOneWidget);
      expect(dateFinder, findsOneWidget);
      expect(descriptionFinder, findsOneWidget);
    });
  });
}