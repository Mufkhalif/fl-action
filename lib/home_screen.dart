// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, sort_child_properties_last

import 'package:fl_cicd/custome_pdf_render.dart';
import 'package:fl_cicd/pageturn1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart' as px;

class HomePagePdfView extends StatefulWidget {
  const HomePagePdfView({
    Key? key,
  }) : super(key: key);

  @override
  _HomePagePdfViewState createState() => _HomePagePdfViewState();
}

class _HomePagePdfViewState extends State<HomePagePdfView> {
  final _controller = GlobalKey<PageTurnState>();
  final Map<int, px.PdfPageImage?> _pages = {};

  bool isLoading = false;

  int pagesCount = 0;

  late PdfController pdfController;

  @override
  void initState() {
    super.initState();

    initPdf();

    // getPdfDocuments();
  }

  Future<void> initPdf() async {
    pdfController = PdfController(
      document: px.PdfDocument.openData(
          InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf')),
    );
  }

  Future<void> getPdfDocuments() async {
    setState(() {
      isLoading = true;
    });

    final document = await px.PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
    );

    setState(() {
      pagesCount = document.pagesCount;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomePagePdf(
        controller: pdfController,
      ),
    );
    // return Scaffold(
    //   body: SafeArea(
    //     child: isLoading
    //         ? const Center(
    //             child: CircularProgressIndicator(),
    //           )
    //         : PageTurn(
    //             key: _controller,
    //             backgroundColor: Colors.white,
    //             lastPage: const Center(child: Text('Last Page!')),
    // children: <Widget>[
    //   for (var i = 0; i < pagesCount; i++)
    //     ImagePdfContent(number: i),
    // ],
    //           ),
    //   ),
    // );
  }
}

class ImagePdfContent extends StatefulWidget {
  const ImagePdfContent({Key? key, required this.number}) : super(key: key);

  final int number;

  @override
  State<ImagePdfContent> createState() => _ImagePdfContentState();
}

class _ImagePdfContentState extends State<ImagePdfContent> {
  late px.PdfPageImage imagePdfBytes;

  @override
  void initState() {
    super.initState();

    getPdfDocuments();
  }

  Future<void> getPdfDocuments() async {
    final document = await px.PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
    );

    final page = await document.getPage(widget.number + 1);
    final pageImage = await page.render(
      width: page.width,
      height: page.height,
    );

    imagePdfBytes = pageImage!;

    await page.close();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(imagePdfBytes.bytes.toString()),
    );
  }
}

class AlicePage extends StatefulWidget {
  final int page;

  const AlicePage({Key? key, required this.page}) : super(key: key);

  @override
  State<AlicePage> createState() => _AlicePageState();
}

class _AlicePageState extends State<AlicePage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: const TextStyle(fontSize: 16.0),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "CHAPTER ${widget.page}",
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                "Down the Rabbit-Hole",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    child: Text(
                        "Alice was beginning to get very tired of sitting by her sister on the bank, and of"
                        " having nothing to do: once or twice she had peeped into the book her sister was "
                        "reading, but it had no pictures or conversations in it, `and what is the use of "
                        "a book,' thought Alice `without pictures or conversation?'"),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 12.0),
                    color: Colors.black26,
                    width: 160.0,
                    height: 220.0,
                    child: const Placeholder(),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
