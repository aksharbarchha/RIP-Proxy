import 'package:flutter/material.dart';
import 'package:AttendanceTracker/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'sign_up.dart';
//import 'root_page.dart';
import 'package:AttendanceTracker/utils/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:AttendanceTracker/globals.dart' as globals;

class LoginSignupPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginSignupPage({this.auth, this.loginCallback});

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseUser user;
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    globals.email = email;
    globals.isLoggedIn = true;
    globals.name = _name;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    user = result.user;
    print(user.displayName);
    globals.email = email;
    globals.isLoggedIn = true;
    globals.name = _name;
    user = result.user;
    return user.uid;
  }

  final _formKey = new GlobalKey<FormState>();

  // PersistentBottomSheetController _sheetController;
  // var root = new RootPage();

  String _email;
  String _password;
  String _errorMessage = "";
  String _name;

  bool _isLoginForm;
  bool _isLoading;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (_isLoginForm) {
          userId = await signIn(_email, _password);
          print('Signed in: $userId');
          setState(() {
            _isLoading = false;
            globals.email = _email;
            globals.isLoggedIn = true;
            globals.name = 'User';
          });
        } else {
          userId = await widget.auth.signUp(_email, _password);
          print('Signed up user: $userId');
          Firestore.instance
              .collection('Faculty')
              .document(_email)
              .setData({'email': _email, 'name': _name});
          setState(() {
            _isLoading = false;
            globals.email = _email;
            globals.isLoggedIn = true;
            // globals.name = _name;
          });
          print("inserted in firestore!");
        }

        if (userId.length > 0 && userId != null) {
          print("Helooooooooo");
          widget.loginCallback();
        }
      } catch (e) {
        print('Error: $e');

        switch (e.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                _errorMessage = "This email is already in use.";
                _isLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(_errorMessage),
                      ),
                    );
                  });
            }
            break;
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                _errorMessage =
                    "The password must be 6 characters long or more.";
                _isLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(_errorMessage),
                      ),
                    );
                  });
            }
            break;
          default:
            {
              setState(() {
                _errorMessage = "Some Error Occured";
              });
            }
        }
        setState(() {
          _isLoading = false;
          // _errorMessage = e.message;
          _formKey.currentState.reset();
        });
      }
    }
  }
  //       setState(() {
  //         _isLoading = false;
  //         _errorMessage = e.message;
  //         _formKey.currentState.reset();
  //       });
  //     }
  //   }
  // }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color(0xFF444957),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 90, left: 10),
              child: RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    _isLoginForm ? 'Sign In' : 'Sign Up',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 52,
                      fontWeight: FontWeight.w900,
                    ),
                  )),
            ),
            _isLoginForm ? _showForm() : _showForm1(),
            _showCircularProgress(),
          ],
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    //Login
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              _divider(),
              showPrimButton(),
              showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showForm1() {
    //Register
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showDisplayNameInput(),
              showPasswordInput(),
              showPrimaryButtonPart(),
              showSecondaryButtonPart(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: Image.asset('assets/logoko.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 97.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: new InputDecoration(
            hintText: 'Email',
            hintStyle: TextStyle(color: Colors.white),
            icon: new Icon(
              Icons.mail,
              color: Colors.white,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget showDisplayNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: new InputDecoration(
            hintText: 'Username',
            hintStyle: TextStyle(color: Colors.white),
            icon: new Icon(
              Icons.contacts,
              color: Colors.white,
            )),
        validator: (value) => value.isEmpty ? 'Username can\'t be empty' : null,
        onSaved: (value) => _name = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        style: TextStyle(color: Colors.white),
        decoration: new InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: Colors.white),
            icon: new Icon(
              Icons.lock,
              color: Colors.white,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget showSecondaryButton() {
    return new Container(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: FlatButton(
            padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
            child: new Text('Don\'t have an account? SignUp ',
                style: new TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w300,
                    color: Colors.white)),
            onPressed: () {
              toggleFormMode();
              //  Navigator.pushReplacementNamed(context, "/signup");
              // Navigator.push(
              // context,
              // MaterialPageRoute(builder: (context) => SignupPage(auth: widget.auth,
              // loginCallback: widget.loginCallback)));
            }));
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.fromLTRB(0.0, 7.0, 0.0, 0.0),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          Text(
            'or',
            style: TextStyle(color: Colors.white),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () {
              validateAndSubmit();
            },
          ),
        ));
  }

  Widget showPrimButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: new Text('Sign In with Google',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: () async {
              bool res = await AuthProvider().loginWithGoogle();
              print(res);
              if (!res)
                print("Error logging in with Google");
              else {
                widget.loginCallback();
              }
            },
          ),
        ));
  }

  Widget showSecondaryButtonPart() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0, 75, 0, 0),
      child: FlatButton(
          padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
          child: new Text('Have an account? Sign in',
              style: new TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white)),
          onPressed: () {
            toggleFormMode();
            // Navigator.pushReplacementNamed(context, "/login");
            // Navigator.push(
            // context,
            // MaterialPageRoute(builder: (context) => LoginSignupPage(auth: widget.auth,
            // loginCallback: widget.loginCallback)));
          }),
    );
  }

  Widget showPrimaryButtonPart() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 65.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              color: Colors.blue,
              child: new Text('Create account',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              onPressed: () {
                validateAndSubmit();
                // Navigator.push(
                // context,
                // MaterialPageRoute(builder: (context) => LoginSignupPage(auth: widget.auth,
                // loginCallback: widget.loginCallback)));
              }),
        ));
  }
}
