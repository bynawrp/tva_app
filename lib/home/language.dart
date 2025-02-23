import 'package:flutter/material.dart';
import 'package:tva/utils/colornotifire.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/media.dart';
import 'package:get/get.dart';

class Language extends StatefulWidget {
  const Language({super.key});

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  int _groupValue = 0;
  late ColorNotifire notifire;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    String lang = Localizations.localeOf(context).languageCode;
    //print(lang);
    setState(() {
      _groupValue = lang == 'fr' ? 2 : 1;
    });
  }

  void changeLanguage(Locale locale, int value) async {
    setState(() {
      _groupValue = value;
    });

    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('lang', locale.languageCode);
    });

    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: notifire.getprimerycolor,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        title: Text(
          AppLocalizations.of(context)!.language,
          style: TextStyle(
              color: notifire.getdarkscolor,
              fontSize: height / 40,
              fontFamily: 'Gilroy Bold'),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: height * 0.89,
              width: width,
              color: Colors.transparent,
              child: Image.asset(
                "images/background.png",
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                SizedBox(height: height / 50),
                Row(
                  children: [
                    SizedBox(width: width / 20),
                    Text(
                      AppLocalizations.of(context)!.suggestedlanguages,
                      style: TextStyle(
                        color: notifire.getdarkscolor,
                        fontFamily: 'Gilroy Bold',
                        fontSize: height / 50,
                      ),
                    )
                  ],
                ),
                SizedBox(height: height / 40),
                sugesttype(AppLocalizations.of(context)!.english, 1,
                    const Locale('en')),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
                sugesttype(AppLocalizations.of(context)!.french, 2,
                    const Locale('fr')),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: width / 20),
                  child: Divider(
                    thickness: 1,
                    color: Colors.grey.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget sugesttype(String title, int val, Locale locale) {
    return GestureDetector(
      onTap: () {
        changeLanguage(locale, val);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            SizedBox(width: width / 20),
            Text(
              title,
              style: TextStyle(
                  color: notifire.getdarkscolor,
                  fontSize: height / 45,
                  fontFamily: 'Gilroy Medium'),
            ),
            const Spacer(),
            Radio(
              activeColor: notifire.getambercolor,
              value: val,
              groupValue: _groupValue,
              onChanged: (value) {
                changeLanguage(locale, value as int);
              },
            ),
          ],
        ),
      ),
    );
  }
}
