import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/App_UI/bottomnavigation.dart';
import 'package:random_string/random_string.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:firebase_storage/firebase_storage.dart';

// code for choosing category

class Addcollectioni extends StatefulWidget {
  const Addcollectioni({super.key});

  @override
  State<Addcollectioni> createState() => _AddcollectioniState();
}

class _AddcollectioniState extends State<Addcollectioni> {


  final TextEditingController _documentname = TextEditingController();
  final TextEditingController _subcollection = TextEditingController();
  FocusNode _documentNameFocusNode = FocusNode();
  FocusNode _documentNameFocusNode2 = FocusNode();


  bool _showContainer = false;
  bool _showContainer1 = false;
  String Documentname = "";
  String _selectedItem = 'g';
  List<String> similarWords = [];
  List<String> documentNames = [];

  @override
  void dispose() {
    _subcollection.dispose();
    _documentname.dispose();
    _documentNameFocusNode.dispose();
    _documentNameFocusNode2.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _retrieveDataFromFirestore();
    _documentNameFocusNode.addListener(_onFocusChange);
    _documentNameFocusNode2.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _showContainer = _documentNameFocusNode.hasFocus;
      _showContainer1 = _documentNameFocusNode2.hasFocus;
    });
  }

  @override


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          "Add Products",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    children: [
                                      Text("Select product is gram or litre  :   " ,style: TextStyle(fontSize: 18),),
                                      DropdownButton<String>(
                                        value: _selectedItem,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedItem = newValue!;
                                          });
                                        },
                                        items: <String>['g', 'ml']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value,style: TextStyle(fontSize: 18,color: Colors.red),),
                                              );
                                            }).toList(),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: TextFormField(
                                    controller: _documentname,
                                    focusNode: _documentNameFocusNode,
                                    decoration: InputDecoration(
                                      labelText: "Category",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide(color: Colors.black),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      setState(() {
                                        _showContainer = value.isEmpty;
                                      });
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: _showContainer,
                                  child: Container(
                                    width: double.infinity,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          //top: BorderSide(width: 1,color: Colors.black),
                                            left: BorderSide(width: 1,color: Colors.black),
                                            right: BorderSide(width: 1,color: Colors.black),
                                            bottom: BorderSide(width: 1,color: Colors.black)
                                        ),
                                        borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0),
                                        )
                                    ),
                                    child: ListView.builder(
                                      // physics: NeverScrollableScrollPhysics(),
                                      itemCount: documentNames.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          title: Text(documentNames[index]),
                                          onTap: () {
                                            setState(() {
                                              _documentname.text =
                                              documentNames[index];
                                              _showContainer =
                                              false; // Close the container
                                            });
                                            print(
                                                "---------->$_documentname<----------------");
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                (similarWords.isEmpty)
                                    ? Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: TextFormField(
                                        controller: _subcollection,
                                        focusNode: _documentNameFocusNode2,
                                        decoration: InputDecoration(
                                          labelText: "Product Name",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.black),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          _getSimilarWords(value);
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: _showContainer1,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 1,color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all( Radius.circular(10.0),)
                                        ),
                                        child: ListView.builder(
                                          itemCount: similarWords.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                  similarWords[index]),
                                              onTap: () {
                                                // Handle tap on similar word item
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                                    : Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: TextFormField(
                                        controller: _subcollection,
                                        focusNode: _documentNameFocusNode2,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(10),
                                            borderSide: BorderSide(color: Colors.black),
                                          ),
                                          labelText: "Product Name",
                                          errorText: (similarWords
                                              .isNotEmpty)
                                              ? "Please enter New Product Name"
                                              : null,
                                          errorStyle:
                                          TextStyle(color: Colors.red),
                                        ),
                                        onChanged: (value) {
                                          _getSimilarWords(value);
                                        },
                                      ),
                                    ),
                                    Visibility(
                                      visible: _showContainer1,
                                      child: Container(
                                        height: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                              width: 1,color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all( Radius.circular(10.0),)
                                        ),
                                        child: ListView.builder(
                                          itemCount: similarWords.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                  similarWords[index]),
                                              onTap: () {
                                                // Handle tap on similar word item
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
                height: 65,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {

                      if (similarWords.isNotEmpty ||
                          _documentname.text.isEmpty ||
                          _subcollection.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Enter new product")),
                        );

                      } else {
                        addData();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            0), // Adjust the border radius as needed
                      ),
                      backgroundColor: Colors.cyan, // Change the button color
                      minimumSize: Size.square(50), // Set the button size
                    ),
                    child: Text("Add Product"))),
          ],
        ),
      ),
    );
  }

  // to get similar productnames

  void _getSimilarWords(String enteredWord) async {
    try {
      // Clear the existing list
      setState(() {
        similarWords.clear();
      });

      // Convert entered word to lowercase and remove spaces
      String normalizedEnteredWord =
      enteredWord.toLowerCase().replaceAll(' ', '');

      // Get reference to the document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('kgProduct')
          .doc(_documentname.text)
          .get();

      // Extract similar words from the document's array field value
      dynamic fieldValue = snapshot.get('Products');
      if (fieldValue is List<dynamic>) {
        for (dynamic item in fieldValue) {
          if (item is String) {
            // Convert field value to lowercase and remove spaces
            String normalizedItem = item.toLowerCase().replaceAll(' ', '');
            if (normalizedItem.startsWith(normalizedEnteredWord)) {
              setState(() {
                similarWords.add(item);
              });
            }
          }
        }
      }
    } catch (error) {
      print('Error getting similar words: $error');
    }
  }

  // to retrive old category

  void _retrieveDataFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('kgProduct').get();

      setState(() {
        documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      print("Error retrieving document names: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error in retriving Data")),
      );
      // Handle error as per your requirement
    }
  }

  //to add new category to database

  Future<void> addData() async {
    String category = _documentname.text;
    String productname = _subcollection.text;
    try {
      FirebaseFirestore.instance
          .collection("kgProduct")
          .doc(category)
          .get()
          .then((doc) {
        if (doc.exists) {
          // Document already exists, update it
          FirebaseFirestore.instance
              .collection("kgProduct")
              .doc(category)
              .update({
            "Products": FieldValue.arrayUnion([productname])
          }).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added Successfully')),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addcollection(
                  documentname: _documentname.text,
                  subcollection: _subcollection.text,
                  measurement: _selectedItem,
                ),
              ),
            );

            print('Added Successfully - $category');
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error in Updating details')),
            );
            print('Error in Updating details: $error');
          });
        } else {
          // Document doesn't exist, create it with the field
          FirebaseFirestore.instance
              .collection("kgProduct")
              .doc(category)
              .set({
            "Products": [productname] // Creating the field "Products" with an array containing the productname
          }).then((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Added Successfully')),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addcollection(
                  documentname: _documentname.text,
                  subcollection: _subcollection.text,
                  measurement: _selectedItem,
                ),
              ),
            );

            print('Added Successfully - $category');
          }).catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error in Adding details')),
            );
            print('Error in Adding details: $error');
          });
        }
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}






