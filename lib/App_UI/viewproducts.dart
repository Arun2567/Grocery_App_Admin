import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_project/App_UI/addproducts.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:firebase_storage/firebase_storage.dart';


//code for retriving category

class Retrivedata extends StatefulWidget {
  const Retrivedata({super.key});

  @override
  State<Retrivedata> createState() => _RetrivedataState();
}

class _RetrivedataState extends State<Retrivedata> {
  List<String> documentNames = [];
  bool _showNoDataMessage = false;

  @override
  void initState() {
    super.initState();
    _retrieveDataFromFirestore();
     startTimer();
  }

  void startTimer() {
    // Start a timer to show the "no data" message after 20 seconds
    Future.delayed(Duration(seconds: 20), () {
      if (mounted && documentNames.isEmpty) {
        setState(() {
          _showNoDataMessage = true;
        });
      }
    });
  }

  void restartTimer() {
    setState(() {
      _showNoDataMessage = false;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Golden MaraChekku"),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh), // Your icon here
            onPressed: () async{

              restartTimer();

              FirebaseFirestore firestore = FirebaseFirestore.instance;

              try {
                QuerySnapshot querySnapshot =
                await firestore.collection('kgProduct').get();

                setState(() {
                  documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Refreshing")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Error retrieving category")),
                );
                print("Error retrieving document names: $e");
              }
              print('refresh the page');
            },
          ),
        ],
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,

      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            documentNames.isEmpty
                ? _showNoDataMessage
                ? Center(
              child: Text("No products are available,"),
            )
                : Center(
              child: CircularProgressIndicator(),
            )
                :  SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: documentNames.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Retrivesubcol(
                                  documentName: documentNames[index],
                                )));
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 70,
                            child: Card(
                              child:
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Text(documentNames[index]),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap:()async{
                                        try {
                                          // Get reference to the document
                                          DocumentReference docRef = FirebaseFirestore.instance.collection('kgProduct').doc(documentNames[index]);

                                          // Delete the document
                                          await docRef.delete();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text("${documentNames[index]} deleted Successfully")),
                                          );

                                          print('Document deleted successfully.');
                                        } catch (e) {
                                          print('Error deleting document: $e');
                                        }

                                        try {
                                          QuerySnapshot querySnapshot =
                                          await FirebaseFirestore.instance.collection('kgProduct').get();

                                          setState(() {
                                            documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
                                          });
                                        } catch (e) {
                                          print("Error retrieving document names: $e");
                                          // Handle error as per your requirement
                                        }
                                      },
                                      child: Icon(Icons.delete)),
                                  SizedBox(width: 20,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

                    //   ListTile(
                    //   title: Text(documentNames[index]),
                    // );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Addcollectioni()));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.cyan,
        shape: CircleBorder(),
      ),
    );
  }

  void _retrieveDataFromFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot =
      await firestore.collection('kgProduct').get();

      setState(() {
        documentNames = querySnapshot.docs.map((doc) => doc.id).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error retrieving category")),
      );
      print("Error retrieving document names: $e");
    }
  }

// void _deleteParentDocument(String documentName) async {
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//
//   try {
//     await firestore.collection('kgProduct').doc(documentName).delete();
//   } catch (e) {
//     // Handle error
//   }
//
// }
}




//code for retriving product name

class Retrivesubcol extends StatefulWidget {
  final String documentName;

  const Retrivesubcol({required this.documentName});

  @override
  State<Retrivesubcol> createState() => _RetrivesubcolState();
}

class _RetrivesubcolState extends State<Retrivesubcol> {
  List<dynamic> fieldValues = [];
  bool _showNoDataMessage = false;
  late Stream<QuerySnapshot> _queryStream;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
    startTimer();
    _queryStream = FirebaseFirestore.instance.collection('kgProduct').snapshots();

