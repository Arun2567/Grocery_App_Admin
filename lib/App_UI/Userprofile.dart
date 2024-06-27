import 'package:flutter/material.dart';
import 'package:my_project/App_UI/splash_screen.dart';
import 'package:my_project/App_UI/verification.dart';
import 'package:my_project/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';


//view your profile

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? email;
  String? name;
  String? password;
  String? phoneNumber;

  TextEditingController _newName = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
    getvalidationData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: 170,
                    width: double.infinity,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  "Admin Details",
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              ]),

                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "Name",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "Email",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "Mobile Number",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [

                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          ":",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          ":",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          ":",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(6.0),
                                        child: Text(
                                          "${name ?? ''}",
                                          style: TextStyle(fontSize: 17),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text("Do you want to change your Name?\n$name",style: TextStyle(fontSize: 15),),
                                                content: TextField(
                                                  controller: _newName,
                                                  decoration: InputDecoration(
                                                    hintText: "Type new name",
                                                  ),
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text("Cancel"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      passnewname();
                                                      Navigator.of(context).pop(); // Close the dialog
                                                    },
                                                    child: Text("Change"),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.edit),
                                      )

                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "${email ?? ''}",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Text(
                                      "${phoneNumber ?? ''}",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(),
                ListTile(
                  //leading: Icon(Icons.person),
                  title: Center(child: Text("Admins Details")),
                  // trailing: Icon(Icons.arrow_forward),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Adminsinfos()));
                  },
                ),
                Divider(
                  // Add Divider here
                  thickness: 1,
                  // Increase thickness here
                  color: Colors.grey,
                  // You can change the color as needed
                  height: 1, // Adjust the height as needed
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, _) {
                    return GestureDetector(
                      onTap: () {
                        themeProvider.toggleTheme();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                20.0), // Adjust the value to get desired curvature
                          ),
                          color: themeProvider.isDarkMode
                              ? Colors.grey[800]
                              : Colors.white,
                          child: AnimatedContainer(
                            width: double.infinity,
                            height: 60,
                            alignment: Alignment.center,
                            duration: Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  width: 5,
                                  color: themeProvider.isDarkMode
                                      ? Colors.black
                                      : Colors.lightBlueAccent,
                                )),
                            child: Text(
                              themeProvider.isDarkMode
                                  ? 'Dark Mode'
                                  : 'Light Mode',
                              style: TextStyle(
                                fontSize: 20,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: Center(
                    child: (name != null) ? Text("Logout") : Text("Register"),
                  ),
                  // trailing: Icon(Icons.arrow_forward),
                  onTap: () async {
                    final SharedPreferences sharedpreferences =
                    await SharedPreferences.getInstance();
                    sharedpreferences.remove("name");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => inilogin()));
                  },
                ),
                Divider(),
              ],
            ),
          ),
        ));
  }


  //pass new name

  Future<void> passnewname() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String newname = _newName.text;

    if (newname.isEmpty) {
      print("---------------->error in updating");
    } else {
      Map<String, dynamic> data = {
        'name': newname,
      };

      await firestore
          .collection('Admin')
          .doc(finalEmail)
          .update(data);
    }
  }
  //retriving data

  Future<void> fetchDataFromFirestore() async {
    try {
      // Access Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Specify the collection and document name
      DocumentReference documentReference =
      firestore.collection('Admin').doc(finalEmail);

      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Extract data from the document snapshot
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

        // Update state with retrieved data
        setState(() {
          email = data['email'];
          name = data['name'];
          password = data['password'];
          phoneNumber = data['number'];
        });
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error retrieving data from Firestore: $error');
    }
  }

  //retriving data by sharedpreference

  Future getvalidationData() async {
    final SharedPreferences sharedpreferences =
    await SharedPreferences.getInstance();
    var obtainedEmail = sharedpreferences.getString("name");
    setState(() {
      finalEmail = obtainedEmail!;
    });
    print("--------------------------------------->$finalEmail");
  }
}




//view all admins details

class Adminsinfos extends StatefulWidget {
  const Adminsinfos({super.key});

  @override
  State<Adminsinfos> createState() => _AdminsinfosState();
}

class _AdminsinfosState extends State<Adminsinfos> {
  List<Map<String, dynamic>> fieldValues = [];
  var _height = 60.0;
  var _width = double.infinity;
  Stream<QuerySnapshot<Object?>>? kgProductStream;

  Future<void> getFieldValues() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Admin').get();

      List<Map<String, dynamic>> values = [];
      // List<String> values2 = [];
      // List<String> values3 = [];

      querySnapshot.docs.forEach((doc) {
        // Replace 'your_field_name' with the actual name of the field you want to retrieve
        var fieldValue =
        (doc.data() as Map<String, dynamic>)['name'] as String?;
        var fieldValue2 =
        (doc.data() as Map<String, dynamic>)['email'] as String?;
        var fieldValue3 =
        (doc.data() as Map<String, dynamic>)['number'] as String?;

        if (fieldValue != null && fieldValue2 != null && fieldValue3 != null) {
          values.add({
            'field1': fieldValue,
            'field2': fieldValue2,
            'field3': fieldValue3,
          });
        }
      });

      setState(() {
        fieldValues = values;
      });
    } catch (e) {
      print('Error retrieving field values: $e');
    }
  }

  animationcontainer() {
    setState(() {
      if (_height == 60.0) {
        _height = 120.0;
      } else {
        _height = 60.0;
      }
      _width = double.infinity;
    });
  }

  @override
  void initState() {
    getFieldValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: ListView.builder(
        itemCount: fieldValues.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              animationcontainer();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: _width,
                height: _height,
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  child: (_height == 120.0 && _width == double.infinity)
                      ? Center(
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "${fieldValues[index]['field1']}",
                            ),
                            Text(
                              "${fieldValues[index]['field2']}",
                            ),
                            Text(
                              "${fieldValues[index]['field3']}",
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                      : Card(
                      child: Center(
                          child: Text(
                            "${fieldValues[index]['field1']}",
                          ))),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
