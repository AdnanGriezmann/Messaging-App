

import 'package:auto_size_text/auto_size_text.dart';
import 'package:chatting_firebase/services/firebasehelp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var loginUser = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  final storeMessage = FirebaseFirestore.instance;

  TextEditingController msg = TextEditingController();

  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  Service service = Service();

  final List<String> con = [
    'Setting',
    'Logout',
  ];
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      appBar: topBar(),
      drawer: drs(),
      body: Material(
        child: Column(
          
          
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: AutoSizeText(
                'Messages',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                ),
              ),
            ),
            Expanded(
              child: Container(
                      
              height: 650,
              child: 
              SingleChildScrollView(
                physics: ScrollPhysics(),
                reverse: true,
                child: ShowMessages()),
              
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 11.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.white, width: 0.2),
                        ),
                      ),
                      child: TextField(
                        controller: msg,
                        decoration: InputDecoration(hintText: 'Enter Message...'),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (msg.text.isNotEmpty) {
                        storeMessage.collection('Messages').doc().set({
                          'messages': msg.text.trim(),
                          'user': loginUser!.email.toString(),
                          'time':DateTime.now(),
                        });
                        msg.clear();
                      }
                    },
                    icon: Icon(Icons.send, color: Colors.red),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //APPBar................

  topBar() {
    return AppBar(
      //automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Messaging App'),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) {
            return con
                .map((e) => PopupMenuItem<String>(value: e, child: Text(e)))
                .toList();
          },
          onSelected: (value) async {
            switch (value) {
              case 'Setting':
                break;
              case 'Logout':
                service.signOut(context);
                break;
            }
            SharedPreferences pref = await SharedPreferences.getInstance();
            pref.remove("email");
          },
        ),
      ],
    );
  }

  //Drawer sidebar...............

  Drawer drs() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('adnan'),
            accountEmail: Text(loginUser!.email.toString()),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.black,
              child: Text('a'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class ShowMessages extends StatefulWidget {
  @override
  _ShowMessagesState createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
   var loginUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context ) {
    return StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance.collection('Messages').orderBy('time').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            physics: ScrollPhysics(),
            reverse: true,
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            primary: true,
            
            itemBuilder: (context, i) {
            
            QueryDocumentSnapshot x = snapshot.data!.docs[i];
           
            return ListTile(
              title: Column(
       crossAxisAlignment: loginUser!.email==x['user']?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    decoration: BoxDecoration(
                   color:loginUser!.email==x['user']? Colors.blue.withOpacity(0.2):Colors.amber.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(20.0),
                    ),
                    
                    
                    
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                           Text(x['messages']),
                           SizedBox(height: 5),
                           Text(
                             "user: " + x['user'],
                             style: TextStyle(fontSize: 10,color: Colors.white),
                           ),
                           
                          
                     ],
                   ),
                 
              
               
                  ),
                ]),
            );
            
          });
        });
  }
}
