import 'package:flutter/material.dart';
import 'package:projectsem4_mobile_itlearning/constants/colors.dart';
import 'package:projectsem4_mobile_itlearning/providers/AccountProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/CourseKeyProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/ExerciseProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/ForgotPassProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/LoginProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/NoteProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/RegisterProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/ResetPasswordProvider.dart';
import 'package:projectsem4_mobile_itlearning/providers/StudentCourseProvider.dart';
import 'package:projectsem4_mobile_itlearning/screens/Forgot&ResetPass/ForgotPassMain.dart';
import 'package:projectsem4_mobile_itlearning/screens/InfoAccount/EditStudentPage.dart';
import 'package:projectsem4_mobile_itlearning/screens/Login/LoginMain.dart';
import 'package:projectsem4_mobile_itlearning/screens/Register/RegisterMain.dart';
import 'package:projectsem4_mobile_itlearning/screens/TestMain.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/AuthenticatedHttpClient.dart';


AuthenticatedHttpClient? authenticatedHttpClient;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Đảm bảo đã khởi tạo FlutterBinding

  // Khởi tạo authenticatedHttpClient ở đây
  await initializeHttpClient();

  runApp(MyApp());
}
Future<void> initializeHttpClient() async {
  authenticatedHttpClient = AuthenticatedHttpClient(await SharedPreferences.getInstance());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AccountProvider()),
          ChangeNotifierProvider(create: (context) => LoginProvider()),
          ChangeNotifierProvider(create: (context) => RegisterProvider()),
          ChangeNotifierProvider(create: (context) => ForgotPassProvider()),
          ChangeNotifierProvider(create: (context) => StudentCourseProvider(authenticatedHttpClient!)),
          ChangeNotifierProvider(create: (context) => ResetPasswordProvider()),
          ChangeNotifierProvider(create: (context) => CourseKeyProvider(authenticatedHttpClient!)),
          ChangeNotifierProvider(create: (context) => NoteProvider(authenticatedHttpClient!)),
          ChangeNotifierProvider(create: (context) => ExerciseProvider(authenticatedHttpClient!)),

          ],
        child: MaterialApp(
          theme: ThemeData(primaryColor: primaryBlue),
          debugShowCheckedModeBanner: false,
          title: 'Techwiz 4 Mobile',
          initialRoute: '/LoginMain',
          routes: {
            '/LoginMain': (context) => LoginMain(),
            '/Register': (context) => const RegisterMain(),
            '/Forgot': (context) => ForgotPassMain(),
            '/EditStudentPage':(context)=>EditStudentPage(),
            // '/HomeMain':(context)=> const HomeMain(),
            // '/PlantDetail': (context)=> PlantDetail(),
            // '/PlantList':(context)=>const PlantList(),
            // '/InforAccount':(context)=> const InforAccount(),
            // '/ForgotPassword':(context) =>  ForgotPassword(),
            // '/AuthoriztionCodePage':(context)=>AuthorizationCode(),
            // '/FavoriteList':(context)=>FavoriteList(),
            // '/Pay':(context)=>Payy(),
            '/Main':(context)=>TestdHomePage(),
            // '/PaymentSuccess':(context)=>PaymentSuccess(),
            // '/Feedback':(context)=>FeedbackScreen(),
            // '/HelpMain':(context)=>HelpMain(),
            // '/SiteMap':(context)=>SiteMap(),





            // '/Test':(context)=>MyApp4(),
            // '/HistoryOrder':(context)=>MyApp4(),


          },
        ));
  }
}