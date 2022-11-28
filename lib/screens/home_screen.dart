import 'package:firebase_auth/firebase_auth.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:voidremover/screens/signin_screen.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:voidremover/api_client.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/color_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Uint8List? imageFile;

  String? imagePath;

  ScreenshotController controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: hexStringToColor("286575"),
          title: const Text('Void Remover'),
            actions: [
              IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut().then((value) {
                print("Signed Out");
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));});
            },
                  icon: const Icon(Icons.logout)),]
        ),
        bottomNavigationBar: BottomAppBar(
          color: hexStringToColor("286575"),
          child: IconTheme(
            data: IconThemeData(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: (){getImage(ImageSource.gallery);}, icon: const Icon(Icons.image)),
                  IconButton(onPressed: (){getImage(ImageSource.camera);}, icon: const Icon(Icons.camera_alt)),
                  IconButton(onPressed: ()async {
                    imageFile = await ApiClient().removeBgApi(imagePath!);
                    setState(() {});
                  }, icon: const Icon(Icons.delete)),
                  IconButton(onPressed: ()async {
                    saveImage();
                  }, icon: const Icon(Icons.save)),
                ],
              ),
            ),
          ),

        ),

        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  hexStringToColor("8fe7bc"),
                  hexStringToColor("52959f"),
                  hexStringToColor("286575")
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    (imageFile != null)
                        ? Screenshot(
                      controller: controller,
                      child: Image.memory(
                        imageFile!,
                      ),
                    )
                        : Container(
                      width: 300,
                      height: 400,

                      child: const Icon(
                        Icons.image,
                        size: 200,
                ),
              ),
            ],
          ),

        ))));
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }

  void saveImage() async {
    bool isGranted = await Permission.storage.status.isGranted;
    if (!isGranted) {
      isGranted = await Permission.storage.request().isGranted;
    }

    if (isGranted) {
      String directory = (await getExternalStorageDirectory())!.path;
      String fileName =
          DateTime.now().microsecondsSinceEpoch.toString() + ".png";
      controller.captureAndSave(directory, fileName: fileName);
      await GallerySaver.saveImage(directory, albumName: fileName);


    }
  }
}
