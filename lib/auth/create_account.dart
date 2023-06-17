import 'package:auth_login/auth/home_screeen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({Key? key}) : super(key: key);

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

TextEditingController nameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController pwdController = TextEditingController();
TextEditingController confirmPwdController = TextEditingController();
bool isLoading = false;
class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Account'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'email',
                ),
              ),
              TextFormField(
                controller: pwdController,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextFormField(
                controller: confirmPwdController,
                decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                ),
              ),
              SizedBox(height: 40,),
              GestureDetector(
                onTap: () {
                  if(nameController.text.isEmpty){
                    Fluttertoast.showToast(msg: 'Name Cannot be empty');
                  } else if(emailController.text.isEmpty){
                    Fluttertoast.showToast(msg: 'Email Cannot be empty');
                  }
                  else if(pwdController.text.isEmpty){
                    Fluttertoast.showToast(msg: 'password Cannot be empty');
                  }
                  else if(pwdController.text != confirmPwdController.text){
                    Fluttertoast.showToast(msg: 'password does not match');
                  }else{
                  _signupUser();
                  }

                },
                child: Container(
                  height: 50,
                  width: 200,
                  color: Colors.red,
                  child: const Center(child: Text('Create account')),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  _signupUser() async {
    try {
   loadingTrue();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: emailController.text, password: pwdController.text)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({
          'email': emailController.text,
          'name': nameController.text,
          'password':pwdController.text,
          'uid': FirebaseAuth.instance.currentUser!.uid,
          "joiningDate": DateTime.now().millisecondsSinceEpoch
        });
      }).then((value) async {
        loadingFalse();
        ///Navigate To NEXT SCREEN
     Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      });
    } on FirebaseException catch (e) {
     loadingFalse();
      Fluttertoast.showToast(msg: e.message!);
    }
  }
   void loadingFalse(){
    isLoading = false;
    setState(() {

    });
   }
void loadingTrue(){
    isLoading = true;
    setState(() {});
}
}
