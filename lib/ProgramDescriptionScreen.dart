import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'main.dart';

class ProgramDescriptionScreen extends StatelessWidget {
  final Tableau tableau;

  const ProgramDescriptionScreen({super.key, required this.tableau});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: getAppTheme(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(tableau.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              if (tableau.imageString != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.network(
                    tableau.imageString!,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                tableau.description,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
