import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:scryfall_app/controllers/userController.dart';

class Home extends StatelessWidget {
  Home({super.key});
  
  @override
  Widget build(BuildContext context) {
    TextEditingController textEditingController = TextEditingController();
    
    final imagePicker = ImagePicker();
    File? imageFile;

    pick(ImageSource source) async {
      final pickedFile = await imagePicker.pickImage(source: source);

      if(pickedFile != null) {
        imageFile = File(pickedFile.path);
      }
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color.fromARGB(255, 22, 22, 25), Color.fromARGB(255, 66, 30, 62)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter
            ),
        ),

        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Scryfall is a powerful Magic: The Gathering card search',
                  style: TextStyle(
                    color: Colors.white
                  ),
                ),
            
                SizedBox(
                  height: 20,
                ),
            
                TextField(
                  controller: textEditingController,
                  style: TextStyle(
                    color: Colors.white
                  ),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    labelText: 'Card name',
                    filled: true,
                    fillColor: Color(0xFF242031),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Image.asset('assets/img/scryfall-icon.png', width: 24, height: 24)
                    ),
                    suffixIcon: IconButton(
                      onPressed: () async{
                        await pick(ImageSource.camera);

                        if(imageFile != null){
                          final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);
                          final InputImage inputImage = InputImage.fromFile(imageFile!);
                          final RecognizedText recognizedText = await textRecognizer.processImage(inputImage);

                          String text = recognizedText.text;

                          textRecognizer.close();
                          
                          textEditingController.text = text;
                          imageFile = null;
                          Get.toNamed('/search', arguments: textEditingController.text);
                        }
                      }, 
                      icon: Icon(Icons.camera_alt)
                      )
                  ),
                ),
            
                SizedBox(
                  height: 10,
                ),
            
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        if(Get.isRegistered<UserController>()) {
                          Get.toNamed('/favorites');
                        }
                        else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('To access favorites cards, you need to be logged in.'))
                          );
                        }
                      }, 
                      icon: Icon(Icons.star)
                    ),
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/search', arguments: textEditingController.text),
                      child: Text('Search')
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}