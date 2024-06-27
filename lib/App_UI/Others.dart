import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Others extends StatefulWidget {
  const Others({super.key});

  @override
  State<Others> createState() => _OthersState();
}

class _OthersState extends State<Others> {
  //manitory image
  List<String> imgurl = [] ;
//  List<bool> checboxValues = [];
  List<String> _imagePaths = [];
  int _currentIndexPaths = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Special List"),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.cyan,
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _imagePaths.isNotEmpty
                ? Column(
                  children: [
                    SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.width * 0.5,
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text('Image ${_currentIndexPaths + 1} of ${_imagePaths.length}'),
                    ),
                    SizedBox(height: 30),
                  ],
                )
                : Container(),
            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text("Note: ",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                " \n* image size should be in given scale \n* if other than mentioned size is uploaded then it will should black space in ui",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Transform.scale(
            scale: 0.9,
            child: FloatingActionButton(

              onPressed :(){

                if(_imagePaths.length <= 5){
                  _pickImageFromGallery();
                }
              } ,
              child: Icon(Icons.add_photo_alternate_outlined),
              backgroundColor: (_imagePaths.length <= 5)?Colors.cyan:Colors.grey,
              shape: CircleBorder(),
            ),
          ),
          SizedBox(height: 20,),
          FloatingActionButton(
            onPressed :(){

              // _imagePaths.isNotEmpty ?  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("No error in uploading Image"))): ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in uploading Image")));





              if(_imagePaths.length == 5){
                uploadimage();
                // _imagePaths.isNotEmpty ? uploadimage :ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in uploading Image")));
              }else{
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in uploading Image")));
              }
            } ,
            child: Icon(Icons.upload),
            backgroundColor: (_imagePaths.length == 5)?Colors.cyan:Colors.grey,
            shape: CircleBorder(),
          ),
        ],
      ),

    );
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

  Future<void> uploadimage() async {

    String uniquename = DateTime.now().millisecondsSinceEpoch.toString();


    try {
      for (int i = 0; i < _imagePaths.length; i++) {
        Reference referenceRoot = FirebaseStorage.instance.ref();
        Reference referenceFolder = referenceRoot.child("speciallist");
        Reference referenceDirImages = referenceFolder.child("image_$i");
        Reference referenceImgtoUpload = referenceDirImages.child(uniquename);
        UploadTask uploadTask =  referenceImgtoUpload.putFile(File(_imagePaths[i]));

        await uploadTask.whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All images are Uploaded"))));
        await uploadTask.whenComplete(() => print('Image $i uploaded'));
        String downloadUrl = await referenceImgtoUpload.getDownloadURL();
        imgurl.add(downloadUrl);
        print("---------------------->${imgurl[i]}");
        await FirebaseFirestore.instance.collection('others').doc('special').update({
          'urls': FieldValue.arrayUnion(imgurl),
          // Add other data if needed
        });
      }
    }catch(e){
      print("$e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("error in uploading Image")));
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
          color: Colors.orange.shade100,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.069,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade200, // Change this to the desired color
                    ),
                    onPressed: onDelete,

                    child: Text('Delete Image'),
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

class FullScreenImagesView extends StatelessWidget {
  final String imagePath;
  final VoidCallback onDelete;

  FullScreenImagesView({required this.imagePath, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context); // Close the full-screen view on tap
        },
        child: Container(
          color: Colors.orange.shade100,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.height * 0.069,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange.shade200, // Change this to the desired color
                    ),
                    onPressed: onDelete,

                    child: Text('Delete Image'),
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