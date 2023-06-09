

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/widgets/reusable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var snapshot;
  String childid='';
  String nameFromDb='';
  String emailFromDb='';
  List<dynamic> subjectsFromDb=[];
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
      body: Container(
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
                      
                    ],)
            ],
          ),
          
        ),
        
      ),
    );

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
}