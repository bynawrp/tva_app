import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tva/home/param.dart';
import 'package:tva/utils/colornotifire.dart';
import 'package:tva/utils/media.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'about.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController tvaController = TextEditingController();
  final TextEditingController htcController = TextEditingController();
  final TextEditingController ttcController = TextEditingController();

  List<double> tvaPercent = [2.1, 5.5, 10.0, 20.0];
  double selectedTvaPercent = 20.0;
  String lastEdited = '';
  bool isCalculate = false;

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
  void initState() {
    super.initState();
    getdarkmodepreviousstate();
    htcController.addListener(() => lastChange('htc'));
    ttcController.addListener(() => lastChange('ttc'));
    //tvaController.addListener(() => lastChange('tva'));
  }

  @override
  void dispose() {
    tvaController.dispose();
    htcController.dispose();
    ttcController.dispose();
    super.dispose();
  }

  void lastChange(String field) {
    if (isCalculate) return;
    setState(() {
      lastEdited = field;
    });
    calculateValues();
  }

  void setTvaPercent(double value) {
    if (isCalculate) return;
    setState(() {
      selectedTvaPercent = value;
    });
    calculateValues();
  }

  void calculateValues() {
    setState(() {
      isCalculate = true;

      double ht = double.tryParse(htcController.text) ?? 0.0;
      double ttc = double.tryParse(ttcController.text) ?? 0.0;

      switch (lastEdited) {
        case "ttc":
          double resultHt = ttc / (1 + selectedTvaPercent / 100);
          double resultTva = ttc - resultHt;
          htcController.text = resultHt.toStringAsFixed(2);
          tvaController.text = resultTva.toStringAsFixed(2);
          break;

        case "htc":
          double resultTva = ht * selectedTvaPercent / 100;
          double resultTtc = ht + resultTva;
          ttcController.text = resultTtc.toStringAsFixed(2);
          tvaController.text = resultTva.toStringAsFixed(2);
          break;
      }

      isCalculate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    notifire = Provider.of<ColorNotifire>(context, listen: true);
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: notifire.getprimerycolor,
        leading: Container(
          height: 20,
          width: 20,
          margin: const EdgeInsets.all(8),
          child: Image.asset('images/logo.png', scale: 4),
        ),
        title: Text(
          AppLocalizations.of(context)!.title,
          style: TextStyle(
            color: notifire.getdarkscolor,
            fontSize: height / 40,
            fontFamily: 'Gilroy Bold',
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          Parametres(AppLocalizations.of(context)!.title),
                ),
              );
            },
            child: Image.asset(
              "images/darkmode.png",
              color: notifire.getdarkscolor,
              scale: 4,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      backgroundColor: notifire.getprimerycolor,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: notifire.getbackcolor,
                    height: height / 13,
                    width: width,
                    child: Image.asset(
                      "images/backphoto.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        buildInputTVA(
                          AppLocalizations.of(context)!.label_ht,
                          htcController,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.label_pourcentage,
                              style: TextStyle(
                                color: notifire.getdarkscolor,
                                fontFamily: 'Gilroy Bold',
                                fontSize: height / 45,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: SegmentedButton<double>(
                            segments:
                                tvaPercent.map((tva) {
                                  return ButtonSegment<double>(
                                    value: tva,
                                    label: Text(
                                      "${tva.toStringAsFixed(1)}%",
                                      style: TextStyle(
                                        fontFamily: 'Gilroy Medium',
                                        fontSize: height / 55,
                                      ),
                                    ),
                                  );
                                }).toList(),
                            selected: {selectedTvaPercent},
                            showSelectedIcon: false,
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                    (states) =>
                                        states.contains(WidgetState.selected)
                                            ? notifire.getambercolor
                                            : notifire.getprimerydarkcolor,
                                  ),
                              foregroundColor:
                                  WidgetStateProperty.resolveWith<Color?>(
                                    (states) =>
                                        states.contains(WidgetState.selected)
                                            ? Colors.white
                                            : notifire.getdarkscolor,
                                  ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onSelectionChanged: (newSelection) {
                              if (newSelection.isNotEmpty) {
                                setTvaPercent(newSelection.first);
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        buildInputTVA(
                          AppLocalizations.of(context)!.label_tva,
                          tvaController,
                          enable: true,
                        ),
                        const SizedBox(height: 20),
                        buildInputTVA(
                          AppLocalizations.of(context)!.label_ttc,
                          ttcController,
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => AboutPage(AppLocalizations.of(context)!.about),
            ),
          );
        },
        child: Icon(
          Icons.info_outlined,
          size: 35,
          color: notifire.getdarkscolor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildInputTVA(
    String label,
    TextEditingController controller, {
    bool enable = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: notifire.getdarkscolor,
              fontFamily: 'Gilroy Bold',
              fontSize: height / 45,
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: height / 18,
            child: TextField(
              readOnly: enable,
              cursorColor: notifire.getambercolor,
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              autofocus: false,
              inputFormatters: [
                TextInputFormatter.withFunction((oldValue, newValue) {
                  return newValue.copyWith(
                    text: newValue.text.replaceAll(',', '.'),
                  );
                }),
              ],
              style: TextStyle(
                fontSize: height / 50,
                color: notifire.getdarkscolor,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: notifire.getprimerydarkcolor,
                prefixText: "€ ",
                prefixStyle: TextStyle(
                  color: notifire.getdarkscolor,
                  fontFamily: 'Gilroy-Medium',
                  fontSize: height / 50,
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: notifire.getambercolor),
                  borderRadius: BorderRadius.circular(10),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
