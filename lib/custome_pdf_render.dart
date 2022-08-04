// ignore_for_file: library_private_types_in_public_api, avoid_print, sized_box_for_whitespace, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:fl_cicd/pageturn1.dart';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:synchronized/synchronized.dart';

final Lock _lock = Lock();

class CustomePagePdf extends StatefulWidget {
  const CustomePagePdf({
    required this.controller,
    this.onPageChanged,
    this.onDocumentLoaded,
    this.onDocumentError,
    this.builders = const PdfViewBuilders<DefaultBuilderOptions>(
      options: DefaultBuilderOptions(),
    ),
    this.renderer = _render,
    this.scrollDirection = Axis.horizontal,
    this.pageSnapping = true,
    this.physics,
    this.backgroundDecoration = const BoxDecoration(),
    Key? key,
  }) : super(key: key);
  final PdfController controller;
  final void Function(int page)? onPageChanged;
  final void Function(PdfDocument document)? onDocumentLoaded;
  final void Function(Object error)? onDocumentError;
  final PdfViewBuilders builders;
  final PDfViewPageRenderer renderer;
  final Axis scrollDirection;
  final bool pageSnapping;
  final BoxDecoration? backgroundDecoration;
  final ScrollPhysics? physics;
  static Future<PdfPageImage?> _render(PdfPage page) => page.render(
        width: page.width * 2,
        height: page.height * 2,
        format: PdfPageImageFormat.jpeg,
        backgroundColor: '#ffffff',
      );

  @override
  State<CustomePagePdf> createState() => _CustomePagePdfState();
}

class _CustomePagePdfState extends State<CustomePagePdf> {
  final Map<int, PdfPageImage?> _pages = {};
  PdfController get _controller => widget.controller;
  Exception? _loadingError;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _controller._attach(this);
    _currentIndex = _controller._pageController!.initialPage;
    _controller.loadingState.addListener(() {
      switch (_controller.loadingState.value) {
        case PdfLoadingState.loading:
          _pages.clear();
          break;
        case PdfLoadingState.success:
          widget.onDocumentLoaded?.call(_controller._document!);
          break;
        case PdfLoadingState.error:
          widget.onDocumentError?.call(_loadingError!);
          break;
      }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller._detach();

    super.dispose();
  }

  Future<PdfPageImage> _getPageImage(int pageIndex) =>
      _lock.synchronized<PdfPageImage>(() async {
        if (_pages[pageIndex] != null) {
          return _pages[pageIndex]!;
        }

        final page = await _controller._document!.getPage(pageIndex + 1);

        try {
          _pages[pageIndex] = await widget.renderer(page);
        } finally {
          await page.close();
        }

        return _pages[pageIndex]!;
      });

  @override
  Widget build(BuildContext context) {
    return widget.builders.builder(
      context,
      widget.builders,
      _controller.loadingState.value,
      _buildPageTurn,
      _controller._document,
      _loadingError,
    );
  }

  Widget _buildPageTurn(BuildContext context) =>
      _controller._document?.pagesCount != null
          ? PageTurn(
              children: <Widget>[
                for (var i = 0; i < _controller._document!.pagesCount; i++)
                  ImagePdfRender(
                    pdfPageImage: _getPageImage(i),
                  ),
              ],
              lastPage: const Center(child: Text('Last Page!')),
            )
          : Container();
}

/// Pages control
class PdfController with BasePdfController {
  PdfController({
    required this.document,
    this.initialPage = 1,
    this.viewportFraction = 1.0,
  }) : assert(viewportFraction > 0.0);

  @override
  final ValueNotifier<PdfLoadingState> loadingState =
      ValueNotifier(PdfLoadingState.loading);

  /// Document future for showing in [PdfView]
  Future<PdfDocument> document;

  /// The page to show when first creating the [PdfView].
  late int initialPage;

  /// The fraction of the viewport that each page should occupy.
  ///
  /// Defaults to 1.0, which means each page fills the viewport in the scrolling
  /// direction.
  final double viewportFraction;

  _CustomePagePdfState? _pdfViewState;
  PageController? _pageController;
  PdfDocument? _document;

  /// Actual page number wrapped with ValueNotifier
  @override
  late final ValueNotifier<int> pageListenable = ValueNotifier(initialPage);

  /// Actual showed page
  @override
  int get page => (_pdfViewState!._currentIndex) + 1;

  /// Count of all pages in document
  @override
  int? get pagesCount => _document?.pagesCount;

  Future<void> _loadDocument(
    Future<PdfDocument> documentFuture, {
    int initialPage = 1,
  }) async {
    assert(_pdfViewState != null);

    if (!await hasPdfSupport()) {
      _pdfViewState!._loadingError = Exception(
          'This device does not support the display of PDF documents');
      loadingState.value = PdfLoadingState.error;
      return;
    }

    try {
      if (page != initialPage) {
        _pdfViewState?.widget.onPageChanged?.call(initialPage);
        pageListenable.value = initialPage;
      }
      _reInitPageController(initialPage);
      _pdfViewState!._currentIndex = this.initialPage = initialPage;

      _document = await documentFuture;
      loadingState.value = PdfLoadingState.success;
    } catch (error) {
      _pdfViewState!._loadingError =
          error is Exception ? error : Exception('Unknown error');
      loadingState.value = PdfLoadingState.error;
    }
  }

  void _reInitPageController(int initialPage) {
    _pageController?.dispose();
    _pageController = PageController(
      initialPage: initialPage - 1,
      viewportFraction: viewportFraction,
    );
  }

  void _attach(_CustomePagePdfState pdfViewState) {
    if (_pdfViewState != null) {
      return;
    }

    _pdfViewState = pdfViewState;

    _reInitPageController(initialPage);

    if (_document == null) {
      _loadDocument(document, initialPage: initialPage);
    }
  }

  void _detach() {
    _pdfViewState = null;
  }

  void dispose() {
    _pageController?.dispose();
  }
}

class ImagePdfRender extends StatelessWidget {
  const ImagePdfRender({
    Key? key,
    required this.pdfPageImage,
  }) : super(key: key);

  final Future<PdfPageImage> pdfPageImage;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PdfPageImage>(
      future: pdfPageImage,
      builder: (context, snapshot) {
        if (snapshot.data == null) return CircularProgressIndicator();

        return Image(image: MemoryImage(snapshot.data!.bytes));
      },
    );
  }
}
