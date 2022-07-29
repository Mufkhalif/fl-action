// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, sort_child_properties_last

import 'dart:typed_data';

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
  final _controller = GlobalKey<PageTurnState>();
  bool isLoading = false;

  int pagesCount = 0;
  int imagesCount = 0;

  List<PdfPageImage> listImages = [];

  @override
  void initState() {
    super.initState();

    getLocalAssets();
    // getPdfDocuments();
  }

  Future<void> getPdfDocuments() async {
    setState(() {
      isLoading = true;
    });

    final document = await PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
    );

    setState(() {
      pagesCount = document.pagesCount;
      isLoading = false;
    });
  }

  Future<void> getLocalAssets() async {
    setState(() {
      isLoading = true;
    });

    List<PdfPageImage> data = <PdfPageImage>[];

    final document = await PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
    );

    // final document = await PdfDocument.openAsset('assets/pdf/example.pdf');
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

  Future<List<PdfPageImage?>> getData() async {
    var data = <PdfPageImage>[];

    List images = [];

    final document = await PdfDocument.openAsset('assets/pdf/example.pdf');
    final pageCount = document.pagesCount;

    for (var i = 1; i < pageCount; i++) {
      final page = await document.getPage(i);

      final pageImage = await page.render(
        width: page.width,
        height: page.height,
      );

      data.add(pageImage!);

      var img = pageImage.bytes;
      images.add(img);
      await page.close();
    }

    print("length image: ${images.length}");

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

class ImagePdfContent extends StatefulWidget {
  const ImagePdfContent({Key? key, required this.number}) : super(key: key);

  final int number;

  @override
  State<ImagePdfContent> createState() => _ImagePdfContentState();
}

class _ImagePdfContentState extends State<ImagePdfContent> {
  late PdfController _pdfController;

  bool _isSampleDoc = true;

  @override
  void initState() {
    super.initState();

    getPdfDocuments();
  }

  Future<void> getPdfDocuments() async {
    _pdfController = PdfController(
        document: PdfDocument.openData(
          InternetFile.get('https://pibo.imgix.net/books/file/1656741894.pdf'),
        ),
        initialPage: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: PdfView(
        controller: _pdfController,
        builders: PdfViewBuilders<DefaultBuilderOptions>(
          options: const DefaultBuilderOptions(
            loaderSwitchDuration: Duration(seconds: 1),
            transitionBuilder: SomeWidget.transitionBuilder,
          ),
          documentLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          pageLoaderBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          errorBuilder: (_, error) => Center(child: Text(error.toString())),
          pageBuilder: SomeWidget.pageBuilder,
        ),
      ),
    );
  }

  PhotoViewGalleryPageOptions _pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) {
    return PhotoViewGalleryPageOptions(
      imageProvider: PdfPageImageProvider(
        pageImage,
        index,
        document.id,
      ),
      minScale: PhotoViewComputedScale.contained * 1,
      maxScale: PhotoViewComputedScale.contained * 2,
      initialScale: PhotoViewComputedScale.contained * 1.0,
      heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
    );
  }
}

class SomeWidget {
  static Widget builder(
    BuildContext context,
    PdfViewPinchBuilders builders,
    PdfLoadingState state,
    WidgetBuilder loadedBuilder,
    PdfDocument? document,
    Exception? loadingError,
  ) {
    final Widget content = () {
      switch (state) {
        case PdfLoadingState.loading:
          return KeyedSubtree(
            key: const Key('pdfx.root.loading'),
            child: builders.documentLoaderBuilder?.call(context) ??
                const SizedBox(),
          );
        case PdfLoadingState.error:
          return KeyedSubtree(
            key: const Key('pdfx.root.error'),
            child: builders.errorBuilder?.call(context, loadingError!) ??
                Center(child: Text(loadingError.toString())),
          );
        case PdfLoadingState.success:
          return KeyedSubtree(
            key: Key('pdfx.root.success.${document!.id}'),
            child: loadedBuilder(context),
          );
      }
    }();

    final defaultBuilder =
        builders as PdfViewPinchBuilders<DefaultBuilderOptions>;
    final options = defaultBuilder.options;

    return AnimatedSwitcher(
      duration: options.loaderSwitchDuration,
      transitionBuilder: options.transitionBuilder,
      child: content,
    );
  }

  static Widget transitionBuilder(Widget child, Animation<double> animation) =>
      FadeTransition(opacity: animation, child: child);

  static PhotoViewGalleryPageOptions pageBuilder(
    BuildContext context,
    Future<PdfPageImage> pageImage,
    int index,
    PdfDocument document,
  ) =>
      PhotoViewGalleryPageOptions(
        imageProvider: PdfPageImageProvider(
          pageImage,
          index,
          document.id,
        ),
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.contained * 3.0,
        initialScale: PhotoViewComputedScale.contained * 1.0,
        heroAttributes: PhotoViewHeroAttributes(tag: '${document.id}-$index'),
      );
}
