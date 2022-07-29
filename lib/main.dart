// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, sort_child_properties_last

import 'package:fl_cicd/home_screen.dart';
import 'package:fl_cicd/pageturn1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

void main() {
  runApp(MyApp());
  // runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePagePdfView(),
    );
  }
}

// class HomePage extends StatefulWidget {
//   const HomePage({
//     Key? key,
//   }) : super(key: key);

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<PdfPageImage> imagesPdf = [];

//   final _controller = GlobalKey<PageTurnState>();

//   Future<PdfPageImage?> getPdfDocuments() async {
//     final document = await PdfDocument.openData(
//         InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'));

//     print(document.pagesCount);

//     final page = await document.getPage(2);
//     final pageImage = await page.render(
//       width: page.width,
//       height: page.height,
//     );

//     await page.close();
//     return pageImage;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: FutureBuilder<PdfPageImage?>(
//       future: getPdfDocuments(),
//       builder: (context, snapshot) {
//         if (snapshot.data == null) return CircularProgressIndicator();

//         return Image(
//           image: MemoryImage(snapshot.data!.bytes),
//         );
//       },
//     ));
//   }
// }

// class AlicePage extends StatefulWidget {
//   final int page;

//   const AlicePage({Key? key, required this.page}) : super(key: key);

//   @override
//   State<AlicePage> createState() => _AlicePageState();
// }

// class _AlicePageState extends State<AlicePage> {
//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTextStyle.merge(
//       style: const TextStyle(fontSize: 16.0),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: <Widget>[
//               Text(
//                 "CHAPTER ${widget.page}",
//                 style: const TextStyle(
//                   fontSize: 32.0,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const Text(
//                 "Down the Rabbit-Hole",
//                 style: TextStyle(
//                   fontSize: 24.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 32.0),
//               Row(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   const Expanded(
//                     child: Text(
//                         "Alice was beginning to get very tired of sitting by her sister on the bank, and of"
//                         " having nothing to do: once or twice she had peeped into the book her sister was "
//                         "reading, but it had no pictures or conversations in it, `and what is the use of "
//                         "a book,' thought Alice `without pictures or conversation?'"),
//                   ),
//                   Container(
//                     margin: const EdgeInsets.only(left: 12.0),
//                     color: Colors.black26,
//                     width: 160.0,
//                     height: 220.0,
//                     child: const Placeholder(),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
