import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gamming_community/API/Auth.dart';
import 'package:gamming_community/API/Query.dart';
import 'package:gamming_community/class/User.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/resources/values/app_constraint.dart';
import 'package:gamming_community/utils/progress_button.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class EditProfile extends StatefulWidget {
  final String token;
  EditProfile({this.token});
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nickname = TextEditingController();
  TextEditingController _personalInfo = TextEditingController();
  TextEditingController _birthday = TextEditingController();
  TextEditingController _phone = TextEditingController();
  FocusNode _nickNameFocus = FocusNode();
  FocusNode _personalInfoFocus = FocusNode();
  FocusNode _birthdayFocus = FocusNode();
  FocusNode _phoneFocus = FocusNode();
  DateTime selectedDate = DateTime.now();

  void selectDay(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1991),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _birthday.text = ("${picked.day} / ${picked.month} / ${picked.year}");
      });
  }

  Future getProfileInfo() async {
    GraphQLQuery query = GraphQLQuery();
    GraphQLClient client = authAPI(widget.token);
    var result = await client
        .query(QueryOptions(documentNode: gql(query.getCurrentUserInfo())));
    User user = User.fromJson(result.data);
    setState(() {
      _nickname.text = user.nickname;
      _personalInfo.text = user.describe;
      _phone.text = user.phoneNumber;
    });
    //print(result.data);
  }
  @override
  void dispose() { 
    _nickname.dispose();
    _birthday.dispose();
    _phone.dispose();
    super.dispose();
  }
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Discard change?',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content:
                Text("You'll lose any changes you've made to your profile."),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('Cancel'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: Text(
                      'Disard Changes?',
                      style: TextStyle(color: AppColors.PRIMARY_COLOR),
                    ),
                  ),
                ],
              )
            ],
          ),
        )) ??
        false;
  }

  @override
  void initState() {
    getProfileInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30),
          child: Container(
            color: AppColors.PRIMARY_COLOR,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  type: MaterialType.circle,
                  clipBehavior: Clip.antiAlias,
                  child: IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ),
                Text(
                  "Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                 ProgressButton(
                    token: widget.token,
                    nickname: _nickname.text,
                    email: "",
                    phone: _phone.text,
                    birthday: "",
                    describe: _personalInfo.text,
                  ),
                
              ],
            ),
          ),
        ),
        body: WillPopScope(
          onWillPop: _onWillPop,
          child: Container(
            padding: EdgeInsets.all(20),
            height: screenSize.height,
            width: screenSize.width,
            child: SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: 80,
                    children: <Widget>[
                      /* Display userprofile, selectable */
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          child: Container(
                            margin: EdgeInsets.only(top: 20),
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(1000),
                              child: CachedNetworkImage(
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  imageUrl: AppConstraint.sample_proifle_url),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Nickname"),
                              TextFormField(
                                focusNode: _nickNameFocus,
                                controller: _nickname,
                                decoration: InputDecoration(
                                  hintText: "Enter your nick name",
                                  labelStyle: TextStyle(color: Colors.white),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Personal profile"),
                              TextFormField(
                                focusNode: _personalInfoFocus,
                                controller: _personalInfo,
                                decoration: InputDecoration(
                                  hintText: "Enter your personal information",
                                  labelStyle: TextStyle(color: Colors.white),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Birthday"),
                              TextFormField(
                                focusNode: _birthdayFocus,
                                controller: _birthday,
                                readOnly: true,
                                onTap: () {
                                  selectDay(context);
                                },
                                decoration: InputDecoration(
                                  hintText: "Select your birthday",
                                  labelStyle: TextStyle(color: Colors.white),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 1)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Container(
                                      alignment: Alignment.center,
                                      child: Text("+84"))),
                              Expanded(
                                flex: 6,
                                child: TextFormField(
                                  focusNode: _phoneFocus,
                                  controller: _phone,
                                  onTap: () {},
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(),
                                ),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  )),
            ),
          ),
        ));
  }
}
