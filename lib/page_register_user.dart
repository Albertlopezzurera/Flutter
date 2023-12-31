import 'package:cook_books_course/class_users.dart';
import 'package:cook_books_course/database_user.dart';
import 'package:flutter/material.dart';


class RegisterPageApp extends StatefulWidget{
  @override
  State<RegisterPageApp> createState() => _RegisterPageAppState();
}

class _RegisterPageAppState extends State<RegisterPageApp> {
  GlobalKey form = GlobalKey<FormState>();
  bool isSwitched = false;
  DBHelperUser dbHelperUser = DBHelperUser();
  late Future<List<User>> listUsername;
  late String user = "";
  late String password = "";
  late String email = "";
  late String age = "";
  late String selectedGender = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Register now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,)
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "User:"),
                  onSaved: (value){
                    user = value!;
                  },
                  validator: (value){
                    if (value!.isEmpty){
                      return "Please, complete this field";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Password:"),
                  onSaved: (value){
                    password = value!;
                  },
                  validator: (value){
                    if (value!.isEmpty){
                      return "Please, complete this field";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Email:"),
                  onSaved: (value){
                    email = value!;
                  },
                  validator: (value){
                    if (value!.isEmpty){
                      return "Please, complete this field";
                    }
                    final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                    if (!emailRegExp.hasMatch(value)){
                      return "Please, write a valid email";
                    }
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Age:"),
                  keyboardType: TextInputType.number,
                  onSaved: (value){
                    age = value!;
                  },
                  validator: (value){
                    if (value!.isEmpty){
                      return "Please, complete this field";
                    }
                    int ageValidator = int.parse(value);
                    if (ageValidator.isNegative){
                      return "Age cannot be negative";
                    }else if (ageValidator>105 || ageValidator==0){
                      return "Please, correct the age";
                    }
                  },
                ),
                SizedBox(height: 5,),
                Text('Gender:', style: TextStyle(fontSize: 18),),
                RadioListTile<String>(
                  title: Text('Male'),
                  value: 'male',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Female'),
                  value: 'female',
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value!;
                    });
                  },
                ),
                Switch(
                    activeColor: Colors.green,
                    value: isSwitched,
                    onChanged: (value){
                      setState(() {
                        isSwitched = value;
                      });
                    }
                ),
                Text("Accept conditions")
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: IconButton(
        icon: Icon(Icons.next_week_outlined),
        onPressed: (){
          _checkValidations(context);
        },
      ),
    );
  }

  Future<void> _checkValidations(BuildContext context) async {
    final formState = form.currentState as FormState;
    if (formState.validate()) {
      formState.save();
      if (user.isNotEmpty && password.isNotEmpty && email.isNotEmpty && age.isNotEmpty && isSwitched == true && selectedGender.isNotEmpty) {
        List<User> listAllUsers = await dbHelperUser.getAllUsers();
        for (User userDB in listAllUsers) {
          if (userDB.username == user) {
            return _showDialogRepeat();
          }
        }
        String ageString = age.toString();
        User newUser = new User(user, password, email, ageString, selectedGender);
        dbHelperUser.insertUser(newUser);
        Navigator.of(context).pushNamed("");
      }else{
        showDialog(
            context: context,
            builder: (BuildContext context){
              return AlertDialog(
                title: Text("ERROR"),
                content: Text("This username already exists"),
                actions: <Widget>[
                  TextButton(
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("OK"))
                ],
              );
            }
        );
      }
    }else if (isSwitched == false){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("ERROR"),
              content: Text("Please, accept conditions"),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            );
          }
      );
    }else if (selectedGender.isEmpty){
      showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              title: Text("ERROR"),
              content: Text("Please, confirm your gender"),
              actions: <Widget>[
                TextButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"))
              ],
            );
          }
      );
    }
  }

  Future<void> _showDialogRepeat() {
    return  showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("ERROR"),
            content: Text("This username already exists"),
            actions: <Widget>[
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"))
            ],
          );
        }
    );
  }
}

