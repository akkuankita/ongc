// // ignore_for_file: library_private_types_in_public_api, deprecated_member_use

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:http/http.dart' as http;
// import 'package:url_launcher/url_launcher.dart';

// class ExcelDownloader extends StatefulWidget {
//   const ExcelDownloader({super.key});

//   @override
//   _ExcelDownloaderState createState() => _ExcelDownloaderState();
// }

// class _ExcelDownloaderState extends State<ExcelDownloader> {
//   Future<void> _downloadFile(String url) async {
//     final response = await http.get(Uri.parse(url));
//     final bytes = response.bodyBytes;

//     // Get the directory for temporary storage
//     final directory = await getTemporaryDirectory();
//     final filePath = '${directory.path}/example.xlsx';

//     // Write the file
//     File file = File(filePath);
//     await file.writeAsBytes(bytes);

//     // Do something with the file
//     // For example, you could open it using another package or display a notification
//     // After using the file, you may want to delete it
//     // await file.delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Excel Downloader'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             openXLSXFile();
//           },
//           child: const Text(
//               'http://13.201.209.141/uploads/reports/exportData_propertyWise_2023-08-03_to_2024-02-10.xlsx'),
//         ),
//       ),
//     );
//   }

//   void openXLSXFile() async {
//     // Replace 'path/to/your/file.xlsx' with the actual path to your XLSX file.
//     const String filePath =
//         'exportData_propertyWise_2023-08-03_to_2024-02-10.xlsx';

//     // Use the url_launcher package to open the file with the default application.

//     if (await canLaunch(filePath)) {
//       await launch(filePath);
//     } else {
//       // Handle the case where the file could not be opened.
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: Text('Error'),
//           content: Text('Could not open the file.'),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }
// }
