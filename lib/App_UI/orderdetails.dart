import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class OrderCategory extends StatefulWidget {
  const OrderCategory({Key? key}) : super(key: key);

  @override
  State<OrderCategory> createState() => _OrderCategoryState();
}

class _OrderCategoryState extends State<OrderCategory> {

  int totalcard = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          'Customers Order',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: Container(
        child: Center(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      height: MediaQuery.of(context).size.height * 0.22,
                      child: GestureDetector(
                        onTap: () {
                          // Replace the following line with the navigation logic you want
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => OrderPlaced(totalCards: (data) {
                              setState(() {
                                totalcard = data;
                              });
                            })),
                          );
                        },
                        child: Card(
                          child: Stack(
                            children: [
                              ListTile(
                                title: Text('New Order'),
                              ),
                              Positioned(
                                top: 5,
                                right: 5,
                                child: CircleAvatar(
                                  backgroundColor: Colors.red,
                                  radius: 12,
                                  child: Text(
                                    totalcard.toString(), // Display the dynamic count
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
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
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: GestureDetector(
                            onTap: () {
                              // Replace the following line with the navigation logic you want
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => packed(totalCards: (data) {
                                  setState(() {
                                    totalcard = data;
                                  });
                                })),
                              );
                            },
                            child: Card(
                              child:  Stack(
                                children: [
                                  ListTile(
                                    title: Text('Packed'),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 12,
                                      child: Text(
                                        '3', // Replace this with the actual number of messages
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: GestureDetector(
                            onTap: () {
                              // Replace the following line with the navigation logic you want
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => outfordeliver(totalCards: (data) {
                                  setState(() {
                                    totalcard = data;
                                  });
                                })),
                              );
                            },
                            child: Card(
                              child:  Stack(
                                children: [
                                  ListTile(
                                    title: Text('Out For Delivery'),

                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 12,
                                      child: Text(
                                        '3', // Replace this with the actual number of messages
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: GestureDetector(
                            onTap: () {
                              // Replace the following line with the navigation logic you want
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => delivered(totalCards: (data) {
                                  setState(() {
                                    totalcard = data;
                                  });
                                })),
                              );
                            },
                            child: Card(
                              child:  Stack(
                                children: [
                                  ListTile(
                                    title: Text('Delivered'),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 12,
                                      child: Text(
                                        '3', // Replace this with the actual number of messages
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OrderPlaced extends StatefulWidget {
  final Function(int) totalCards;

  OrderPlaced({required this.totalCards});

  @override
  State<OrderPlaced> createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  List<Widget> cards = []; // List to hold the cards
  int totalCards = 0;

  // Constructor that accepts a parameter

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          'Customers Order',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
            child:  StreamBuilder(
              stream: FirebaseFirestore.instance.collection('userorder').doc('NewOrder').snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return Center(
                    child: Text('No Order Yet'),
                  );
                }

                Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

                // Retrieve multiple fields from the document
                String field1 = data['field1'] ?? 'Field 1 not found';
                String field2 = data['field2'] ?? 'Field 2 not found';
                // Add more fields as needed

                return SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Card(
                    child: ListTile(
                      title: Text('Field 1: $field1'),
                    ),
                  ),
                );

              },
            )
        ),
      ),
    );
  }

// void _addCard() {
//   setState(() {
//     int cardNumber = cards.length + 1;
//     cards.add(
//
//
//
//     totalCards++;
//     widget.totalCards(totalCards);
//   });
// }
}

class packed extends StatefulWidget {
  final Function(int) totalCards;


  packed({required this.totalCards});

  @override
  State<packed> createState() => _packedState();
}

class _packedState extends State<packed> {
  List<Widget> cards = []; // List to hold the cards
  int totalCards = 0;

  // Constructor that accepts a parameter


  @override
  void initState() {
    super.initState();

    // Initialize with an empty list of cards
    cards = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          'Packing ',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: cards,
              ),
              ElevatedButton(
                onPressed: () {
                  _addCard();
                },
                child: Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCard() {
    setState(() {
      int cardNumber = cards.length + 1;
      cards.add(
        Card(
          child: ListTile(
            title: Text("Card $cardNumber"),
          ),
        ),
      );
      totalCards++;
      widget.totalCards(totalCards);
    });
  }
}

class outfordeliver extends StatefulWidget {
  final Function(int) totalCards;


  outfordeliver({required this.totalCards});

  @override
  State<outfordeliver> createState() => _outfordeliverState();
}

class _outfordeliverState extends State<outfordeliver> {
  List<Widget> cards = []; // List to hold the cards
  int totalCards = 0;

  // Constructor that accepts a parameter


  @override
  void initState() {
    super.initState();

    // Initialize with an empty list of cards
    cards = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          'Out for Delivery',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: cards,
              ),
              ElevatedButton(
                onPressed: () {
                  _addCard();
                },
                child: Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCard() {
    setState(() {
      int cardNumber = cards.length + 1;
      cards.add(
        Card(
          child: ListTile(
            title: Text("Card $cardNumber"),
          ),
        ),
      );
      totalCards++;
      widget.totalCards(totalCards);
    });
  }
}

class delivered extends StatefulWidget {
  final Function(int) totalCards;


  delivered({required this.totalCards});

  @override
  State<delivered> createState() => _deliveredState();
}

class _deliveredState extends State<delivered> {
  List<Widget> cards = []; // List to hold the cards
  int totalCards = 0;

  // Constructor that accepts a parameter


  @override
  void initState() {
    super.initState();

    // Initialize with an empty list of cards
    cards = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
        title: Text(
          'Delivered',
          style: TextStyle(color: Colors.black, fontSize: 30),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: cards,
              ),
              ElevatedButton(
                onPressed: () {
                  _addCard();
                },
                child: Text('Add Card'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCard() {
    setState(() {
      int cardNumber = cards.length + 1;
      cards.add(
        Card(
          child: ListTile(
            title: Text("Card $cardNumber"),
          ),
        ),
      );
      totalCards++;
      widget.totalCards(totalCards);
    });
  }
}