//code for entering details

class addcollection extends StatefulWidget {
  final String documentname;

  final String subcollection;
  final String measurement;

  addcollection(
      {required this.subcollection,
        required this.documentname,
        required this.measurement});

  @override
  State<addcollection> createState() => _addcollectionState();
}

class _addcollectionState extends State<addcollection> {

  //assigned text control to string

  //for entering details

  String productdetails = "";

  String pricefive = "";
  String pricehun = "";
  String pricetwohun = "";
  String pricetwofive = "";
  String pricefivehun = "";
  String pricethou = "";

  String availablefive = "";
  String availablehun = "";
  String availabletwohun = "";
  String availabletwofive = "";
  String availablefivhun = "";
  String availablethous = "";

  //for new adding quantity

  List<String> newquantity = [];
  List<String> newavailable= [];
  List<String> newprice = [];

  //for image uploading

  List<String> imgurl = [] ;
  int _currentIndexPaths = 0;
  List<String> _imagePaths = [];


  //for speed dial

  bool _isDialOpen = false;


  //text field controllers

  TextEditingController _productdetails = TextEditingController();

  TextEditingController _50price = TextEditingController();
  TextEditingController _100price = TextEditingController();
  TextEditingController _200price = TextEditingController();
  TextEditingController _250price = TextEditingController();
  TextEditingController _500price = TextEditingController();
  TextEditingController _1000price = TextEditingController();

