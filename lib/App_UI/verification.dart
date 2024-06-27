import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_project/App_UI/bottomnavigation.dart';
import 'package:my_project/App_UI/splash_screen.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';



class inilogin extends StatefulWidget {
  const inilogin({super.key});

  @override
  State<inilogin> createState() => _iniloginState();
}

class _iniloginState extends State<inilogin> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment:MainAxisAlignment.center,
          children: [
            Center(
              child: SizedBox(
                height: 400,
                width: 400,
                child: Card(
                   elevation: 30,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                               Text("Already Have an Account!"),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: SizedBox(
                                   height: 60,
                                   width: double.infinity,
                                   child: GestureDetector(
                                     onTap: () {
                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => UserLogin2()));
                                     },
                                     child: Card(
                                       color: Color(0xFFFFDF13), // Custom color (e.g., hex color code)

                                       child: Center(
                                         child: Text("Login"),
                                       ),
                                     ),
                                   ),
                                 ),
                               ),
                               SizedBox(
                                 height: 20,
                               ),
                               Row(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                 children: [
                                   SizedBox(
                                     width: 10,
                                     child: Divider(
                                       color: Colors.black,
                                     ),
                                   ),
                                   SizedBox(
                                     width: 7,
                                   ),
                                   Text(
                                     "or",
                                     style: TextStyle(
                                       fontSize: 20,
                                       fontWeight: FontWeight.bold,
                                     ),
                                   ),
                                   SizedBox(
                                     width: 7,
                                   ),
                                   SizedBox(
                                     width: 10,
                                     child: Divider(
                                       color: Colors.black,
                                     ),
                                   ),
                                 ],
                               ),
                               SizedBox(
                                 height: 20,
                               ),
                               Text("Create Account!"),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: SizedBox(
                                   height: 60,
                                   width: double.infinity,
                                   child: GestureDetector(
                                     onTap: () {
                                       Navigator.push(
                                           context,
                                           MaterialPageRoute(
                                               builder: (context) => Numberverification()));
                                     },
                                     child: Card(
                                       color: Color(0xFFFFDF13),
                                       child: Center(
                                         child: Text("Signup"),
                                       ),
                                     ),
                                   ),
                                 ),
                               )
                     ],
                   ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


}





//get number & otp verification

class Numberverification extends StatefulWidget {


  const Numberverification({Key? key}) : super(key: key);

  @override
  State<Numberverification> createState() => _NumberverificationState();
}

class _NumberverificationState extends State<Numberverification> {


  final TextEditingController _mobilenumber = TextEditingController();
  final TextEditingController  _otpNumber = TextEditingController();


  var code = "";
  String Countrycode = "+91";


  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  double _containerHeight = 500; // Initial height of the container
  double _containerHeight1 = 0;
  bool value1 = false;


