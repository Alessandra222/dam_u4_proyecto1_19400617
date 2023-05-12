import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:dam_u4_proyecto1_19400617/interfaz.dart';
import 'package:flutter/material.dart';
//firebase
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: AdaptiveThemeMode.light,
      builder: (theme,darkTheme){
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "CocheTec",
          theme: theme,
          darkTheme: darkTheme,
          home: Interfaz(),
        );
      },
    );
   /* return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: Interfaz(),
    );*/
  }
}
