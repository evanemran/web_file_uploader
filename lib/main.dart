import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_file_uploader/network_utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Web Uploader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Web Uploader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String uploadedImageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw_HeSzHfBorKS4muw4IIeVvvRgnhyO8Gn8w&s";
  String selectedImageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTw_HeSzHfBorKS4muw4IIeVvvRgnhyO8Gn8w&s";
  var selectedImageBytes;
  late FilePickerResult selectedImageData;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            selectedImageBytes==null? Image.network(selectedImageUrl, height: 200, width: 200,) : Image.memory(selectedImageBytes, height: 200, width: 200,),
            const SizedBox(height: 20,),
            const Text(
              'Selected Image',
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () async {
              uploadedImageUrl = await uploadImage(selectedImageData);
            }, child: const Text("Upload Image")),

            const SizedBox(height: 20,),

            Image.network(uploadedImageUrl, height: 200, width: 200,),
            const SizedBox(height: 20,),
            const Text(
              'Uploaded Image',
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed: () {
              setState(() {

              });
            }, child: const Text("Get Image"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try{
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.image,
              withData: true,
            );
            print("Selected File Name${result!.files.first.name}");
            setState(() {
              // selectedImageUrl = result!.files.first.path.toString();
              selectedImageBytes = result!.files.first.bytes;
              selectedImageData = result;
            });
          }
          catch (e) {
            print("Error in selection: $e");
          }
        },
        tooltip: 'Choose Image',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
