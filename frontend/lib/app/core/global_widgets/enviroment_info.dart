import 'package:flutter/material.dart';
import 'package:hospital_management/app/core/config/config.dart';

class EnvironmentInfo extends StatelessWidget {
  const EnvironmentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 34.0,
      right: 16.0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Enviroment.env != 'PROD' ? Enviroment.env : '',
              style: TextStyle(
                color: Color.fromARGB(150, 158, 158, 158), 
                fontWeight: FontWeight.bold,  
                fontSize: 48.0, 
                decoration: TextDecoration.none,
              ),
            ),
            Text(
              Enviroment.env != 'PROD' ? 'version ${Enviroment.version}' : '',
              style: TextStyle(
                color: Color.fromARGB(150, 158, 158, 158),   
                fontWeight: FontWeight.bold, 
                fontSize: 10.0,  
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
