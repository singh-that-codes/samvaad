import 'package:flutter/material.dart';
import 'package:samvaad/utils/universal_variables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Define the action you want to occur when the button is pressed
        // For example, navigate to a new screen, show a dialog, etc.
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: UniversalVariables.fabGradient,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 25,
        ),
        padding: EdgeInsets.all(15),
      ),
    );
  }
}
