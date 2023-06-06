import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/adminscreen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/reset_password.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/reusable.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
   List<dynamic> adminlist=[];
  List<String> pointlist = [];
  List<dynamic> alldata =[];
  String childid='';
  int flag=0;
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * 0.2, 20, 0),
            child: Column(
              children: <Widget>[
                Text('Welcome to e-form'),
                const SizedBox(
                  height: 30,
                ),
                reusableTextField("Enter Email", Icons.person_outline, false,
                    _emailTextController),
                const SizedBox(
                  height: 20,
                ),
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
                const SizedBox(
                  height: 5,
                ),
                
                forgetPassword(context),
                firebaseUIButton(context, "Sign In", () {
                  FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                          email: _emailTextController.text,
                          password: _passwordTextController.text)
                      .then((value) {
                        getdata();
                        
                  });
                  // .onError((error, stackTrace) {
                  //   print("Error ${error.toString()}");
                  // });
                }),
                signUpOption()
              ],
            ),
          ),
        ),
      ),
    );
}
Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
            style: TextStyle(color: Colors.black)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
Widget forgetPassword(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 35,
      alignment: Alignment.bottomRight,
      child: TextButton(
        child: const Text(
          "Forgot Password?",
          style: TextStyle(color: Colors.white70),
          textAlign: TextAlign.right,
        ),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => ResetPassword())),
      ),
    );
  }

  Future<List> getdata() async{
    print('inside func');
    FirebaseFirestore.instance.collection('admins').get().then((QuerySnapshot? querySnapshot){
      querySnapshot!.docs.forEach((doc) {
        
        print('just before print');
        print(doc['admin']);
        alldata=doc['admin']; 
        adminlist=List.from(doc['admin']).toList();
        print('after func print');
        if(adminlist.contains(_emailTextController.text.toString()))
        {
          flag=1;
          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AdminPage()));
        }else{
        FirebaseFirestore.instance.collection('users').get().then((QuerySnapshot? snapshot) {
          snapshot!.docs.forEach((document) { 
            if(document['email'].toString()==_emailTextController.text.toString()){
                              childid=document['childid'].toString();
                              print('printing childid');
                      print(childid.toString());

                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen(childid.toString())));
                            }
          });
        },);}
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

