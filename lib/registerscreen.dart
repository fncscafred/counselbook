import 'package:flutter/material.dart';
import 'package:counsel_book/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:email_validator/email_validator.dart';

void main() => runApp(RegisterScreen());

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  double screenHeight;
  bool _isChecked = false;
  String urlRegister = "http://mystbf.com/counselbook/php/register_user.php";
  TextEditingController _nameEditingController = new TextEditingController();
  TextEditingController _emailEditingController = new TextEditingController();
  TextEditingController _phoneditingController = new TextEditingController();
  TextEditingController _passEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
          resizeToAvoidBottomPadding: false,
          body: Stack(
            children: <Widget>[
              upperHalf(context),
              lowerHalf(context),
              pageTitle(),
            ],
          ),
    );
  }

  Widget upperHalf(BuildContext context) {
    return Container(
      child: Image.asset(
        'assets/images/top.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget lowerHalf(BuildContext context) {
    return Container(
      height: 400,
      margin: EdgeInsets.only(top: screenHeight / 3.5),
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 10,
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "Registration",
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  TextFormField(
                    textInputAction: TextInputAction.next,
                    validator: (name){
                      Pattern pattern =
                        '^[a-zA-Z\s\.]';
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(name))
                        return 'Invalid name';
                      else
                        return null;
                    },
                    style: TextStyle(color: Colors.black,),
                      controller: _nameEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        icon: Icon(Icons.person),
                      )
                      ),
                  TextFormField(
                    style: TextStyle(color: Colors.black,),
                      controller: _emailEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: Icon(Icons.email),
                      ),
                      textInputAction: TextInputAction.next, 
                      validator: (email)=>EmailValidator.validate(email)? null:"Invalid email address",),
                  TextField(
                    style: TextStyle(color: Colors.black,),

                      controller: _phoneditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Phone',
                        icon: Icon(Icons.phone),
                      )),
                  TextField(
                    style: TextStyle(color: Colors.black,),

                    controller: _passEditingController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      icon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      GestureDetector(
                        onTap: _showTnC,
                        child: Text('I Agree to T&C  ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black)),
                      ),
                      MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        minWidth: 115,
                        height: 50,
                        child: Text('REGISTER'),
                        color: Colors.blueAccent,
                        textColor: Colors.white,
                        elevation: 10,
                        onPressed: _onRegister,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Already register? ", style: TextStyle(fontSize: 16.0,color: Colors.black)),
              GestureDetector(
                onTap: _loginScreen,
                child: Text(
                  "Login",
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget pageTitle() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text(
            "CounselBook",
            style: TextStyle(
                fontSize: 36, color: Colors.blue[800], fontWeight: FontWeight.w900),
          )
        ],
      ),
    );
  }

  void _onRegister() {
    if (!_isChecked) {
      Toast.show("Please Accept T&C", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      return;
    }else{
      showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(
            "Confirm register?",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Yes",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              onPressed: _register,
            ),
            new FlatButton(
              child: new Text(
                "No",
                style: TextStyle(
                  color: Colors.blueAccent,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    }
  }

  void _loginScreen() {
    Navigator.pop(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      //savepref(value);
    });
  }

  void _register(){
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneditingController.text;
    String password = _passEditingController.text;

    http.post(urlRegister, body: {
      "name": name,
      "email": email,
      "password": password,
      "phone": phone,
    }).then((res) {
      if (res.body == "success") {
        Navigator.pop(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
        Toast.show("Successfully registered", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else if(res.body == "registered"){
        Toast.show("Sorry. Account already registered", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      } else {
        Toast.show("Sorry. Registration failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    }).catchError((err) {
      print(err);
    });
  }

  void _showTnC() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("CounselBook Terms and Conditions"),
          content: new Container(
            height: screenHeight / 2,
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: new SingleChildScrollView(
                    child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              //fontWeight: FontWeight.w500,
                              fontSize: 12.0,
                            ),
                            text:
                                "If you create an account in the CounselBook Mobile Application, you are responsible for maintaining the security of your account and you are fully responsible for all activities that occur under the account and any other actions taken in connection with it. We may, but have no obligation to, monitor and review new accounts before you may sign in and use our Services. Providing false contact information of any kind may result in the termination of your account. You must immediately notify us of any unauthorized uses of your account or any other breaches of security. We will not be liable for any acts or omissions by you, including any damages of any kind incurred as a result of such acts or omissions. We may suspend, disable, or delete your account (or any part thereof) if we determine that you have violated any provision of this Agreement or that your conduct or content would tend to damage our reputation and goodwill. If we delete your account for the foregoing reasons, you may not re-register for our Services. We may block your email address and Internet protocol address to prevent further registration."
                            //children: getSpan(),
                            )),
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
