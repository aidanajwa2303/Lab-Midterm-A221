import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../views/screens/mainscreen.dart';

class MainMenuWidget extends StatefulWidget{
  final User user;
  const MainMenuWidget({super.key, required this.user});

  @override
  State<MainMenuWidget> createState() => _MainMenuWidgetState();
}

class _MainMenuWidgetState extends State<MainMenuWidget>{
  @override
  Widget build(BuildContext context){
    return Drawer(
      width: 250,
      elevation: 10,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(widget.user.name.toString()), 
            accountEmail: Text(widget.user.email.toString()),
            currentAccountPicture: const CircleAvatar(
              radius: 40.0,
              ),
            ),
            ListTile(
              title: const Text('Buyer'),
              onTap: (){
                Navigator.pop(context);
                Navigator.push(
                  context, 
                  EnterExitRoute(
                    exitPage: MainScreen(user: widget.user),
                    enterPage: MainScreen(user: widget.user)));

              },
            ),
            ListTile(
              title: const Text('Seller'),
              onTap: (){
                Navigator.pop(context);
              },
            )
        ],
      ),
    );
  }
  
}