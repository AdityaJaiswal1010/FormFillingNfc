

import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/reusable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../storage_services/storageService.dart';
import '../widgets/constants.dart';
import '../widgets/enable.dart';
import '../widgets/reusable.dart';

import 'package:firebase_storage/firebase_storage.dart';
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var snapshot;
  List<String> t=[];
  int a=0;
  String childid='';
  String nameFromDb='';
  String emailFromDb='';
  List<dynamic> subjectsFromDb=[];
  List<String> prevResult=[];
  PlatformFile? pickedPdf;
  int index=0;
  List <String> headers=[];
  List<String> result = [];
  TextEditingController _temp = TextEditingController();
  TextEditingController _temp1 = TextEditingController();
  TextEditingController _temp2 = TextEditingController();
  TextEditingController _temp3 = TextEditingController();
  TextEditingController _temp4 = TextEditingController();
  TextEditingController _temp5 = TextEditingController();
  TextEditingController _temp6 = TextEditingController();
        TextEditingController _adminEnteredSemTextController = TextEditingController();
        
      TextEditingController _adminEnteredEmailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            const Text(
              "Admin Pannel",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              
            ),
            
    
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          child: Container(
            child: Column(
              
              children: <Widget>[
                const SizedBox(
                      height: 50,
                    ),
                    reusableTextField("Enter email", Icons.person_outline, false,
                        _adminEnteredEmailTextController),
                        const SizedBox(
                    height: 15,
                  ),
                     reusableTextField("Enter sem", Icons.person_outline, false,
                        _adminEnteredSemTextController),
                        const SizedBox(
                    height: 15,
                  ),
                      ElevatedButton.icon(onPressed:() {
                        snapshot=FirebaseFirestore.instance.collection('users').get().then((value){
                          _fetchData();
                        }
                          
                        );
                          
                        
                        
                          
                      }, icon: Icon(Icons.search), label: Text('Admin entered email')),
                      Column(children: [
                        
                          Text("name : {$nameFromDb}"),
                          Text("email : {$emailFromDb}"),
                          Text("subjects : {$subjectsFromDb}")
                        
                      ],),
                      // reusableTextField("Enter Marks as per above subject and for no marks add N and seperate every score by,", Icons.person_outline, false,
                      // _temp),
                      
                      
                      Text('${result}'),
                      (subjectsFromDb.length==6)?
                      Column(
                        children: [
                          TextField(
                controller: _temp1,
                decoration: InputDecoration(
                  labelText: 'Enter the Value of ${subjectsFromDb[0]}',
                  
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
                
              ),
              
               TextField(
                controller: _temp2,
                decoration: InputDecoration(
                  labelText: 'Enter the Value of ${subjectsFromDb[1]}',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp3,
                decoration: InputDecoration(
                  labelText: 'Enter the Value of ${subjectsFromDb[2]}',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp4,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp5,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp6,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
                        ],
                        
                      ):Column(
                        children: [
                          TextField(
                controller: _temp1,
                decoration: InputDecoration(
                  labelText: 'Enter the Value of ',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp2,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp3,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp4,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
               TextField(
                controller: _temp5,
                decoration: InputDecoration(
                  labelText: 'Enter the Value',
                  // errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
              ),
                        ],
                      ),
                      
                      ElevatedButton.icon(onPressed:() {
                        (subjectsFromDb.length==6)?
                        {
                          putval(6),
                           snapshot=FirebaseFirestore.instance.collection('users').get().then((value){
                          _getPrevResult();
                          result=[];
                          // result.add(prevResult[i]);
                        }),
                        print(prevResult),
                          for(int i=0;i<6;i++){
                            if(t[i].toString()=='NA')
                          {
                            
                          result.add(prevResult[i])
                        
                          }
                          else  
                          {
                            if(i==0)
                            result.add(_temp1.text.toString())
                            else if(i==1)
                            result.add(_temp2.text.toString())
                            else if(i==2)
                            result.add(_temp3.text.toString())
                            else if(i==3)
                            result.add(_temp4.text.toString())
                            else if(i==4)
                            result.add(_temp5.text.toString())
                            else 
                            result.add(_temp6.text.toString())
      
                          }
                          
                          }
                          
                        }:{
                          snapshot=FirebaseFirestore.instance.collection('users').get().then((value){
                          _getPrevResult();
                          result=[];
                          // result.add(prevResult[i]);
                        }
                          
                        ),
                          putval(5),
                          print(prevResult),
                          for(int i=0;i<5;i++){
                            if(t[i].toString()=='NA')
                          {
                            
                          result.add(prevResult[i])
                        
                          }
                          else  
                          {
                            if(i==0)
                            result.add(_temp1.text.toString())
                            else if(i==1)
                            result.add(_temp2.text.toString())
                            else if(i==2)
                            result.add(_temp3.text.toString())
                            else if(i==3)
                            result.add(_temp4.text.toString())
                          
                            else 
                            result.add(_temp5.text.toString())
      
                          }
                          }
                        };
                        //put results to map
                        FirebaseFirestore.instance.collection('forms').doc(childid).update({
                          'results.${_adminEnteredSemTextController.text.toString()}': result,
                        });
                        
                        // assignVal(_temp.text.toString());
                        // print(result);
                        
                        
                      }, icon: Icon(Icons.search), label: Text('data')),
                      Text('${result}'),
                      ElevatedButton(
                  onPressed: 
                  _createpdf,child: Text('Submit'),),
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
                      final pathpdf ='files/${nameFromDb.toString()}/Marsheet Sem ${_adminEnteredSemTextController.text.toString()}';
                    final filepdf = File(pickedPdf!.path!);
                    

                    final ref = FirebaseStorage.instance.ref().child(pathpdf);
                    UploadTask uploadedTask =ref.putFile(filepdf);
                    final snapshot=await uploadedTask.whenComplete(() {});
                    final urlDownload = await snapshot.ref.getDownloadURL();
                    print('Download url : ${urlDownload}');  // store thia link to nfc
                    
                    //add pdf link to the loggedin persons form collection and create tile in the map for subject  

                    FirebaseFirestore.instance.collection('forms').doc(childid).update(
                      {
                        'marksheet.${_adminEnteredSemTextController.text.toString()}': urlDownload
                      }
                    );

                    // (_typeTextController.text.toString().toLowerCase()=='reg')?{
                    // FirebaseFirestore.instance.collection('forms').doc(this.widget.child).update({
                    //   'pdflink': urlDownload,
                    //   // 'subjects': {_semTextController.text.toString(): _selectedSubject}
                    // }),
                    
                    
                    // }:FirebaseFirestore.instance.collection('forms').doc(this.widget.child).update({
                    //   'pdflink': urlDownload,
                    //   // 'subjects': {_semTextController.text.toString(): _selectedSubject}
                    // });
                    // Map<String, List> mapData={
                    //   _semTextController.text.toString(): _selectedSubject.toList()
                    // };
                    // var semi=int.parse(_semTextController.text.toString());
                    // assert(semi is int);
                    // (_typeTextController.text.toString().toLowerCase()=='reg')?
                    //     FirebaseFirestore.instance.collection('forms').doc(this.widget.child).update({
                    //       'subjects.${_semTextController.text.toString()}': _selectedSubject
                    // }):null;
                    // FirebaseFirestore.instance.collection(collectionPath)
                      // path1 = results.files.single.path;
                      // fileName1 = results.files.single.name;
                      //  storage.uploadfiles(path1, fileName1).then((value) => print('Done'));

                    }, child: Text('Select Hallticket'),),
                    ElevatedButton(onPressed: exportData, child: Text('Export data')),
              ],
              
            ),
            
          ),
          
        ),
      ),
    );

  }
   Future<void> _createpdf() async{
   
    // final path ='files/${nameFromDb.toString()}/Marksheet${ _adminEnteredSemTextController.text.toString()}';
                    // final file = File(pickedPhoto!.path!);

                    // final ref = FirebaseStorage.instance.ref().child(path);
                    // ref.putFile(file);
    
    PdfDocument document = PdfDocument();
    // UploadTask? uploadTask;
    final page = document.pages.add();

  page.graphics.drawString('Marksheet No: Sem'+_adminEnteredSemTextController.text+nameFromDb.toString(),
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
    header.cells[1].value = 'email';
    header.cells[2].value = 'Marks';
    header.cells[3].value='Sem';
    header.cells[4].value='Subjects';

    PdfGridRow row = grid.rows.add();
    row.cells[0].value =nameFromDb.toString();
    row.cells[1].value = _adminEnteredEmailTextController.text.toString();
    String allmarks='';
    for(int i=0;i<result.length;i++){
      allmarks+=result[i].toString()+'\n';
    };
    List<dynamic> rdata=result;
     //now when we call prev result all the recent result will be fetched as it is replaces
     _getPrevResult();
    row.cells[2].value = prevResult;
    row.cells[3].value=_adminEnteredSemTextController.text.toString();
    row.cells[4].value=subjectsFromDb.toString();

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
    saveAndLaunchFile(bytes,nameFromDb.toString()+'Marksheet sem ${_adminEnteredSemTextController.text.toString()}.pdf');
  }

  void exportData() async{
    final CollectionReference colref=FirebaseFirestore.instance.collection('forms');
    final myData = await rootBundle.loadString('lib/res/marksheet.csv'); 

    List<List<dynamic>> csvTable=CsvToListConverter().convert(myData);

    List<List<dynamic>> data=[];

    data=csvTable;
    for(var i=0;i<data[0].length;i++)
    {
      setState(() {
        headers.add(data[0][i]);
      });
    }
    print(headers);
    // for(var i=1;i<data.length;i++){
    //   FirebaseFirestore.instance.collection('forms').add({
    //     'name': data[i][0],
    //     'email': data[i][1],

    //   });
    // }
    int flag=1;
    
    for(var i=1;i<data.length;i++)
    {
      setState(() {
        flag=1;
      });
      // var docId=FirebaseFirestore.instance.collection('forms').doc();
      // var docIdForUsers=FirebaseFirestore.instance.collection('users').doc();
    
        FirebaseFirestore.instance.collection('forms').add({
          for(var k=0;k<data[i].length;k++)
          
                          headers[k]: data[i][k],
                        }).then((DocumentReference docId){
                         
                      FirebaseFirestore.instance.collection('users').add({
                        headers[0]: data[i][0],
                        'childid': docId.id.toString(),
                        headers[1]: data[i][1],
                        headers[2]: data[i][2],
                        headers[3]: data[i][3],
                        headers[4]: data[i][4],
                        headers[5]: data[i][5],
                        // headers[6]: data[i][6],
                        
                      });
                      setState(() {
                        flag=0;
                      });
                     
                        });
    }
  }
  Future<void> _fetchData() async{
    FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot? querySnapshot){
      querySnapshot!.docs.forEach((document){
                          if(document['email'].toString()==_adminEnteredEmailTextController.text.toString()){
                            setState(() {
                              childid=document['childid'].toString();
                            });
                              
                              print(document['childid'].toString());
                              print(childid);
                            FirebaseFirestore.instance.collection('forms').doc('${document['childid'].toString()}').get().then((value) {
                        
                        setState(() {
                          
                          emailFromDb=value['email'].toString();
                        nameFromDb=value['name'].toString();
                        subjectsFromDb=value['subjects.${_adminEnteredSemTextController.text.toString()}'];
                        });
                        print(emailFromDb);
                        print(nameFromDb);
                        // _setData(value['email'].toString());
                        
                        
                        print(subjectsFromDb);
                      });
                            
                          }
                        }
                        );
    });
    
  }
  
  assignVal(String string) {
    String t='';
    for(int i=0;i<string.length;i++){
      if(string[i]==','){
        setState(() {
      result.add(t);
      t='';
    });
      }
      else if(string[i]=='N'){
        //fetch data from prev entry and location of which to fetch is result.length
      }
      else
      t=t+string[i];
    }
    result.add(t);
  }
  
  Future<void> _getPrevResult() async{
    FirebaseFirestore.instance.collection('forms').doc(childid).get().then((value){
      setState(() {
        // int index=value['results.${_adminEnteredEmailTextController.text.toString()}'].length;
        prevResult=value['results.${_adminEnteredEmailTextController.text.toString()}'];
        print("after copy prevresult");
        print(prevResult);
      });
    });
  }
  
  putval(int i) {
    if(i==6){
    setState(() {
      t=[_temp1.text.toString(),_temp2.text.toString(),_temp3.text.toString(),_temp4.text.toString(),_temp5.text.toString(),_temp6.text.toString()];
    });
    }
    else{
      setState(() {
      t=[_temp1.text.toString(),_temp2.text.toString(),_temp3.text.toString(),_temp4.text.toString(),_temp5.text.toString()];
    });
    }
    return;
  }
}