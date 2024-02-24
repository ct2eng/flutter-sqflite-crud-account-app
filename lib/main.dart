import 'package:flutter/material.dart';
import 'package:account_app/_layout.dart';
import 'package:account_app/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// import 'package:account_app/bottomCard.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('zh', 'TW'),
      ],
      title: 'My Flutter App',
      theme: appTheme,
      home: Navigation(),
      debugShowCheckedModeBanner: false,
    );
  }
}
