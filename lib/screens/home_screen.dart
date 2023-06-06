import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../storage_services/storageService.dart';
import '../widgets/constants.dart';
import '../widgets/enable.dart';
import '../widgets/reusable.dart';



class HomeScreen extends StatefulWidget {
  final String child;
  HomeScreen(this.child,  {Key? key}) : super(key: key);
  
  @override
  
  _HomeScreenState createState() => _HomeScreenState();
}
class MultiSelect extends StatefulWidget {
  final List<String> items;
  
  const MultiSelect({Key? key,required this.items}) : super(key: key);

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  
  final List<String> _selecteditems=[];

  void _itemChange(String itemValue,bool isSelected){
    setState(() {
      if(isSelected){
        _selecteditems.add(itemValue);
      }else{
        _selecteditems.remove(itemValue);
      }
    });
  }

  void _cancel(){
    Navigator.pop(context);
  }

  void _submit(){
    Navigator.pop(context,_selecteditems);
  }
 @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Topics'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.items
              .map((item) => CheckboxListTile(
                    value: _selecteditems.contains(item),
                    title: Text(item),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (isChecked) => _itemChange(item, isChecked!),
                  ))
              .toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _cancel,
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Submit'),
        ),
      ],
    );
  }
}
class _HomeScreenState extends State<HomeScreen> {
  // late final path1;
  // late final path2;
  // late final fileName1;
  // late final fileName2;
  PlatformFile? pickedPhoto;
  PlatformFile? pickedPdf;
  List<String> _selectedSubject=[];
    TextEditingController _nameTextController = TextEditingController();
  TextEditingController _divisionTextController = TextEditingController();
  TextEditingController _rollNoTextController = TextEditingController();
  TextEditingController _semTextController = TextEditingController();
    TextEditingController _typeTextController = TextEditingController();

  
  @override
  

