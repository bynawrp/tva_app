import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:tva/home/home.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tva/l10n/l10n.dart';
//import 'package:gobank/splashscreen.dart';
import 'package:tva/utils/colornotifire.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Locale savedLocale = await getLocale();

  runApp(MyApp(savedLocale: savedLocale));
}

class MyApp extends StatefulWidget {
  final Locale savedLocale;

  const MyApp({super.key, required this.savedLocale});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Locale currentLocale;

  @override
  void initState() {
    super.initState();
    currentLocale = widget.savedLocale;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ColorNotifire(),
        ),
      ],
      child: GetMaterialApp(
        supportedLocales: L10n.all,
        locale: currentLocale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const Home(),
        theme: ThemeData(textTheme: const TextTheme()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

Future<Locale> getLocale() async {
  final prefs = await SharedPreferences.getInstance();
  String? lang = prefs.getString('lang');
  return lang != null ? Locale(lang) : const Locale('fr');
}
