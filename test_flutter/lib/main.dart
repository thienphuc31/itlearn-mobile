import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_flutter/providers/AccountProvider.dart';
import 'package:test_flutter/providers/LoginProvider.dart';
import 'package:test_flutter/ui/Login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => LoginProvider(),
          ),
          ChangeNotifierProvider(
            create: (context) => AccountProvider(),
          ),
          // ChangeNotifierProvider(
          //   create: (context) => PlantDataProvider(),
          // ),
          // ChangeNotifierProvider(
          //   create: (context) => LoginProvider(),
          // ),
          // ChangeNotifierProvider(
          //   create: (context) => PlantDetailProvider(),
          // ),
          // ChangeNotifierProvider(
          //   create: (context) => CartProvider(),
          // ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromRGBO(112, 86, 238, 100).withOpacity(
                  0.1),
            ),
          ),
          initialRoute: '/Login',
          routes: {
            '/Login': (context) => const Login(),
          },
          home: const Login(),
        ));
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.from(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: const Color.fromRGBO(112, 86, 238, 100).withOpacity(0.1),
//         ),
//       ),
//       // initialRoute: '/Login',
//       // routes: {
//       //   '/Login': (context) => const Login(),
//       // },
//       home: const Login(),
//     );
//   }
// }