  Widget build(BuildContext context) {
    final Storage storage = Storage();
    
            // List<String> admins=[];
            // FirebaseFirestore.instance.collection('N0Pqwmzts6iDGAckpKMs').get().then((value) {
            //   value.docs.forEach((element) { 
            //     admins.add(element.toString());
            //     print(admins[0]);
            //   });
            // }
            // );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            const Text(
              "Form",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              
            ),
            
    
          ],
        ),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(colors: [
          //   hexStringToColor("b74093"),
          // hexStringToColor("3399FF"),
          // hexStringToColor("5E61F4")
          // ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
            child: Column(
              children: <Widget>[
                
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter UserName", Icons.person_outline, false,
                    _nameTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Roll No", Icons.person_outline, false,
                    _rollNoTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Division", Icons.person_outline, false,
                    _divisionTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Sem", Icons.lock_outlined, false,
                    _semTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Exam Type? (kt or reg)", Icons.lock_outlined, false,
                    _typeTextController),
                const SizedBox(
                  height: 20,
                ),
                (_typeTextController.text.toString().toLowerCase()=='reg')?
                Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: [
                  ElevatedButton(
                  onPressed: 
                  _showMultiSelect,child: Text('Select Subject'),),
                  const Divider(
              height: 30,
            ),
            // display selected items
            Wrap(
              children: _selectedSubject
                  .map((e) => Chip(
                        label: Text(e),
                      ))
                  .toList(),
            )
                ],):Column(children: [],),
                
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () async{
                      final results = await FilePicker.platform.pickFiles(
                      );
                      if (results==null){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file selected'),));return null;
                      }
                      setState(() {
                        pickedPhoto=results.files.first;
                        debugPrint("picked----->"+pickedPhoto.toString());
                      });
                      // path1 = results.files.single.path;
                      // fileName1 = results.files.single.name;
                      //  storage.uploadfiles(path1, fileName1).then((value) => print('Done'));

                    }, child: Text('Select Photo'),),
                    // upload pdf
                    ElevatedButton(
                      onPressed: () async{
                      final results = await FilePicker.platform.pickFiles(
                      );
                      if (results==null){
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file selected'),));return null;
                      }
                      setState(() {
                        pickedPdf=results.files.first;
                        debugPrint("picked----->"+pickedPdf.toString());
                      });
                      final pathpdf ='files/${_nameTextController.text}/HallTicket';
                    final filepdf = File(pickedPdf!.path!);
                    

                    final ref = FirebaseStorage.instance.ref().child(pathpdf);
                    UploadTask uploadedTask =ref.putFile(filepdf);
                    final snapshot=await uploadedTask.whenComplete(() {});
                    final urlDownload = await snapshot.ref.getDownloadURL();
                    print('Download url : ${urlDownload}');  // store thia link to nfc
                    
                    //add pdf link to the loggedin persons form collection and create tile in the map for subject
                    (_typeTextController.text.toString().toLowerCase()=='reg')?
                    FirebaseFirestore.instance.collection('forms').doc(this.widget.child).update({
                      'pdflink': urlDownload,
                      'subjects': {_semTextController.text.toString(): _selectedSubject}
                    }):FirebaseFirestore.instance.collection('forms').doc(this.widget.child).update({
                      'pdflink': urlDownload,
                      // 'subjects': {_semTextController.text.toString(): _selectedSubject}
                    });
                    // FirebaseFirestore.instance.collection(collectionPath)
                      // path1 = results.files.single.path;
                      // fileName1 = results.files.single.name;
                      //  storage.uploadfiles(path1, fileName1).then((value) => print('Done'));

                    }, child: Text('Select Hallticket'),),
                    // if(pickedPhoto!=null)
                    //   Expanded(
                    //     child: Container(
                    //       color: Colors.blue[100],
                    //       child: Center(
                    //         child: Image.file(
                    //           File(pickedPhoto!.path!),
                    //           width: double.infinity,
                    //           fit: BoxFit.cover,
                    //         ),
                    //       ),
                    //     ),
                    //   )
                    // ElevatedButton(onPressed: () async{
                    //   final results = await FilePicker.platform.pickFiles(
                    //     allowMultiple: false,
                    //     type: FileType.custom,
                    //     allowedExtensions: ['png','jpg'],
                    //   );
                    //   if (results==null){
                    //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No file selected'),));return null;
                    //   }
                      
                    //   path2 = results.files.single.path!;
                    //   fileName2 = results.files.single.name;
                      
                    // }, child: Text('Upload Signature'),),
                  ],
                ),

                ElevatedButton(
                  onPressed: 
                  _createpdf,child: Text('Submit'),),

                // firebaseUIButton(context, "Submit Details", () {
                // //  FirebaseFirestore.instance.collection('usersData').add(name:)
                //   // storage.uploadfiles(path2, fileName2).then((value) => print('Done'));
                //   // FirebaseAuth.instance
                //   //     .createUserWithEmailAndPassword(
                //   //         email: _emailTextController.text,
                //   //         password: _passwordTextController.text)
                //   //     .then((value) {
                //   //   print("Created New Account");
                //   //   Navigator.push(context,
                //   //       MaterialPageRoute(builder: (context) => HomeScreen()));
                //   // }).onError((error, stackTrace) {
                //   //   print("Error ${error.toString()}");
                //   // });
                //   // FirebaseFirestore.instance.collection('forms').add({name:_nameTextController,div: _divisionTextController});
                // }
                // )
              ],
            ),
          ))),
    );
  }
  Future<void> _createpdf() async{
    if(pickedPhoto?.name!=null){
    final path ='files/${_nameTextController.text}/${pickedPhoto!.name}';
                    final file = File(pickedPhoto!.path!);

                    final ref = FirebaseStorage.instance.ref().child(path);
                    ref.putFile(file);
    }
    PdfDocument document = PdfDocument();
    UploadTask? uploadTask;
    final page = document.pages.add();

  page.graphics.drawString('HallTicket No: Sem'+_semTextController.text+_nameTextController.text,
        PdfStandardFont(PdfFontFamily.helvetica, 30));
  // final path ='files/${pickedPhoto.!name}';
  // final file = File(pickedPhoto!.path!);

  // final ref = FirebaseStorage.instance.ref().child(path);
  // ref.putFile(file);

  // final snapshot = await uploadTask!.whenComplete(() {});
  // final urlDownload = await snapshot.ref.getDownloadURL();

    // page.graphics.drawImage(
    //     PdfBitmap(await _readImageData(urlDownload.toString())),
    //     Rect.fromLTWH(0, 100, 440, 550));

    PdfGrid grid = PdfGrid();
    grid.style = PdfGridStyle(
        font: PdfStandardFont(PdfFontFamily.helvetica, 30),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    grid.columns.add(count: 5);
    grid.headers.add(1);

    PdfGridRow header = grid.headers[0];
    header.cells[0].value = 'Name';
    header.cells[1].value = 'Roll No';
    header.cells[2].value = 'Division';
    header.cells[3].value='Sem';
    header.cells[4].value='Subjects';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value = _nameTextController.text;
    row.cells[1].value = _rollNoTextController.text;
    row.cells[2].value = _divisionTextController.text;
    row.cells[3].value=_semTextController.text;
    String selectedSubjectString='';
    _selectedSubject.forEach((element) {
      selectedSubjectString+=element+'\n';
    });
    row.cells[4].value=selectedSubjectString;

    // row = grid.rows.add();
    // row.cells[0].value = '2';
    // row.cells[1].value = 'John';
    // row.cells[2].value = '9';

    // row = grid.rows.add();
    // row.cells[0].value = '3';
    // row.cells[1].value = 'Tony';
    // row.cells[2].value = '8';

    grid.draw(
        page: document.pages.add(), bounds: const Rect.fromLTWH(0, 0, 0, 0));

    List<int> bytes=await document.save();
    
    document.dispose();
    saveAndLaunchFile(bytes,_nameTextController.text+'Hallticket.pdf');
  }
  void _showMultiSelect() async{
    final List<String>? results = await showDialog(context: context,
     builder: (BuildContext context){
      String actual_sem="";
      if(_semTextController.text=='1')
        return MultiSelect(items: sem1);
      else if(_semTextController.text=='2')
        return MultiSelect(items: sem2);
      else if(_semTextController.text=='3')
        return MultiSelect(items: sem3);
      else if(_semTextController.text=='4')
        return MultiSelect(items: sem4);
      else if(_semTextController.text=='5')
        return MultiSelect(items: sem5);
      else if(_semTextController.text=='6')
        return MultiSelect(items: sem6);
      else if(_semTextController.text=='7')
        return MultiSelect(items: sem7);
      else 
        return MultiSelect(items: sem8);
      //   FirebaseFirestore.instance.collection("subjects").doc('5i8qfOWJLxWsWoa8Jxhu').collection('subject').get().then((querySnapshot){
      //     querySnapshot.documents.forEach((element){
      //   List value = element.data[actual_sem];
      //   FirebaseFirestore.instance.collection("items").document(value[0]).get().then((value){
      //     print(value.data);
      //   });
      // });
      //   });
      
      
     },
     );

     if(results!=null){
      setState(() {
        _selectedSubject=results;
      });
     }
  }
  
}
Future<Uint8List> _readImageData(String url) async {
  final data = await rootBundle.load(url);
  
  return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
}


