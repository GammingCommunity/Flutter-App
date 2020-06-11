import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamming_community/repository/lang_repo.dart';
import 'package:responsive_widgets/responsive_widgets.dart';

class ChangeLanguage extends StatefulWidget {
  final String defaultLanguage;
  ChangeLanguage({this.defaultLanguage});
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  bool enLang = true;
  var _restartChannel = MethodChannel("restartApp");

  @override
  void initState() {
    super.initState();
    widget.defaultLanguage == "en" ? enLang = true : enLang = false;
  }

  @override
  Widget build(BuildContext context) {
    return ContainerResponsive(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            ButtonTheme(
              minWidth: 50,
              child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  color: enLang ? Colors.indigo : Colors.grey,
                  onPressed: () async {
                    if (enLang) {
                      return null;
                    } else if (await showChangeLanguageConfirm(context, true)) {
                      setState(() {
                        enLang = !enLang;
                      });
                      await LangRepo.setLanguage(true);
                      _restartChannel.invokeMethod("restartApp");
                      //await showChangeLanguageConfirm(context, true);
                    }
                  },
                  child: Text("EN",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold))),
            ),
            SizedBoxResponsive(width: 20.w),
            //VerticalDivider(thickness: 2),
            ButtonTheme(
                minWidth: 50,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () async {
                      if (!enLang) {
                        return null;
                      } else if (await showChangeLanguageConfirm(context, false)) {
                        setState(() {
                          enLang = !enLang;
                        });
                        await LangRepo.setLanguage(false);
                        _restartChannel.invokeMethod("restartApp");
                        // await showChangeLanguageConfirm(context, false);
                      }
                    },
                    color: enLang ? Colors.grey : Colors.indigo,
                    child: Text("VI",style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }
}

Future<bool> showChangeLanguageConfirm(BuildContext context, bool isEng) async {
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => ContainerResponsive(
      height: 100.h,
      width: 150.w,
      child: AlertDialog(
        title: Text(
          "Restart Required",
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            RichText(
                text: TextSpan(
                    text: ' "Change to ${isEng ? "English" : "Vietnamese"}" ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic))),
            Text("You should restart your app to take effect.")
          ],
        ),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text("Cancel")),
          FlatButton(
              onPressed: () async {
                Navigator.pop(context, true);
              },
              child: Text("OK")),
        ],
      ),
    ),
  );
}
