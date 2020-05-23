import 'package:flutter/material.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:provider/provider.dart';

class DateOfBirth extends StatefulWidget {
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
        height: screenSize.height,
        width: screenSize.width,
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
              child: TextField(
                onTap: () {
                  _selectDate(context);
                },
                readOnly: true,
                controller: dateofBirthController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            ButtonTheme(
                minWidth: 200,
                height: 50,
                child: RaisedButton(
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