  TextEditingController _50available = TextEditingController();
  TextEditingController _100available = TextEditingController();
  TextEditingController _200available = TextEditingController();
  TextEditingController _250available = TextEditingController();
  TextEditingController _500available = TextEditingController();
  TextEditingController _1000available = TextEditingController();

  TextEditingController _newquantity = TextEditingController();
  TextEditingController _newprice = TextEditingController();
  TextEditingController _newavailable = TextEditingController();


  @override
  void dispose() {
    _newquantity.dispose();
    _newprice.dispose();
    _newavailable.dispose(); // Dispose the TextEditingController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Show alert dialog when the back button is pressed
        bool confirmExit = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Alert....!"),
              content: Text("Are you sure you want to delete ${widget.subcollection} product?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                  child: Text("No"),
                ),
                TextButton(
                  onPressed: () {
                    _deleteSubcollection();
                    Navigator.of(context).pop(true); // Return true
                  },
                  child: Text("Yes"),
                ),
              ],
            );
          },
        );

        // Return the value obtained from the dialog
        return confirmExit ?? false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.cyan,
            title: Text(
              widget.subcollection,
              style: TextStyle(color: Colors.black, fontSize: 25),
            ),
          ),
          body: Stack(
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _imagePaths.isNotEmpty
                                  ? Column(
                                children: [
                                  SizedBox(
                                    height: 200,
                                    child: GestureDetector(
                                      onTap:() {
                                        _showFullScreenImage(_currentIndexPaths); // Close the full-screen view on tap
                                      },
                                      child: PhotoViewGallery.builder(
                                        itemCount: _imagePaths.length,
                                        builder: (context, index) {
                                          return PhotoViewGalleryPageOptions(
                                            imageProvider: FileImage(File(_imagePaths[index])),
                                            minScale: PhotoViewComputedScale.contained,
                                            maxScale: PhotoViewComputedScale.covered * 2,
                                          );
                                        },
                                        onPageChanged: (index) {
                                          setState(() {
                                            _currentIndexPaths = index;
                                          });
                                        },
                                        scrollPhysics: BouncingScrollPhysics(),
                                        backgroundDecoration: BoxDecoration(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  Text('Image ${_currentIndexPaths + 1} of ${_imagePaths.length}'),
                                  SizedBox(height: 20),
                                  GestureDetector(
                                    onTap: (){
                                      uploadimage();
                                    },
                                    child: SizedBox(
                                        height: 60,
                                        width: double.infinity,
                                        child: Card(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("Upload"),
                                              Icon(Icons.upload)
                                            ],
                                          ),
                                        )),
                                  )
                                ],
                              )
                                  : Container(),
                              Divider(
                                // Add Divider here
                                thickness: 2,
                                // Increase thickness here
                                color: Colors.black,
                                // You can change the color as needed
                                height: 1, // Adjust the height as needed
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "Category",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "Product Name",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "Product details",
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "${widget.documentname}",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "${widget.subcollection}",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (productdetails.isNotEmpty)
                                                ? Text(
                                              "$productdetails",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(
                                    // Add Divider here
                                    thickness: 2,
                                    // Increase thickness here
                                    color: Colors.black,
                                    // You can change the color as needed
                                    height: 1, // Adjust the height as needed
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            // padding: const EdgeInsets.only(left:20.0,top:6.0,bottom:6.0),
                                            child: Text(
                                              "Quantity",
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "50${widget.measurement} Product",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "100${widget.measurement} Product",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "200${widget.measurement} Product",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "250${widget.measurement} Product",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "500${widget.measurement} Product",
                                              style: TextStyle(fontSize: 17),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "1000${widget.measurement} Product",
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "Available",
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (availablefive.isNotEmpty)
                                                ? Text(
                                              "$availablefive",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (availablehun.isNotEmpty)
                                                ? Text(
                                              "$availablehun",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricetwohun.isNotEmpty)
                                                ? Text(
                                              "$pricetwohun",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (availabletwofive.isNotEmpty)
                                                ? Text(
                                              "$availabletwofive",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (availablefivhun.isNotEmpty)
                                                ? Text(
                                              "$availablefivhun",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (availablethous.isNotEmpty)
                                                ? Text(
                                              "$availablethous",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
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
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: Text(
                                              "Price",
                                              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricefive.isNotEmpty)
                                                ? Text(
                                              "$pricefive",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricehun.isNotEmpty)
                                                ? Text(
                                              "$pricehun",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricetwohun.isNotEmpty)
                                                ? Text(
                                              "$pricetwohun",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricetwofive.isNotEmpty)
                                                ? Text(
                                              "$pricetwofive",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricefivehun.isNotEmpty)
                                                ? Text(
                                              "$pricefivehun",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(6.0),
                                            child: (pricethou.isNotEmpty)
                                                ? Text(
                                              "$pricethou",
                                              style: TextStyle(fontSize: 17),
                                            )
                                                : Text(
                                              "No field",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                // Add Divider here
                                thickness: 2,
                                // Increase thickness here
                                color: Colors.black,
                                // You can change the color as needed
                                height: 1, // Adjust the height as needed
                              ),
                              (newquantity.isNotEmpty &&
                                  newavailable.isNotEmpty &&
                                  newprice.isNotEmpty)
                                  ? Column(
                                children: [
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text("New Added Value"),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Divider(
                                    // Add Divider here
                                    indent: 120,
                                    // Adjust indentation as needed
                                    endIndent: 120,
                                    color: Colors.grey,
                                    // You can change the color as needed
                                    height:
                                    1, // Adjust the height as needed
                                  ),
                                ],
                              )
                                  : Text(""),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Column(
                                    children: [
                                      SizedBox(
                                          height: 200,
                                          child: ListView.builder(
                                            // physics: NeverScrollableScrollPhysics(),
                                              itemCount: newquantity.length &
                                              newavailable.length&
                                              newprice.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  // width: double.infinity,
                                                  // height: 100,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      SizedBox(
                                                        height: 20,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            child: Text(
                                                              "${newquantity[index]}${widget.measurement} Product",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                          ),
                                                          Text(":"),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                            child: Text(
                                                              "${newavailable[index]} Available",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                          ),
                                                          Text(":"),
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                            child: Text(
                                                              "${newprice[index]} Rs",
                                                              style: TextStyle(
                                                                  fontSize: 17),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              })),
                                    ],
                                  ),
                                ),
                              ),
                              Divider(
                                // Add Divider here
                                color: Colors.grey,
                                // You can change the color as needed
                                height: 1, // Adjust the height as needed
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 65,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>bottomnavigation()));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                0), // Adjust the border radius as needed
                          ),
                          backgroundColor: Colors.cyan,
                          // Change the button color
                          minimumSize: Size.square(50), // Set the button size
                        ),
                        child: Center(
                          child: Text("Add Products"),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 70.0, right: 20),
                  // Adjust this padding as needed
                  child: SpeedDial(
                    animatedIcon: AnimatedIcons.add_event,
                    spacing: 20,
                    spaceBetweenChildren: 20,
                    closeManually: _isDialOpen,
                    children: [
                      SpeedDialChild(
                        // backgroundColor: (_quantity != "No field" ||  _checkbox !="No field" )?Colors.green:Colors.grey,
                          child: Icon(Icons.check_box),
                          label: "Add new details",
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                builder: (BuildContext context){
                                  return Container(
                                    child: ListView(
                                      reverse: true,
                                      children: [
                                        Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(height: 10,),
                                            Text("Enter New Quantity",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                                            Divider(
                                              // Divider to add a line
                                              color: Colors.black, // Color of the line
                                              thickness: 1, // Thickness of the line
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: TextFormField(
                                                controller: _newquantity,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Enter Quantity",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: TextFormField(
                                                controller: _newavailable,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "No of Products",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: TextFormField(
                                                controller: _newprice,
                                                keyboardType: TextInputType.number,
                                                decoration: InputDecoration(
                                                  labelText: "Price",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height:50,
                                                  width: 180,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.red, // Set the background color
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10), // Set the border radius
                                                        ),
                                                      ),
                                                      child: Text("Cancel")),
                                                ),
                                                SizedBox(
                                                  height:50,
                                                  width: 180,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        _addnewdetailstofirebase();
                                                        Navigator.of(context).pop();
                                                        setState(() {
                                                          newquantity.add(_newquantity.text);
                                                          newavailable.add(_newavailable.text); // Use _newavailable controller
                                                          newprice.add(_newprice.text); // Use _newprice controller

                                                          _newquantity.clear();
                                                          _newprice.clear();
                                                          _newavailable.clear();
                                                        });
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.green, // Set the background color
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10), // Set the border radius
                                                        ),
                                                      ),
                                                      child: Text("Add")),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 50,),
                                            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                      SpeedDialChild(
                          child: Icon(Icons.description_outlined),
                          label: "Details",
                          onTap: () {
                            showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                builder: (BuildContext context){
                                  return Container(
                                    child: ListView(
                                      reverse: true,
                                      children: [
                                        Column(
                                          children: [
                                            SizedBox(height: 20,),
                                            Text("Enter Details",style: TextStyle(fontSize:16,fontWeight: FontWeight.bold),),
                                            Divider(
                                              // Divider to add a line
                                              color: Colors.black, // Color of the line
                                              thickness: 1, // Thickness of the line
                                            ),
                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: const EdgeInsets.all(20.0),
                                              child: TextFormField(
                                                controller: _productdetails,
                                                decoration: InputDecoration(
                                                  labelText: "products details",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: BorderSide(color: Colors.black),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            DataTable(
                                              // decoration: BoxDecoration(
                                              //   border: Border.all(color: Colors.black), // Add border to DataTable
                                              // ),
                                              columns: [
                                                DataColumn(label: Text('Quantity')),
                                                DataColumn(label: Text('No of products')),
                                                DataColumn(label: Text('Price')),
                                              ],
                                              rows: [
                                                DataRow(cells: [
                                                  DataCell(Text('50${widget.measurement}')),
                                                  DataCell(TextField(controller: _50available,keyboardType: TextInputType.number,)),
                                                  DataCell(TextField(controller: _50price,keyboardType: TextInputType.number,)),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(Text('100${widget.measurement}')),
                                                  DataCell(TextField(controller: _100available,keyboardType: TextInputType.number,)),
                                                  DataCell(TextField(controller: _100price,keyboardType: TextInputType.number,)),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(Text('200${widget.measurement}')),
                                                  DataCell(TextField(controller: _200available,keyboardType: TextInputType.number,)),
                                                  DataCell(TextField(controller: _200price,keyboardType: TextInputType.number,)),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(Text('250${widget.measurement}')),
                                                  DataCell(TextField(controller: _250available,keyboardType: TextInputType.number,)),
                                                  DataCell(TextField(controller: _250price,keyboardType: TextInputType.number,)),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(Text('500${widget.measurement}')),
                                                  DataCell(TextField(controller: _500available,keyboardType: TextInputType.number,)),
                                                  DataCell(TextField(controller: _500price,keyboardType: TextInputType.number,)),
                                                ]),
                                                DataRow(cells: [
                                                  DataCell(Text('1000${widget.measurement}')),
                                                  DataCell(TextField(controller: _1000available,keyboardType: TextInputType.number,)),
                                                  DataCell(TextField(controller: _1000price,keyboardType: TextInputType.number,)),
                                                ]),
                                              ],
                                            ),
                                            SizedBox(height: 40,),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  height:50,
                                                  width: 180,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.red, // Set the background color
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10), // Set the border radius
                                                        ),
                                                      ),
                                                      child: Text("Cancel")),
                                                ),
                                                SizedBox(
                                                  height:50,
                                                  width: 180,
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        _addDetailstoFirebase();
                                                        setState(() {
                                                          productdetails = _productdetails.text;

                                                          pricefive = _50price.text;
                                                          pricehun = _100price.text;
                                                          pricetwohun = _200price.text;
                                                          pricetwofive = _250price.text;
                                                          pricefivehun = _500price.text;
                                                          pricethou = _1000price.text;

                                                          availablefive = _50available.text;
                                                          availablehun = _100available.text;
                                                          availabletwohun = _200available.text;
                                                          availabletwofive = _250available.text;
                                                          availablefivhun = _500available.text;
                                                          availablethous = _1000available.text;
                                                        });
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        primary: Colors.green, // Set the background color
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10), // Set the border radius
                                                        ),
                                                      ),
                                                      child: Text("Add")),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 20,),
                                            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),

                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                });
                          }),
                      SpeedDialChild(
                        child: Icon(Icons.camera_alt_rounded),
                        label: "Product images",
                        onTap: _pickImageFromGallery,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }


  // code for passing value to firestore

  void _addDetailstoFirebase() async{

    String category = widget.documentname;
    String productname = widget.subcollection;
    String measurement = widget.measurement;

    String Productdetails = _productdetails.text;
    String pricefive =  _50price.text;
    String pricehundred =  _100price.text;
    String pricetwohun =  _200price.text;
    String pricetwofive =  _250price.text;
    String pricefivehun =  _500price.text;
    String pricethousand =  _1000price.text;
    String quantityfive =  _50available.text;
    String quantityhundred =  _100available.text;
    String quantitytwohun =  _200available.text;
    String quantitytwofive =  _250available.text;
    String quantityfivehun =  _500available.text;
    String quantitythousand =  _1000available.text;

    String id = randomAlphaNumeric(16);


    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //adding all product

      if (Productdetails.isNotEmpty &&
          pricefive.isNotEmpty &&
          pricehundred.isNotEmpty &&
          pricetwohun.isNotEmpty &&
          pricetwofive.isNotEmpty &&
          pricefivehun.isNotEmpty &&
          pricethousand.isNotEmpty &&
          quantityfive.isNotEmpty &&
          quantityhundred.isNotEmpty &&
          quantitytwohun.isNotEmpty &&
          quantitytwofive.isNotEmpty &&
          quantityfivehun.isNotEmpty &&
          quantitythousand.isNotEmpty) {


        Map<String, dynamic> data1 = {
          "id": id,
          "category":category,
          "Product_name":productname,
          "Product_details":Productdetails,
          "price_thousand" :pricethousand,
          "type_of_quantity":measurement,
        };

        await firestore
            .collection("allProduct")
            .doc(productname)
            .set(data1);


        Map<String, dynamic> data = {
          "id": id,
          "category":category,
          "Product_name":productname,
          "Product_details":Productdetails,
          "price_five" :pricefive,
          "price_hundred" :pricehundred,
          "price_twohun" : pricetwohun,
          "price_twofive" :pricetwofive,
          "price_fivehun" :pricefivehun,
          "price_thousand" :pricethousand,
          "quantity_five":quantityfive,
          "quantity_hundred":quantityhundred,
          "quantity_twohun":quantitytwohun,
          "quantity_twofive":quantitytwofive,
          "quantity_fivehun":quantityfivehun,
          "quantity_thousand":quantitythousand,
          "type_of_quantity":measurement,
        };

        await firestore
            .collection('kgProduct')
            .doc(category)
            .collection(productname)
            .doc(id)
            .set(data);

        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added Successfully')),
        );
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oops....! Some Field is Empty , if you don't want that field fill as 0" )),
        );
        Navigator.of(context).pop();
      }


    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in adding Details')),
      );

      print('Failed to add field value to the array: $e');
    }
  }

  void _addnewdetailstofirebase() async{

    String category = widget.documentname;
    String productname = widget.subcollection;
    String id = randomAlphaNumeric(16);

    try{
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //adding all product

      if (newquantity.isNotEmpty &&
          newavailable.isNotEmpty &&
          newprice.isNotEmpty ) {



        Map<String, dynamic> data2 = {
          "${newquantity}${widget.measurement}available":"${newavailable}",
          "${newquantity}${widget.measurement}price":"${newprice}",

        };

        await firestore
            .collection('kgProduct')
            .doc(category)
            .collection(productname)
            .doc(id)
            .set(data2);


        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added Successfully')),
        );

        print('Field value added to the array in Firestore');
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Oops....! Some Field is Empty , if you don't want that field fill as 0" )),
        );
        // Navigator.of(context).pop();
      }


    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in adding Details')),
      );

      print('Failed to add field value to the array: $e');
    }
  }

  // Deleting Productname and details

  Future<void> _deleteSubcollection() async {
    try {

      //code to delete array of document in kgproducts

      // Get reference to the parent document
      DocumentReference parentDocRef = FirebaseFirestore.instance
          .collection("kgProduct")
          .doc(widget.documentname);

      DocumentSnapshot snapshot = await parentDocRef.get();

      // Get the array field
      // Get the data from the snapshot and cast it to Map<String, dynamic>
      Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

      // Check if data is not null
      if (data != null) {
        // Retrieve the array field
        List<dynamic> array = data["Products"] ?? [];

        int index = array.indexOf(widget.subcollection);

        // If the value is found, remove it from the array
        if (index != -1) {
          array.removeAt(index);

          // Update the document with the modified array
          await parentDocRef.update({"Products": array});

          print('Field value ${widget.subcollection} removed successfully.');
        } else {
          print('Field value ${widget.subcollection} not found.');
        }
      }



      // code delete subcollection in kgproducts

      // Get reference to the subcollection
      CollectionReference subcollectionRef =
      parentDocRef.collection(widget.subcollection);

      // Query documents in the subcollection
      QuerySnapshot subcollectionSnapshot = await subcollectionRef.get();

      // Delete each document in the subcollection
      for (DocumentSnapshot docSnapshot in subcollectionSnapshot.docs) {
        await docSnapshot.reference.delete();
      }

      // Delete the subcollection itself

      await parentDocRef.collection(widget.subcollection).doc().delete();



      // code delete document in allProduct

      FirebaseFirestore.instance
          .collection('allProduct') // Specify your collection name
          .doc(widget.subcollection) // Specify the document ID you want to delete
          .delete()
          .then((value) {
        print("Document successfully deleted!");
      }).catchError((error) {
        print("Error deleting document: $error");
      });


      DocumentReference docRef =
      FirebaseFirestore.instance.collection("others").doc(widget.subcollection);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Get the array of field values
        List<dynamic> fieldValues = (docSnapshot.data() as Map<String, dynamic>)['urls'];

        // Delete each image from Firebase Storage
        for (String imageName in fieldValues) {
          await FirebaseStorage.instance
              .ref('product_Image/image_${widget.subcollection}')
              .delete();
        }

        // Delete all field values in the array
        await docRef.update({'urls': FieldValue.delete()});

        // Document fields deleted
        print('Document fields deleted successfully.');
      } else {
        print('Document does not exist.');
      }


      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Entered details deleted Successfully")),
      );


      print('Subcollection ${widget.subcollection} deleted successfully.');
    } catch (error) {
      print('Error deleting subcollection: $error');
    }
  }


  //add images code

  Future<void> _pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    } else {
      // The user canceled the image selection.
    }
  }

  void _showFullScreenImage(int index) {
    if (index >= 0 && index < _imagePaths.length) {
      setState(() {
        _currentIndexPaths = index;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FullScreenImageView(
            imagePath: _imagePaths[index],
            onDelete: () {
              _deleteImage(index);
            },
          ),
        ),
      );
    }
  }

  Future<void> uploadimage() async {

    String category = widget.documentname;
    String productname = widget.subcollection;
    String id = randomAlphaNumeric(16);

    String uniquename = DateTime.now().millisecondsSinceEpoch.toString();


    try {
      for (int i = 0; i < _imagePaths.length; i++) {
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceFolder = referenceRoot.child("product_Image");
        Reference referenceDirImages = referenceFolder.child("image_$productname");
        Reference referenceImgtoUpload = referenceDirImages.child(uniquename);
        UploadTask uploadTask =  referenceImgtoUpload.putFile(File(_imagePaths[i]));

        await uploadTask.whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All images are Uploaded"))));
        await uploadTask.whenComplete(() => print('Image $i uploaded'));
        String downloadUrl = await referenceImgtoUpload.getDownloadURL();
        imgurl.add(downloadUrl);
        print("---------------------->${imgurl[i]}");
        await FirebaseFirestore.instance
            .collection("others")
            .doc(productname)
            .set({
          'urls': FieldValue.arrayUnion(imgurl),
        });

      }
    }catch(e){
      print("$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in uploading Image")));
    }

  }

  void _deleteImage(int index) {
    setState(() {
      if (index >= 0 && index < _imagePaths.length) {
        _imagePaths.removeAt(index);
        if (_currentIndexPaths >= _imagePaths.length) {
          _currentIndexPaths = _imagePaths.length - 1;
        }
      }
    });
    Navigator.pop(context);
  }

}





//code to view image in full screen

class FullScreenImageView extends StatelessWidget {
  final String imagePath;
  final VoidCallback onDelete;

  FullScreenImageView({required this.imagePath, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close the full-screen view on tap
        },
        child: Container(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: PhotoView(
                    imageProvider: FileImage(File(imagePath)),
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  ),
                ),
                GestureDetector(
                  onTap:onDelete,
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: Card(


                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Delete Image'),
                          Icon(Icons.delete)
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