  @override
  Widget build(BuildContext context) {

    MediaQueryData mediaQuery = MediaQuery.of(context);
    EdgeInsets insets = mediaQuery.viewInsets;
    bool isKeyboardVisible = insets.bottom > 0;

    // Adjust container height based on keyboard visibility
    _containerHeight = isKeyboardVisible ? 800 : 500;
    _containerHeight1 = isKeyboardVisible ? 200 : 0;
    final text = _mobilenumber.text;


    final normalDecoration = InputDecoration(
      prefixIcon: Icon(Icons.phone),
      hintText: "Mobile Number",
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.black),
      ),
    );

    final errorDecoration = InputDecoration(
      prefixIcon: Icon(Icons.phone),
      hintText: "Mobile Number",
      labelText: 'Enter 10-digit number',
      labelStyle: TextStyle(
        color: Colors.red, // Set the color of the label text
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(color: Colors.red),
      ),
    );

    final inputDecoration = value1 ? errorDecoration : normalDecoration;


    return Scaffold(
      body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  height: 400,
                  width: MediaQuery.of(context).size.width * 0.97,
                  child: Card(
                    elevation: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Text(
                              "Enter Mobile Number",
                              style: TextStyle(fontSize: 20),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 100, right: 100),
                              child: Divider(
                                // Divider to add a line
                                color: Colors.black, // Color of the line
                                thickness: 1, // Thickness of the line
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: SizedBox(
                            height: 50,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                controller: _mobilenumber,
                                decoration: inputDecoration,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: GestureDetector(
                            onTap: () async{
                              if (text.length < 10 || text.isEmpty ) {
                                setState(() {
                                  value1 = true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar( (text.isEmpty )?SnackBar(content: Text("Pls enter number")):SnackBar(content: Text("Enter Valid Number")));
                              }else{
                                setState(() {
                                  value1 = false;
                                });
                                await FirebaseAuth.instance.verifyPhoneNumber(
                                  phoneNumber: '${Countrycode+_mobilenumber.text}',
                                  verificationCompleted: (PhoneAuthCredential credential) {},
                                  verificationFailed: (FirebaseAuthException e) {
                                    if (e.code == 'invalid-phone-number') {
                                      print('The provided phone number is not valid.');
                                    }else{
                                      print('------------------------>error message $e');
                                    }
                                  },
                                  codeSent: (String verificationId, int? resendToken) {
                                    showModalBottomSheet(
                                        context: context,
                                        isDismissible: false,
                                        builder: (BuildContext context){
                                          return   Positioned.fill(
                                            top: MediaQuery.of(context).viewInsets.top,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(40.0),
                                                  topRight: Radius.circular(40.0),
                                                ),
                                              ),
                                              height: _containerHeight,
                                              width: double.infinity,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        "Enter OTP Number",
                                                        style: TextStyle(fontSize: 20),
                                                      ),
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(
                                                            left: 100, right: 100),
                                                        child: Divider(
                                                          // Divider to add a line
                                                          color: Colors.black, // Color of the line
                                                          thickness: 1, // Thickness of the line
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    child: Form(
                                                      key: _formKey1,
                                                      child: Pinput(
                                                        controller: _otpNumber,
                                                        keyboardType: TextInputType.number,
                                                        length: 6,

                                                        onChanged: (value) {
                                                          setState(() {
                                                            code = value;
                                                          });
                                                        },
                                                        validator: (value) {
                                                          if (value!.length != 10)
                                                            return "invalid phone number";
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 65,
                                                    width: MediaQuery.of(context).size.width * 0.6,
                                                    child: GestureDetector(
                                                      onTap: () async{
                                                        try{
                                                          FirebaseAuth auth = FirebaseAuth.instance;

                                                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _otpNumber.text);

                                                          // Sign the user in (or link) with the credential
                                                          await auth.signInWithCredential(credential);

                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                      UserLogin(
                                                                        number: _mobilenumber
                                                                            .text,
                                                                      )));
                                                        }catch(e){
                                                          print("---------->error $e");
                                                        }

                                                      },
                                                      child: Card(
                                                        color: Color(0xFFFFDF13),
                                                        child: Center(
                                                          child: Text(
                                                            "Next",
                                                            style: TextStyle(
                                                                fontSize: 20,
                                                                fontWeight: FontWeight.bold),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:_containerHeight1,
                                                  ),

                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                    );
                                  },
                                  codeAutoRetrievalTimeout: (String verificationId) {},
                                );
                              }
                            },
                            child: Card(
                              color: Color(0xFFFFDF13),
                              child: Center(
                                child: Text(
                                  "Verify",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              "Already have an Account?",
                              style: TextStyle(fontSize: 15),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => UserLogin2()));
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(fontSize: 15,  color: Color(0xFFFFDF13), ) ,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // SingleChildScrollView(
              //   child: Padding(
              //     padding: const EdgeInsets.only(top: 452.0),
              //     child: Container(
              //       decoration: BoxDecoration(
              //         border: Border(
              //           top:BorderSide(
              //             color: Colors.black, // Color of the top border
              //             width: 1, // Width of the top border
              //           ),
              //         ),
              //         color: Colors.white,
              //         borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(40.0),
              //           topRight: Radius.circular(40.0),
              //         ),
              //       ),
              //       height: 450,
              //       width: double.infinity,
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //         children: [
              //
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          )),
    );
  }
}






//signup

class UserLogin extends StatefulWidget {
  final String number;

  UserLogin({required this.number});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  bool _obscureText = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _addDataToFirestore(BuildContext context) {
    String email = _emailController.text;
    String name = _nameController.text;
    String password = _passwordController.text;
    String mobilenumber = widget.number;
    if (email.isNotEmpty && name.isNotEmpty && password.isNotEmpty) {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Specify a custom document name
      String documentName = name;

      // Add data to Firestore with custom document name
      firestore.collection('Admin').doc(documentName).set({
        'email': email,
        'name': name,
        'password': password,
        'number': mobilenumber,
      }).then((_) {
        // Show a success message or navigate to another page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => bottomnavigation()));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Admin data added successfully!')),
        );
      }).catchError((error) {
        // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding data to Firestore: $error')),
        );
      });
    } else {
      // Show an error message if the text field is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You missed to enter some field!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(

          child: Center(
            child: SizedBox(
              height: 650,
              width: MediaQuery.of(context).size.width * 0.97,
              child: Card(
                   elevation: 30,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "SignUp",
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 100, right: 100),
                      child: Divider(
                        // Divider to add a line
                        color: Colors.black, // Color of the line
                        thickness: 1, // Thickness of the line
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: SizedBox(
                          width: double.infinity,
                          height: 350,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        controller: _nameController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.person),
                                          // Icon to be displayed
                                          hintText: 'Enter Name',
                                          // Placeholder text when the field is empty
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide:
                                            BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.email),
                                          // Icon to be displayed
                                          hintText: 'Enter Email',
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide:
                                            BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                    (widget.number.isNotEmpty)
                                        ? Container(
                                      height: 50,
                                      child: TextFormField(
                                        enabled: false,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.phone),
                                          // Icon to be displayed
                                          hintText:
                                          widget.number.isNotEmpty
                                              ? widget.number
                                              : "Enter Mobile number",
                                          // Placeholder text when the field is empty
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide: BorderSide(
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    )
                                        : GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    Numberverification()));
                                      },
                                      child: Container(
                                        height: 50,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            // Border color
                                            width: 1.0, // Border width
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(
                                              30.0),
                                        ),
                                        child: TextFormField(
                                          enabled: false,
                                          decoration: InputDecoration(
                                            prefixIcon:
                                            Icon(Icons.phone),
                                            // Icon to be displayed
                                            hintText: widget
                                                .number.isNotEmpty
                                                ? widget.number
                                                : "Enter Mobile number", // Placeholder text when the field is empty
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 50,
                                      child: TextFormField(
                                        controller: _passwordController,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                            icon: Icon(_obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                          // Icon to be displayed
                                          hintText: 'Set Password',
                                          // Placeholder text when the field is empty
                                          border: OutlineInputBorder(
                                            borderRadius:
                                            BorderRadius.circular(30),
                                            borderSide:
                                            BorderSide(color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )),
                    ),

                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: GestureDetector(
                        onTap: () async{

                            final SharedPreferences sharedpreferences = await SharedPreferences
                                .getInstance();
                            sharedpreferences.setString(
                                "name", _nameController.text);

                            _addDataToFirestore(context);

                        },
                        child: Card(
                          color: Color(0xFFFFDF13),
                          child: Center(
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 15,),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserLogin2()));
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(fontSize: 15, color: Color(0xFFFFDF13),),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}






//login

class UserLogin2 extends StatefulWidget {
  const UserLogin2({super.key});

  @override
  State<UserLogin2> createState() => _UserLogin2State();
}

class _UserLogin2State extends State<UserLogin2> {
  bool _obscureText = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isValueNull = false;

  Future<void> retrieveFieldValue() async {
    try {
      // Get a reference to the Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Retrieve the document snapshot from the specified collection and document ID
      DocumentSnapshot documentSnapshot =
      await firestore.collection('Admin').doc(_nameController.text).get();
            print("${_nameController.text}");
      // Check if the document exists
      if (documentSnapshot.exists) {
        // Retrieve the field value by field name
        dynamic fieldValue = documentSnapshot['password'];

        if (fieldValue == _passwordController.text) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => bottomnavigation()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Oops!Enter Correct Password')),
          );
        }

        // Print or handle the field value as needed
        print('----------------->Field Value<-----------------: $fieldValue');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Oops!Enter Correct Name')),
        );
        print('Document does not exist.');
      }
    } catch (error) {
      print('Error retrieving field value: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: Center(
            child: Container(
              height: 500,
              width: MediaQuery.of(context).size.width * 0.97,
              child: Card(
                elevation: 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    Column(
                      children: [
                        Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 100, right: 100),
                          child: Divider(
                            // Divider to add a line
                            color: Colors.black, // Color of the line
                            thickness: 1, // Thickness of the line
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10.0, right: 10.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  controller: _nameController,
                                  //keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.person),
                                    // Icon to be displayed
                                    hintText: 'Enter Admin Name',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide:
                                      BorderSide(color: Colors.black),
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? 'Please enter Name'
                                        : null;
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(
                                height: 50,
                                child: TextFormField(
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.text,
                                  controller: _passwordController,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon: IconButton(
                                      icon: Icon(_obscureText
                                          ? Icons.visibility_off
                                          : Icons.visibility),
                                      onPressed: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                    ),
                                    hintText: 'Enter Password',
                                    border: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(30),
                                      borderSide: BorderSide(
                                          color: isValueNull
                                              ? Colors.red
                                              : Colors
                                              .black), // Adjust border color based on the value
                                    ),
                                  ),
                                  onChanged: (String value) {},
                                  validator: (value) {
                                    return value!.isEmpty
                                        ? 'Please enter password'
                                        : null;
                                  },
                                ),
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 180,
                                  ),
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Forget Password?",
                                      style: TextStyle(fontSize: 15, color: Color(0xFFFFDF13),),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: GestureDetector(
                        onTap: () async{
                          retrieveFieldValue();
                          getvalidationData();
                          final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
                          sharedpreferences.setString("name", _nameController.text);
                        },
                        child: Card(
                          color: Color(0xFFFFDF13),
                          child: Center(
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Numberverification()));
                            },
                            child: Text(
                              "Signup",
                              style: TextStyle(fontSize: 15, color: Color(0xFFFFDF13),),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  Future getvalidationData() async {
    final SharedPreferences sharedpreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedpreferences.getString("name");
    setState(() {
      finalEmail = obtainedEmail!;
    });
    print("--------------------------------------->$finalEmail");
  }
}
