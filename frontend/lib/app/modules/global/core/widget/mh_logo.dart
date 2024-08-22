import 'package:flutter/material.dart';

class MHLogo extends StatelessWidget {
  const MHLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100, 
      height: 100, 
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.green, width: 4), 
      ),
      child: const Center(
        child: Text(
          'HM',
          style: TextStyle(
            fontSize: 32, 
            fontWeight: FontWeight.bold,
            color: Colors.green, 
          ),
        ),
      ),
    );
  }
}
