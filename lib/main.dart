import 'package:flutter/material.dart';
import 'package:mexage/theme/custom_themes.dart';
import 'package:mexage/views/home_view.dart';
import 'package:mexage/views/welcome_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
   */
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CustomThemes()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeView(), // Replace SecondPage with the name of your second page widget
      },
      title: 'Mexage',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeView(),
    );
  }
}
