import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;



class AddCafeState extends StatefulWidget {
  @override
  _AddCafeState createState() => _AddCafeState();
}

class _AddCafeState extends State<AddCafeState> {

PickedFile pickedfile;
final myImageController = TextEditingController();
final myPdfController=TextEditingController();
final cafeNameController = TextEditingController();
  final cafeAdressController = TextEditingController();
 final safeIdController = TextEditingController();
 final openClockController = TextEditingController();
 final closeClockController = TextEditingController();
 final descriptionController = TextEditingController();
 final phoneNumberController = TextEditingController();
_getFromGallery() async {
  pickedfile = await ImagePicker().getImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 1800,
  );
  if (pickedfile != null) {
    File imageFile = File(pickedfile.path);
    myImageController.text = imageFile.toString();
  }
}

  CollectionReference cafes= FirebaseFirestore.instance.collection('cafe');

File file;
String randomName(){
   var rng = new Random();
     String randomName="";
  for (var i = 0; i < 20; i++) {
    print(rng.nextInt(100));
    randomName += rng.nextInt(100).toString();
  }
  return randomName;
}
void _getDocuments() async {
  
 
   FilePickerResult result = await FilePicker.platform.pickFiles();
file=File(result.paths.first);
  
  String fileName = '${randomName()}.pdf';
  print(fileName);
  myPdfController.text=fileName;
  }
void addCafe() async{
    File _imageFile=File(pickedfile.path);
    String fileName = randomName()+"."+_imageFile.path.split('.').last;
    String pdfName = randomName()+".pdf";

    firebase_storage.Reference firebaseStorageRef =
        firebase_storage.FirebaseStorage.instance.ref().child('cafeImages/$fileName');

    firebase_storage.UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

        firebase_storage.Reference firebaseStorageRef1 =
        firebase_storage.FirebaseStorage.instance.ref().child('cafeMenuPdf/$pdfName');
    firebase_storage.UploadTask uploadtask1=firebaseStorageRef1.putFile(file);
    firebase_storage.TaskSnapshot taskSnapshot1 = await uploadtask1;

    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );
 taskSnapshot1.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
        );

        cafes.add({
                                'name': cafeNameController.text,
                                'cafeAddress': cafeAdressController.text,
                                'safeId': safeIdController.text,
                                'openClock': openClockController.text,
                                'closeClock': closeClockController.text,
                                'description': descriptionController.text,
                                'phoneNumber': phoneNumberController.text,
                                'menu': pdfName,
                                'picture': fileName,
                                
                              }).then((value) => print("cafe added"));

}
 
 @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFECEEF5),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 38),
                  padding: EdgeInsets.only(top: 38),
                  alignment: Alignment.topCenter,
                  child: Text('Kafe Ekle',
                      style: GoogleFonts.roboto(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 37, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: cafeNameController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Kafenin Adı",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: cafeAdressController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Kafenin Adresi",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: safeIdController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Kasa Id",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: openClockController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Açılış Saati",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: closeClockController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Kapanış Saati",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: descriptionController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Açıklama",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    padding: EdgeInsets.only(left: 16),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(
                            readOnly: true,
                            controller: myPdfController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Menü(Pdf)",
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 18.75)),
                          ),
                        ),
                        
                           Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.9 - 216,
                          alignment: Alignment.centerRight,
                          child: RawMaterialButton(
                            child: Icon(
                              Icons.picture_as_pdf,
                            ),
                            elevation: 8,
                            onPressed: () async {
 
_getDocuments(); 

                            },
                          ),
                        )
                      ],
                    )),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(left: 16),
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  child: TextField(
                    controller: phoneNumberController,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Telefon Numarası",
                        hintStyle: TextStyle(
                            color: Colors.grey[400], fontSize: 18.75)),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 5, bottom: 5),
                    padding: EdgeInsets.only(left: 16),
                    height: 40,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(12))),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 200,
                          child: TextField(
                            readOnly: true,
                            controller: myImageController,
                            textAlign: TextAlign.left,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Kafe Fotoğrafı",
                                hintStyle: TextStyle(
                                    color: Colors.grey[400], fontSize: 18.75)),
                          ),
                        ),
                       Container(
                          height: 40,
                          width: MediaQuery.of(context).size.width * 0.9 - 216,
                          alignment: Alignment.centerRight,
                          child: RawMaterialButton(
                            child: Icon(
                              Icons.photo_library,
                            ),
                            elevation: 8,
                            onPressed: () {
                              _getFromGallery();
                            },
                          ),
                        ),
                      ],
                    )),
                      GestureDetector(
                            onTap: () async {
                            addCafe();
  } ,
                            child:
                Container(
                  margin: EdgeInsets.only(top: 50),
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.9,
                  alignment: Alignment.bottomCenter,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(240, 118, 24, 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      "Kafe Ekle",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),)
              ],
            ),
          ),
        ));
  }
}