import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class ThirdPageStep2 extends StatefulWidget {
  @override
  _ThirdPageStep2State createState() => _ThirdPageStep2State();
}

class _ThirdPageStep2State extends State<ThirdPageStep2> {
  List<Asset> images = <Asset>[];

  Future<void> loadAssets() async {
    List<Asset> resultList = <Asset>[];
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
      );
    } catch (e) {
      print(e);
    }

    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter quelques images de votre espace"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Vous aurez besoin de 4 photos pour commencer. Vous pouvez en ajouter d'autres ou apporter des modifications ultérieurement.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                loadAssets();
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: images.isEmpty
                    ? Center(
                  child: Text(
                    "Choisissez au moins 4 photos",
                    style: TextStyle(color: Colors.grey),
                  ),
                )
                    : buildGridView(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridView() {
    return GridView.count(
      crossAxisCount: 3,
      children: List.generate(images.length, (index) {
        Asset asset = images[index];
        return AssetThumb(
          asset: asset,
          width: 300,
          height: 300,
        );
      }),
    );
  }
}