    // Set up a periodic timer to refresh data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          // Update the query stream to trigger a refresh
          _queryStream = FirebaseFirestore.instance.collection('kgProduct').snapshots();
        });
      }
    });
  }

  void startTimer() {
    // Start a timer to show the "no data" message after 20 seconds
    Future.delayed(Duration(seconds: 20), () {
      if (mounted && fieldValues.isEmpty) {
        setState(() {
          _showNoDataMessage = true;
        });
      }
    });
  }

  void restartTimer() {
    setState(() {
      _showNoDataMessage = false;
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.documentName),
          actions: [
            IconButton(
                icon: Icon(Icons.refresh), // Your icon here
                onPressed: () async {
                  try {
                    restartTimer();
                    // Retrieve the document from Firestore
                    DocumentSnapshot snapshot = await FirebaseFirestore.instance
                        .collection('kgProduct')
                        .doc(widget.documentName)
                        .get();

                    // Retrieve the array field values
                    setState(() {
                      fieldValues = snapshot.get('Products') ?? [];
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Refreshing")),
                    );
                  } catch (error) {
                    print("------------->$error");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Oops.....! Problem in Fetching Data")),
                    );
                    print('Error fetching data: $error');
                  }
                }
            ),
          ],
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.cyan,
        ),
        body:fieldValues.isEmpty
            ? _showNoDataMessage
            ? Center(
          child: Text("No Product are available,refresh the page"),
        )
            : Center(
          child: CircularProgressIndicator(),
        )
            :  Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: ListView.builder(

                  itemCount: fieldValues.length,
                  itemBuilder: (context, index) {
                    final currentFieldIndex = index;
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Retrivedocdata(
                                  documentName: widget.documentName, subCollectionName:fieldValues[currentFieldIndex].toString(),
                                )));
                      },
                      child: SizedBox(
                        width: double.infinity,
                        height: 70,
                        child: Card(
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(child: Center(child: Text(fieldValues[currentFieldIndex].toString()))),
                              GestureDetector(onTap:() async{
                                try {
                                  // Get reference to the parent document
                                  DocumentReference parentDocRef = FirebaseFirestore.instance
                                      .collection("kgProduct")
                                      .doc(widget.documentName);

                                  DocumentSnapshot snapshot = await parentDocRef.get();

                                  // Get the array field
                                  // Get the data from the snapshot and cast it to Map<String, dynamic>
                                  Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

                                  // Check if data is not null
                                  if (data != null) {
                                    // Retrieve the array field
                                    List<dynamic> array = data["Products"] ?? [];

                                    int index = array.indexOf(fieldValues[currentFieldIndex].toString());

                                    // If the value is found, remove it from the array
                                    if (index != -1) {
                                      array.removeAt(index);

                                      // Update the document with the modified array
                                      await parentDocRef.update({"Products": array});

                                      print('Field value ${fieldValues[currentFieldIndex].toString()} removed successfully.');
                                    } else {
                                      print('Field value ${fieldValues[currentFieldIndex].toString()} not found.');
                                    }
                                  }

                                  // to delete subcollection or product name in array

                                  // Get reference to the subcollection
                                  CollectionReference subcollectionRef =
                                  parentDocRef.collection(fieldValues[currentFieldIndex].toString());

                                  // Query documents in the subcollection
                                  QuerySnapshot subcollectionSnapshot = await subcollectionRef.get();

                                  // Delete each document in the subcollection
                                  for (DocumentSnapshot docSnapshot in subcollectionSnapshot.docs) {
                                    await docSnapshot.reference.delete();
                                  }

                                  // Delete the subcollection itself
                                  await parentDocRef.collection(fieldValues[currentFieldIndex].toString()).doc().delete();

                                  print('Subcollection ${fieldValues[currentFieldIndex].toString()} deleted successfully.');



                                  // to delete product name in allproducts
                                  FirebaseFirestore.instance
                                      .collection('allProduct') // Specify your collection name
                                      .doc("${fieldValues[currentFieldIndex].toString()}") // Specify the document ID you want to delete
                                      .delete()
                                      .then((value) {
                                    print("Document successfully deleted!");
                                  }).catchError((error) {
                                    print("Error deleting document: $error");
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("${fieldValues[currentFieldIndex].toString()} deleted Successfully")),
                                  );

                                } catch (error) {

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Oops...! Problem in Deleting Product")),
                                  );
                                  print('Error deleting subcollection: $error');
                                }
                              },
                                child: Icon(Icons.delete),
                              ),
                              SizedBox(width: 20,)
                            ],
                          ),
                        ),),
                    );


                    //   ListTile(
                    //   title: Text(fieldValues[index].toString()), // Display each field value in a ListTile
                    // );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
  Future<void> fetchDataFromFirestore() async {
    try {
      // Retrieve the document from Firestore
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('kgProduct')
          .doc(widget.documentName)
          .get();

      // Retrieve the array field values
      setState(() {
        fieldValues = snapshot.get('Products') ?? [];
      });
    } catch (error) {
      print('Error fetching data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops.....! Problem in Fetching Data")),
      );
    }
  }
}




