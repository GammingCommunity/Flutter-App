import 'package:flutter/material.dart';
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
                  onPressed: () async{
                    enLang
                        ? null
                        : await showChangeLanguageConfirm(context, enLang) ? setState((){
                          enLang = !enLang;
                        }) : null;
                        
                        /*setState(() {
                            print("${showChangeLanguageConfirm(context, enLang).then((value) => print(value)) } here ");
                            != null ?  : null;
                          });*/
                  },
                  child: Text("EN")),
            ),
            SizedBoxResponsive(width: 20.w),
            //VerticalDivider(thickness: 2),
            ButtonTheme(
                minWidth: 50,
                child: RaisedButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onPressed: () async{
                      !enLang
                          ? null
                          : await showChangeLanguageConfirm(context, enLang) ? setState((){
                          enLang = !enLang;
                        }) : null;
                    },
                    color: enLang ? Colors.grey : Colors.indigo,
                    child: Text("VI"))),
          ],
        ),
      ),
    );
  }
}

Future<bool> showChangeLanguageConfirm(BuildContext context, bool isEng) async{
  return await showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => ContainerResponsive(
      height: 100.h,
      width: 150.w,
      child: AlertDialog(
        content: Text(
            "Change to ${isEng ? "English" : "Vietnamese"}. You should restart your app to take effect."),
        actions: <Widget>[
          FlatButton(
              onPressed: () {
                Navigator.pop(context,false);
              },
              child: Text("Cancel")),
          FlatButton(
              onPressed: () async {
                LangRepo.setLanguage(isEng);
                Navigator.pop(context,true);   
              },
              child: Text("OK")),
        ],
      ),
    ),
  );
}
