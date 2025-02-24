import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../utils/colornotifire.dart';
import '../utils/media.dart';

class AboutPage extends StatefulWidget {
  final String title;

  const AboutPage(this.title, {super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late ColorNotifire notifire;

  getdarkmodepreviousstate() async {
    final prefs = await SharedPreferences.getInstance();
    bool? previusstate = prefs.getBool("setIsDark");
    if (previusstate == null) {
      notifire.setIsDark = false;
    } else {
      notifire.setIsDark = previusstate;
    }
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: notifire.getdarkscolor),
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        title: Text(
          widget.title,
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontSize: height / 40,
            fontFamily: 'Gilroy Bold',
          ),
        ),
      ),
      backgroundColor: notifire.getprimerycolor,
      body: Center(
        child: Stack(
          children: [
            Container(
              height: height,
              width: width,
              color: Colors.transparent,
              child: Image.asset("images/background.png", fit: BoxFit.cover),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset("images/logo_inducido.png", width: width / 1.8),
                  Text(
                    "${AppLocalizations.of(context)!.creator} : Lucas JEAN",
                    style: TextStyle(
                      fontSize: height / 55,
                      color: notifire.getdarkscolor,
                      fontFamily: 'Gilroy Light',
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Version : 1.0.1 (beta)',
                    style: TextStyle(
                      fontSize: height / 55,
                      color: notifire.getdarkscolor,
                      fontFamily: 'Gilroy Light',
                    ),
                  ),
                  SizedBox(height: height / 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
