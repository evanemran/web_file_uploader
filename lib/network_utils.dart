import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http_parser/http_parser.dart';

Future<String> uploadImage(FilePickerResult result, Function callback) async {

  if (result.files.isNotEmpty) {
    Uint8List? fileBytes = result.files.first.bytes;
    String fileName = result.files.first.name;

    // Create the multipart request
    var request = http.MultipartRequest('POST', Uri.parse('https://api.escuelajs.co/api/v1/files/upload'));

    // Add the image as a multipart file
    request.files.add(
      http.MultipartFile.fromBytes(
        'file', // This is the name of the form field on the server
        fileBytes!,
        filename: fileName,
        contentType:  MediaType('image','jpg'), // Adjust according to image type
      ),
    );

    // Send the request
    var response = await request.send();

    // Handle the response
    if (response.statusCode == 201) {
      // Convert the stream to a string and then to JSON
      final respStr = await response.stream.bytesToString();
      final Map<String, dynamic> responseData = jsonDecode(respStr);

      // Extract the 'location' field from the response
      String imageUrl = responseData['location'];
      print('Upload successful: Image URL is $imageUrl');

      callback.call(true);

      // Save the image URL (you can save it locally, in memory, or a database)
      // For example, you can store it in a variable or shared preferences
      return imageUrl;
      print("Image URL saved: $imageUrl");
    } else {
      callback.call(false);
      return "";
      print('Upload failed with status: ${response.statusCode}');
    }
  } else {
    callback.call(false);
    return "";
    print('No image selected.');
  }
}