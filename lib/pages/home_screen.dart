// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, sort_child_properties_last

import 'dart:typed_data';

import 'package:fl_cicd/pageturn1.dart';
import 'package:fl_cicd/utils/log.dart';
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
  List<Uint8List> listBytes = [];

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
    List<Uint8List> temp = <Uint8List>[];

    final document = await PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
    );

    final pageCount = document.pagesCount;

    for (var i = 1; i < pageCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        quality: 90,
      );

      if (i == 1) {
        Log.colorGreen(pageImage!.bytes);
      }

      temp.add(pageImage!.bytes);
      data.add(pageImage);
      await page.close();
    }

    setState(() {
      listImages = data;
      listBytes = temp;
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
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : listImages.isEmpty
                ? const Center(child: Text("Empty"))
                : Container(
                    height: height - 30,
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: PageTurn(
                      backgroundColor: Colors.white,
                      lastPage: const Center(child: Text('Last Page!')),
                      children: <Widget>[
                        for (var i = 0; i < listImages.length; i++)
                          ContentPage(data: listImages[i])
                      ],
                    ),
                  ),
      ),
    );
  }
}

class ContentPage extends StatelessWidget {
  const ContentPage({
    Key? key,
    required this.data,
    this.onTap,
  }) : super(key: key);

  final PdfPageImage data;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.memory(
        data.bytes,
        gaplessPlayback: true,
      ),
    );
  }
}
