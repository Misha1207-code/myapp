import 'package:flutter/material.dart';
import 'donor_screen.dart';
import 'ngo_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: RoleSelectScreen(),
  ));
}

class RoleSelectScreen extends StatelessWidget {
  const RoleSelectScreen({Key? key}) : super(key: key); 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Food Donation App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => DonorScreen())),
              child: Text("I'm a Donor"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NGOScreen())),
              child: Text("I'm an NGO"),
            ),
          ],
        ),
      ),
    );
  }
}