//code for retriving product Details

class Retrivedocdata extends StatefulWidget {
  final String documentName;
  final String subCollectionName;

  // final String subCollectionName;

  const Retrivedocdata(
      {required this.documentName, required this.subCollectionName});

  @override
  State<Retrivedocdata> createState() => _RetrivedocdataState();
}

class _RetrivedocdataState extends State<Retrivedocdata> {
  List<dynamic> subcollectionData = [];
  late Future<List<String>> _imageUrls;
  bool _showNoDataMessage = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore();
    _imageUrls = getImageUrls();
    startTimer();
  }

  void startTimer() {
    // Start a timer to show the "no data" message after 20 seconds
    Future.delayed(Duration(seconds: 20), () {
      if (mounted && subcollectionData.isEmpty) {
        setState(() {
          _showNoDataMessage = true;
        });
      }
    });
  }

  void restartTimer() {
    setState(() {
      _showNoDataMessage = false;
    });
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCollectionName),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body:subcollectionData.isEmpty
          ? _showNoDataMessage
          ? Center(
        child: Text("No data available"),
      )
          : Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
          itemCount: subcollectionData.length,
          itemBuilder: (context, index) {
            return  Container(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    child: FutureBuilder<List<String>>(
                      future: _imageUrls,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          List<String> imageUrls = snapshot.data ?? [];
                          return PhotoViewGallery.builder(
                            itemCount: imageUrls.length,
                            builder: (context, index) {
                              return PhotoViewGalleryPageOptions(
                                imageProvider: NetworkImage(imageUrls[index]),
                                minScale: PhotoViewComputedScale.contained,
                                maxScale: PhotoViewComputedScale.covered * 2,
                              );
                            },
                          );
                        }
                      },
                    ),


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
                              "${subcollectionData[index]['category']}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "${subcollectionData[index]['Product_name']}",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: (subcollectionData[index]['Product_details'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['Product_details']}",
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
                              "50 Product",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "100 Product",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "200 Product",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "250 Product",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "500 Product",
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Text(
                              "1000 Product",
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
                            child: (subcollectionData[index]['quantity_five'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['quantity_five']}",
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
                            child: (subcollectionData[index]['quantity_hundred'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['quantity_hundred']}",
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
                            child: (subcollectionData[index]['quantity_twohun'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['quantity_twohun']}",
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
                            child: (subcollectionData[index]['quantity_twofive'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['quantity_twofive']}",
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
                            child: (subcollectionData[index]['quantity_fivehun'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['quantity_fivehun']}",
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
                            child: (subcollectionData[index]['quantity_thousand'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['quantity_thousand']}",
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
                            child: (subcollectionData[index]['price_five'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['price_five']}",
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
                            child: (subcollectionData[index]['price_hundred'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['price_hundred']}",
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
                            child: (subcollectionData[index]['price_twohun'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['price_twohun']}",
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
                            child: (subcollectionData[index]['price_twofive'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['price_twofive']}",
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
                            child: (subcollectionData[index]['price_fivehun'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['price_fivehun']}",
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
                            child: (subcollectionData[index]['price_thousand'].isNotEmpty)
                                ? Text(
                              "${subcollectionData[index]['price_thousand']}",
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
                ],
              ),
            );
          }

      ),
      //     : ListView.builder(
      //   itemCount: subcollectionData.length,
      //   itemBuilder: (context, index) {
      //     // Customize the UI according to your needs
      //     return ListTile(
      //       title: Text('Field 1: ${subcollectionData[index]['Product_name']}'),
      //       subtitle: Text('Field 2: ${subcollectionData[index]['Product_details']}'),
      //     );
      //   },
      // ) ,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _deleteAllDocumentsFromSubcollection,
            tooltip: 'Delete All Documents',
            child: Icon(Icons.delete),
          ),
          SizedBox(width: 20,),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => updatefield(
                        documentName: widget.documentName, subCollectionName:widget.subCollectionName,
                      )));
            },
            tooltip: 'Update Details',
            child: Icon(Icons.edit),
          ),
        ],
      ),

    );
  }

  Future<void> fetchDataFromFirestore() async {
    try {
      // Retrieve documents from the subcollection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('kgProduct')
          .doc(widget.documentName)
          .collection('${widget.subCollectionName}')
          .get();

      // Retrieve field values from each document
      setState(() {
        subcollectionData = querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      print('Error fetching data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops.....! Problem in Fetching Data")),
      );
    }
  }

  Future<List<String>> getImageUrls() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("others")
          .doc(widget.subCollectionName)
          .get();

      if (snapshot.exists) {
        List<String> urls = [];
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('urls')) {
          dynamic urlsData = data['urls'];

          if (urlsData is List<dynamic>) {
            urls.addAll(urlsData.map((url) => url.toString()));
          } else if (urlsData is String) {
            urls.add(urlsData.toString());
          }
        }

        return urls;
      }
    } catch (e) {
      print("Error retrieving image URLs: $e");
    }

    return []; // Return an empty list if the document doesn't exist or 'urls' key is not found
  }


  void _deleteAllDocumentsFromSubcollection() async {
    String parentId =
        widget.documentName; // Assuming _CollectionName is defined elsewhere
    String subCollectionName = widget.subCollectionName;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('kgProduct')
          .doc(parentId)
          .collection(subCollectionName)
          .get();

      for (QueryDocumentSnapshot docSnapshot in querySnapshot.docs) {
        await docSnapshot.reference.delete();
      }
    } catch (e) {
      print("error in deleting$e");
    }
  }
}



