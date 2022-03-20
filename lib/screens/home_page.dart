// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'package:finalsem_project/screens/main_drawer.dart';
import 'package:finalsem_project/utilities/key.dart';
import 'package:finalsem_project/youtube/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
//import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // dynamic _pickImageError;
  final ImagePicker _picker = ImagePicker();
  var _image;
  bool isLoading = false;
  Future getImage() async {
    try {
      XFile? image = await _picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);
      setState(() {
        _image = File(image!.path);
      });
    } catch (e) {
      setState(() {
        print(e);
      });
    }
  }
  //File convertToFile(XFile _image) => File(_image.path);

  Future<File?> testCompressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path, targetPath,
        quality: 50);
    return result;
  }

  Future<http.Response> getEmotion(File image) async {
    File? compressedImage = await testCompressAndGetFile(
        image, image.parent.absolute.path + 'temp.jpg');

    return await http.post(
      Uri.parse(
          'https://centralindia.api.cognitive.microsoft.com/face/v1.0/detect?returnFaceAttributes=emotion'),
      headers: <String, String>{
        'Content-Type': 'application/octet-stream',
        'Ocp-Apim-Subscription-Key': kAzureApiKey,
      },
      body: compressedImage!.readAsBytesSync(),
    );
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    http.Response response = await getEmotion(_image!);
    String? emotion;
    dynamic valueEmotion = 0;
    String data = response.body;
    print(data);
    print(data.length);

    if (response.statusCode == 200 && data.length != 2) {
      List<dynamic> decodedData = jsonDecode(data);
      Map<String, dynamic> emotionMap =
          decodedData[0]['faceAttributes']['emotion'];
      print(emotionMap);
      emotionMap.forEach((key, value) {
        if (value > valueEmotion) {
          valueEmotion = value;
          emotion = key;
        }
      });
      print(emotion);
      setState(() {
        isLoading = false;
      });
      _onAlertButtonsPressed(context, emotion!);
    } else {
      print(response.statusCode);
      setState(() {
        isLoading = false;
      });
      _onAlertButtonPressed(context);
    }
  }

  _onAlertButtonsPressed(context, String emotion) {
    Alert(
      context: context,
      type: AlertType.success,
      title: "ALERT",
      desc: "Emotion detected was $emotion",
      buttons: [
        DialogButton(
          child: const Text(
            "CONFIRM",
            style: TextStyle(color: Color(0xffe8e8e8), fontSize: 20),
          ),
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen(emotion))),
          color: const Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: const Text(
            "RETRY",
            style: TextStyle(color: Color(0xffe8e8e8), fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: const LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  _onAlertButtonPressed(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: "ALERT",
      desc: "No emotion was detected. Please try again.",
      buttons: [
        DialogButton(
          child: const Text(
            "Retry",
            style: TextStyle(color: Color(0xffe8e8e8), fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  _onBasicAlertPressed(context) {
    Alert(
            context: context,
            title: "Info",
            desc:
                "This app can detect the following emotions: anger, contempt, disgust, fear, happiness, neutral, sadness, surprise")
        .show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const MainDrawer(),
        appBar: AppBar(
          title: const Text(
            'Emotion Detection',
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 24),
          ),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Color(0xFF63FFDA),
                ),
                onPressed: () {
                  setState(() {
                    _onBasicAlertPressed(context);
                  });
                })
          ],
          centerTitle: true,
        ),
        backgroundColor: const Color(0xffe8e8e8),
        floatingActionButton: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: const Icon(Icons.add_a_photo),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                  flex: 10,
                  child: Center(
                    child: _image == null
                        ? const Text('No image selected')
                        : Container(
                            margin: const EdgeInsets.all(15),
                            //padding: const EdgeInsets.all(10),
                            child: Image.file(_image),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(255, 4, 40, 59),
                                width: 5,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                  )),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          width: 150,
                          child: FlatButton(
                              color: const Color(0xFF63FFDA),
                              textColor: Colors.black,
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.black,
                              padding: const EdgeInsets.all(3.0),
                              splashColor: Colors.blueAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              onPressed: _image == null
                                  ? null
                                  : () {
                                      getData();
                                    },
                              child: const Text(
                                "Confirm",
                                style: TextStyle(fontSize: 20.0),
                              )))))
            ]));
  }
}


