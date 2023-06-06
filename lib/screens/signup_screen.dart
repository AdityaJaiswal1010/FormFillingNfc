import 'dart:async';



import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/reusable.dart';
import 'adminscreen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>{
  List<dynamic> adminlist=[];
  List<String> pointlist = [];
  List<dynamic> alldata =[];
  String childid='';
  int flag=0;
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('admins').doc('N0Pqwmzts6iDGAckpKMs').collection('admin').snapshots(),
        builder: (context , AsyncSnapshot<QuerySnapshot> snapshot) {
          return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              
              child: SingleChildScrollView(
                  child: Padding(
                padding: EdgeInsets.fromLTRB(20, 120, 20, 0),
                child: Column(
                  children: <Widget>[
                    
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter UserName", Icons.person_outline, false,
                        _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter Email Id", Icons.person_outline, false,
                        _emailTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField("Enter password number", Icons.lock_outlined, true,
                        _passwordTextController),
                    const SizedBox(
                      height: 20,
                    ),
                  
                  
                         firebaseUIButton(context, "Sign Up", () async {
                          List<String> presentEmail=await FirebaseAuth.instance.fetchSignInMethodsForEmail(_emailTextController.text);
                          // if(presentEmail.length>=0)
                          // {
                          //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email Already exist'),));
                          //   return;

                          // }
                        
                      FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: _emailTextController.text,
                              password: _passwordTextController.text)
                          .then((value) {
                             
                          // var uid = Uuid();
                          // String id = uid.v4().split("-").join("");
                          FirebaseFirestore.instance.collection('forms').add({
                          //  'id': id.toString(),                 
                          'name': _userNameTextController.text.trim().toString(),
                          'email': _emailTextController.text.trim().toString(),
                          'subjects':{},
                          'pdflink':'', 
                        })
                       .then((DocumentReference doc){
                        var newusersdoc=FirebaseFirestore.instance.collection('users').doc();
                        var newusersdocid=newusersdoc.id;
                        print(newusersdocid.toString());    // store this id of user in nfc card
                        childid=doc.id.toString();
                        newusersdoc.set({
                          'name': _userNameTextController.text.trim().toString(),
                          'email': _emailTextController.text.trim().toString(),
                          'childid': doc.id.toString(),
                        });
                       });
                       
                        // String userid;
                        // FirebaseFirestore.instance.collection('users').add({
                          
                        //   'name': _userNameTextController.text.trim().toString(),
                        //   'email': _emailTextController.text.trim().toString(),
                        //   'childid': id.toString(),
                        // }).then((DocumentReference doc){
                        //   setState(() {
                        //     userid=doc.id;
                        //     print(doc.id);
                        //   });
                        // });
                       
                      


                        print("Created New Account");
                        print(_emailTextController.text.toString());
                            print('befor getdata');
                            // getdata();
                            print('after getdata');
                            print(adminlist);
                            // var adminaccess=snapshot.data;
                            // if(snapshot.hasData){
                            //   List<String> e = [];
                            //       adminaccess!.forEach((i) {
                            //         e.add(i.toString());
                            //       });
                            // }
                            
                            // List<String> adminaccessmail= snapshot.data!.docs.map((document){
                            //   document['admin'];
                            // }).cast<String>().toList();
            //                 print("--------------------------------------");
            //                 print('printing admin list');
            //                 List<String> admins=[];
            //                 FirebaseFirestore.instance.collection('N0Pqwmzts6iDGAckpKMs').get().then((value) {
            //   value.docs.forEach((element) { 
            //     admins.add(element.toString());
            //     if(element.toString()==_emailTextController.toString())
            //     flag=1;
            //     print(admins[0]);
            //   });
            // }
            // );
            // print('end of admin list');
            //                 print(pointlist);
                            // print(adminaccessmail.length);
                        // List<Offset> admins=<Offset>[];
                        // var admin=FirebaseFirestore.instance.collection('admins').doc('N0Pqwmzts6iDGAckpKMs').collection('email').get();
                        // print(admin);
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created, Please log in'),));return null;
                      //   if(adminlist.contains(_emailTextController.text.toString())) {
                      //     flag=1;
                      //   }
                      // if(alldata.contains(_emailTextController.text)) {
                      //   flag=1;
                      // }
                      //   if(flag>=1){
                
                      //       Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => AdminPage())).onError((error, stackTrace) {
                      //   print("Error ${error.toString()}");
                      // });}
                      //   Navigator.push(context,
                      //       MaterialPageRoute(builder: (context) => HomeScreen(childid)));
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    })
                      
                ],),)));
        }
      ));
  } 
  
    Future<List> getdata() async{
    print('inside func');
    FirebaseFirestore.instance.collection('admins').get().then((QuerySnapshot? querySnapshot){
      querySnapshot!.docs.forEach((doc) {
        pointlist.add(doc['admin'].toString());
        print('just before print');
        print(doc['admin']);
        alldata=doc['admin']; 
        adminlist=List.from(doc['admin']).toList();
        print('after func print');
        if(adminlist.contains(_emailTextController.text.toString()))
        {
          flag=1;
          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AdminPage())).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
        }
        print('flag');
        print(flag);
        print(adminlist);
        print(doc['admin'][0].toString());
        
        
      
          
      });
  }
);
//   await FirebaseFirestore.instance.collection("admins").doc('N0Pqwmzts6iDGAckpKMs').get().then((value){
// setState(() {

// List<Offset> pointlist = List.from(value.data()['admin']);
// if(pointlist.contains(_emailTextController.text)){
//   flag=1;
// }

// });
//    });
return alldata;
  }
}