//code for update product Details

class updatefield extends StatefulWidget {
  final String documentName;
  final String subCollectionName;

  // final String subCollectionName;

  const updatefield(
      {required this.documentName, required this.subCollectionName});


  @override
  State<updatefield> createState() => _updatefieldState();
}

class _updatefieldState extends State<updatefield> {
  // late DocumentSnapshot _document;
  // late Map<String, dynamic> _data = {};
  // String id = "";


  TextEditingController _productname = TextEditingController();
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

  // TextEditingController _newquantity = TextEditingController();
  // TextEditingController _newprice = TextEditingController();
  // TextEditingController _newavailable = TextEditingController();


  List<dynamic> subcollectionData = [];
  List<String> newImageUrl = [];

  List<String> _imagePaths = [];
  late Future<List<String>> _imageUrls;
  int _currentIndexPaths = 0;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirestore1();
    _imageUrls = getImageUrls();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subCollectionName),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body:
      subcollectionData.isEmpty
          ? Center(
        child: CircularProgressIndicator(),
      )
          : Container(
        child: ListView.builder(
          itemCount: subcollectionData.length,
          itemBuilder: (context, index) {
            return Container(
              child: Column(
                children: [
                  Container(
                    height: 260,
                    child: FutureBuilder<List<String>>(
                      future: _imageUrls,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState
                            .waiting) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          List<String> imageUrls = snapshot.data ?? [];
                          return Column(
                            children: [
                              Expanded(
                                child: PhotoViewGallery.builder(
                                    itemCount: imageUrls.length,
                                    builder: (context, index) {
                                      return PhotoViewGalleryPageOptions(
                                        imageProvider: NetworkImage(
                                            imageUrls[index]),
                                        minScale: PhotoViewComputedScale
                                            .contained,
                                        maxScale: PhotoViewComputedScale
                                            .covered * 2,
                                      );
                                    },
                                    onPageChanged: (index) {
                                      setState(() {
                                        _currentIndexPaths = index;
                                      });
                                    }),
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      deleteAndUploadImage(imageUrls);
                                    },
                                    child: SizedBox(
                                      width: 200,
                                      height: 60,
                                      child: Card(
                                        child: Center(
                                          child: Text("Edit"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // uploadImageToStorage();
                                    },
                                    child: SizedBox(
                                      width: 200,
                                      height: 60,
                                      child: Card(
                                        child: Center(
                                          child: Text("upload"),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        }
                      },
                    ),


                  ),

                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: TextFormField(
                      controller: _productname,
                      decoration: InputDecoration(
                        hintText: "${subcollectionData[index]['Product_name']}",
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
                      controller: _productdetails,
                      decoration: InputDecoration(
                        hintText: "${subcollectionData[index]['Product_details']}",
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
                        DataCell(Text('50')),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['quantity_five']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _50available,
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['price_five']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _50price,
                        )),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('100')),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['quantity_hundred']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _100available,
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['price_hundred']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _100price,
                        )),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('200')),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['quantity_twohun']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _200available,
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['price_twohun']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _200price,
                        )),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('250')),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['quantity_twofive']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _250available,
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['price_twofive']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _250price,
                        )),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('500')),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['quantity_fivehun']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _500available,
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['price_fivehun']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _500price,
                        )),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('1000')),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['quantity_thousand']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _1000available,
                        )),
                        DataCell(TextField(
                          decoration: InputDecoration(
                            hintText: "${subcollectionData[index]['price_thousand']}",
                          ),
                          keyboardType: TextInputType.number,
                          controller: _1000price,
                        )),
                      ]),
                    ],
                  ),
                  SizedBox(
                      height: 70,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          updateDocument(index);
                        },
                        child: Text("Update"),
                      )),
                  SizedBox(height: MediaQuery
                      .of(context)
                      .viewInsets
                      .bottom),

                ],
              ),
            );
          },
        ),
      ),

      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(width: 20,),
          FloatingActionButton(
            onPressed: () {
              // updateDocument();
            },
            tooltip: 'Upadte Documents',
            child: Icon(Icons.done),
          ),
        ],
      ),

    );
  }

  Future<void> fetchDataFromFirestore1() async {
    try {
      // Retrieve documents from the subcollection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('kgProduct')
          .doc(widget.documentName)
          .collection('${widget.subCollectionName}')
          .get();

      // Retrieve field values from each document
      setState(() {
        subcollectionData =
            querySnapshot.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      print('Error fetching data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Oops.....! Problem in Fetching Data")),
      );
    }
  }

  Future<void> updateDocument(int index) async {
    String category = widget.documentName;
    String productname = widget.subCollectionName;
    String Productdetails = (_productdetails.text.isEmpty)
        ? "${subcollectionData[index]['Product_details']}"
        : _productdetails.text;
    String pricefive = (_50price.text.isEmpty)
        ? "${subcollectionData[index]['price_five']}"
        : _50price.text;
    String pricehundred = (_100price.text.isEmpty)
        ? "${subcollectionData[index]['price_hundred']}"
        : _100price.text;
    String pricetwohun = (_200price.text.isEmpty)
        ? "${subcollectionData[index]['price_twohun']}"
        : _200price.text;
    String pricetwofive = (_250price.text.isEmpty)
        ? "${subcollectionData[index]['price_twofive']}"
        : _250price.text;
    String pricefivehun = (_500price.text.isEmpty)
        ? "${subcollectionData[index]['price_fivehun']}"
        : _500price.text;
    String pricethousand = (_1000price.text.isEmpty)
        ? "${subcollectionData[index]['price_thousand']}"
        : _1000price.text;
    String quantityfive = (_50available.text.isEmpty)
        ? "${subcollectionData[index]['quantity_five']}"
        : _50available.text;
    String quantityhundred = (_100available.text.isEmpty)
        ? "${subcollectionData[index]['quantity_hundred']}"
        : _100available.text;
    String quantitytwohun = (_200available.text.isEmpty)
        ? "${subcollectionData[index]['quantity_twohun']}"
        : _200available.text;
    String quantitytwofive = (_250available.text.isEmpty)
        ? "${subcollectionData[index]['quantity_twofive']}"
        : _250available.text;
    String quantityfivehun = (_500available.text.isEmpty)
        ? "${subcollectionData[index]['quantity_fivehun']}"
        : _500available.text;
    String quantitythousand = (_1000available.text.isEmpty)
        ? "${subcollectionData[index]['quantity_thousand']}"
        : _1000available.text;


    String id = "${subcollectionData[index]['id']}";

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      //adding all product


      Map<String, dynamic> data1 = {
        "id": id,
        "category": category,
        "Product_name": productname,
        "Product_details": Productdetails,
        "price_thousand": pricethousand,
      };

      await firestore
          .collection("allProduct")
          .doc(productname)
          .update(data1);


      Map<String, dynamic> data = {
        "id": id,
        "category": category,
        "Product_name": productname,
        "Product_details": Productdetails,
        "price_five": pricefive,
        "price_hundred": pricehundred,
        "price_twohun": pricetwohun,
        "price_twofive": pricetwofive,
        "price_fivehun": pricefivehun,
        "price_thousand": pricethousand,
        "quantity_five": quantityfive,
        "quantity_hundred": quantityhundred,
        "quantity_twohun": quantitytwohun,
        "quantity_twofive": quantitytwofive,
        "quantity_fivehun": quantityfivehun,
        "quantity_thousand": quantitythousand,
      };

      await firestore
          .collection('kgProduct')
          .doc(category)
          .collection(productname)
          .doc(id)
          .update(data);

      //adding product names to array

      CollectionReference collectionReference = firestore.collection(
          'kgProduct');
      DocumentReference documentReference = collectionReference.doc(category);

      documentReference.update({
        "Products": FieldValue.arrayUnion([productname])
      }).then((_) {
        Navigator.of(context).pop();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details Updated Successfully')),
        );

        print('Field value added to the array in Firestore');
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error in adding Details')),
        );

        print('Failed to add field value to the array: $error');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in Update Details')),
      );
      print('${widget.subCollectionName}');
      print('Failed to add field value to the array: $e');
    }

    // }
  }

  Future<void> deleteAndUploadImage(List<String> imageUrls) async {
    try {
      String? oldImageUrl;

      // Check if the index is within bounds
      if (imageUrls.isNotEmpty && _currentIndexPaths >= 0 &&
          _currentIndexPaths < imageUrls.length) {
        oldImageUrl = imageUrls[_currentIndexPaths];

        // Delete existing image from Firebase Storage
        await FirebaseStorage.instance.refFromURL(oldImageUrl).delete();

        DocumentReference docRef = FirebaseFirestore.instance
            .collection("others")
            .doc(widget.subCollectionName);

        // Fetch the document snapshot
        DocumentSnapshot docSnapshot = await docRef.get();

        if (docSnapshot.exists) {
          // Get the current list of URLs from the document data
          List<dynamic> urls = List.from(
              (docSnapshot.data() as Map<String, dynamic>)['urls'] ?? []);

          // Check if the index is valid
          if (_currentIndexPaths >= 0 && _currentIndexPaths < urls.length) {
            // Remove the URL at the specified index
            urls.removeAt(_currentIndexPaths);

            // Update the document with the modified list of URLs
            await docRef.update({'urls': urls});

            print('URL at index $_currentIndexPaths deleted successfully.');
          } else {
            print('Invalid index: $_currentIndexPaths');
          }
        } else {
          print('Document does not exist.');
        }
      } else {

      }
    } catch (e) {
      print('Error updating image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update image')),
      );
    }
  }


  Future<List<String>> getImageUrls() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection("others")
          .doc(widget.subCollectionName)
          .get();

      if (snapshot.exists) {
        List<String> urls = [];
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;

        if (data != null && data.containsKey('urls')) {
          dynamic urlsData = data['urls'];

          if (urlsData is List<dynamic>) {
            urls.addAll(urlsData.map((url) => url.toString()));
          } else if (urlsData is String) {
            urls.add(urlsData.toString());
          }
        }

        return urls;
      }
    } catch (e) {
      print("Error retrieving image URLs: $e");
    }

    return [
    ]; // Return an empty list if the document doesn't exist or 'urls' key is not found
  }
}