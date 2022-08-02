// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, sort_child_properties_last

import 'package:fl_cicd/pageturn1.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class HomePagePdfView extends StatefulWidget {
  const HomePagePdfView({
    Key? key,
  }) : super(key: key);

  @override
  _HomePagePdfViewState createState() => _HomePagePdfViewState();
}

class _HomePagePdfViewState extends State<HomePagePdfView> {
  bool isLoading = false;

  int pagesCount = 0;
  int imagesCount = 0;

  List<PdfPageImage> listImages = [];

  @override
  void initState() {
    super.initState();

    getLocalAssets();
  }

  Future<void> getLocalAssets() async {
    setState(() {
      isLoading = true;
    });

    List<PdfPageImage> data = <PdfPageImage>[];

    final document = await PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
    );

    final pageCount = document.pagesCount;

    for (var i = 1; i < pageCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
      );

      data.add(pageImage!);
      await page.close();
    }

    setState(() {
      listImages = data;
      isLoading = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      listImages = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : listImages.isEmpty
                ? const Center(
                    child: Text("Empty"),
                  )
                : PageTurn(
                    backgroundColor: Colors.white,
                    lastPage: const Center(child: Text('Last Page!')),
                    children: <Widget>[
                      for (var i = 0; i < listImages.length; i++)
                        ContentPage(data: listImages[i])
                    ],
                  ),
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key, required this.data}) : super(key: key);

  final PdfPageImage data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image.memory(data.bytes),
    );
  }
}
