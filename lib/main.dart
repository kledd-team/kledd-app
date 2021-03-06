import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/auth_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/product_detail_screen.dart';
import 'widgets/information/sign_in_transition.dart';
import 'lang/my_localizations.dart';
import 'lang/my_localizations_delegate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => MyLocalizations.of(context).title,
      localizationsDelegates: [
        const MyLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English (default)
        const Locale('sv'), // Swedish
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        backgroundColor: Color(0xfff1f9ff),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapshot) {
          // Show splash screen while checking if user is signed in.
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          }
          var signedIn = userSnapshot.hasData;
          return signedIn ? SignInTransition() : AuthScreen();
        },
      ),
      routes: {
        ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
      },
    );
  }
}
