
import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  String url_image;
  String texte;
   ErrorPage({super.key,required this.url_image,required this.texte});

  @override
  Widget build(BuildContext context) {
    return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         Image.asset('$url_image'),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$texte',textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  );
  }
}
