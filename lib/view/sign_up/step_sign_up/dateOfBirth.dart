import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/customWidget/customAppBar.dart';
import 'package:gamming_community/customWidget/customInput.dart';
import 'package:gamming_community/view/sign_up/controller/signUpController.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DateOfBirth extends StatelessWidget {
  final SignUpController s = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      height: Get.height,
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GetX<SignUpController>(
        builder: (v) => Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "When is your birthday ?",
              style: TextStyle(fontSize: 30),
            ),
            Container(
                padding: EdgeInsets.all(20),
                height: 100,
                child: CustomInput(
                    controller: v.dateofBirthController,
                    readOnly: true,
                    onSubmited: () {},
                    onTap: () async {
                      await v.selectDate(context);
                    },
                    hintText: "Select your date of birth",
                    borderSideColor: Colors.black87,
                    borderRadius: 10,
                    onClearText: () {
                      v.dateofBirthController.clear();
                    })),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onPressed: v.checkBirthDay ? () => v.checkBirthday() : null,
                  child: Text("Next"),
                ))
          ],
        ),
      ),
    ));
  }
}

/*class DateOfBirth extends StatefulWidget {
  final PageController controller;
  DateOfBirth({this.controller});
  @override
  _DateOfBirthState createState() => _DateOfBirthState();
}

class _DateOfBirthState extends State<DateOfBirth> {
  var dateofBirthController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        setDate();
      });
  }

  void setDate() {
    dateofBirthController.text =
        "${selectedDate.day} - ${selectedDate.month} - ${selectedDate.year}";
  }

  @override
  void initState() {
    super.initState();
    setDate();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    var pageProvider = Provider.of<SignUpProvider>(context);

    return Scaffold(

      body: Container(
        height: Get.height,
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
             Text(
              "When is your birthday ?",
              style: TextStyle(fontSize: 30),
            ),
            Container(
              padding: EdgeInsets.all(20),
              height: 100,
              child: CustomInput(
                controller: dateofBirthController, 
                readOnly: true, 
                onSubmited: (){}, 
                onTap: () {
                  _selectDate(context);
                }, 
                hintText: "Select your date of birth", 
                borderSideColor: Colors.black87, 
                borderRadius: 10, 
                onClearText: (){})
            ),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  onPressed: () {
                    //show dialog type code to complete register
                    pageProvider.setPageIndex(1);
                    pageProvider.setDateOfBirth(selectedDate);
                    widget.controller.animateToPage(1,
                        duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn);
                  },
                  child: Text("Next"),
                ))
          ],
        ),
      ),
    );
  }
}
*/
