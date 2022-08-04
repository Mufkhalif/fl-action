// ignore_for_file: library_private_types_in_public_api

import 'dart:typed_data';

import 'package:fl_cicd/global/bloc/page_bloc.dart';
import 'package:fl_cicd/utils/log.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:pdfx/pdfx.dart';

class PageTurn extends StatefulWidget {
  const PageTurn({
    Key? key,
    this.duration = const Duration(milliseconds: 450),
    this.cutoff = 0.6,
    this.backgroundColor = Colors.black,
    required this.children,
    this.initialIndex = 0,
    required this.lastPage,
    this.listImages = const [],
    this.listBytes = const [],
    this.onTap,
  }) : super(key: key);

  final Color backgroundColor;
  final List<Widget> children;
  final Duration duration;
  final int initialIndex;
  final Widget lastPage;
  final double cutoff;
  final List<PdfPageImage> listImages;
  final List<Uint8List> listBytes;
  final Function()? onTap;

  @override
  PageTurnState createState() => PageTurnState();
}

class PageTurnState extends State<PageTurn> with TickerProviderStateMixin {
  int pageNumber = 0;
  int page = 0;
  List<Widget> pages = [];
  List<Widget> showPages = [];
  List<Widget> allPages = [];

  final List<AnimationController> _controllers = [];
  bool? _isForward;

  bool _isLoading = true;

  // @override
  // void didUpdateWidget(PageTurn oldWidget) {
  //   if (oldWidget.children != widget.children) {
  //     _setUp();
  //   }
  //   if (oldWidget.duration != widget.duration) {
  //     _setUp();
  //   }
  //   if (oldWidget.backgroundColor != widget.backgroundColor) {
  //     _setUp();
  //   }
  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  void _setUp() {
    setState(() {
      _isLoading = true;
    });

    _controllers.clear();

    final pageBloc = context.read<PageBloc>();

    pages.clear();
    for (var i = 0; i < widget.children.length; i++) {
      final controller = AnimationController(
        value: 1,
        duration: widget.duration,
        vsync: this,
      );

      _controllers.add(controller);

      // final child = PageTurnWidget(
      //   backgroundColor: widget.backgroundColor,
      //   amount: controller,
      //   child: widget.children[i],
      // );

      final child = PageTurnImage(
        amount: controller,
        image: MemoryImage(widget.listBytes[i]),
      );

      pages.add(child);
    }

    // pageBloc.add(
    //   InitialPage(
    //     pageNumber: 1,
    //     pages: pages,
    //     showPages: pages.sublist(0, 10).reversed.toList(),
    //     // showPages: pages,
    //   ),
    // );

    allPages = pages;
    pages = pages.reversed.toList();
    // showPages = pages.reversed.toList().sublist(0, 10).reversed.toList();
    showPages = pages;
    pageNumber = widget.initialIndex;

    setState(() {
      _isLoading = false;
    });
  }

  bool get _isLastPage => (pages.length - 1) == pageNumber;

  bool get _isFirstPage => pageNumber == 0;

  void _turnPage(DragUpdateDetails details, BoxConstraints dimens) {
    final ratio = details.delta.dx / dimens.maxWidth;

    if (_isForward == null) {
      if (details.delta.dx > 0) {
        _isForward = false;
      } else {
        _isForward = true;
      }
    }

    if (_isForward! || pageNumber == 0) {
      _controllers[pageNumber].value += ratio;
    } else {
      _controllers[pageNumber - 1].value += ratio;
    }
  }

  Future<void> _onDragFinish() async {
    if (_isForward != null) {
      if (_isForward!) {
        if (!_isLastPage &&
            _controllers[pageNumber].value <= (widget.cutoff + 0.15)) {
          await nextPage();
        } else {
          await _controllers[pageNumber].forward();
        }
      } else {
        if (!_isFirstPage &&
            _controllers[pageNumber - 1].value >= widget.cutoff) {
          await previousPage();
        } else {
          if (_isFirstPage) {
            await _controllers[pageNumber].forward();
          } else {
            await _controllers[pageNumber - 1].reverse();
          }
        }
      }
    }

    _isForward = null;
  }

  Future<void> nextPage() async {
    if (kDebugMode) {
      print('Next Page..');
    }

    // Log.colorGreen(pageNumber);

    // if (pageNumber == 9) {
    //   setState(() {
    //     showPages = allPages.sublist(pageNumber - 2, 15).reversed.toList();
    //     _isLoading = true;
    //   });
    // }

    // if (pageNumber == 14) {
    //   setState(() {
    //     showPages = allPages.sublist(pageNumber - 2, 20).reversed.toList();
    //     _isLoading = true;
    //   });
    // }

    // if (pageNumber == 19) {
    //   setState(() {
    //     showPages = allPages.sublist(pageNumber - 2, 25).reversed.toList();
    //     _isLoading = true;
    //   });
    // }

    // if (pageNumber == 24) {
    //   setState(() {
    //     showPages = allPages.sublist(pageNumber - 2, 30).reversed.toList();
    //     _isLoading = true;
    //   });
    // }

    // if (pageNumber == 29) {
    //   setState(() {
    //     showPages = allPages.sublist(pageNumber - 2, 30).reversed.toList();
    //     _isLoading = true;
    //   });
    // }

    await _controllers[pageNumber].reverse();

    if (mounted) {
      setState(() => pageNumber++);
    }

    await Future.delayed(const Duration(milliseconds: 400));

    // if (_isLoading) {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
  }

  Future<void> previousPage() async {
    if (kDebugMode) {
      print('Previous Page..');
    }

    await _controllers[pageNumber - 1].forward();
    if (mounted) {
      setState(() => pageNumber--);
    }
  }

  Future<void> goToPage(int index) async {
    if (kDebugMode) {
      print('Navigate Page ${index + 1}..');
    }

    if (mounted) {
      setState(() => pageNumber = index);
    }

    for (var i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].forward();
      } else if (i < index) {
        _controllers[i].reverse();
      } else {
        if (_controllers[i].status == AnimationStatus.reverse) {
          _controllers[i].value = 1;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, dimens) => GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        onHorizontalDragCancel: () => _isForward = null,
        onHorizontalDragUpdate: (details) => _turnPage(details, dimens),
        onHorizontalDragEnd: (details) => _onDragFinish(),
        child: _renderStack(),
      ),
    );
  }

  Widget _renderStack() {
    return Stack(children: [
      ...showPages,
      if (_isLoading)
        Align(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child: const Center(child: Text("Memuat gambar lain...")),
          ),
        )
    ]);
  }
}

class PageTurnWidget extends StatefulWidget {
  const PageTurnWidget({
    Key? key,
    required this.amount,
    this.backgroundColor = const Color(0xFFFFFFCC),
    required this.child,
  }) : super(key: key);

  final Animation<double> amount;
  final Color backgroundColor;
  final Widget child;

  @override
  _PageTurnWidgetState createState() => _PageTurnWidgetState();
}

class _PageTurnWidgetState extends State<PageTurnWidget> {
  final _boundaryKey = GlobalKey();
  ui.Image? _image;

  @override
  void didUpdateWidget(PageTurnWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      _image = null;
    }
  }

  @override
  void dispose() {
    _image?.dispose();
    super.dispose();
  }

  void _captureImage(Duration timeStamp) async {
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final boundary = _boundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary;
    if (boundary.debugNeedsPaint) {
      await Future.delayed(const Duration(milliseconds: 20));
      return _captureImage(timeStamp);
    }
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    setState(() => _image = image);
  }

  @override
  Widget build(BuildContext context) {
    Log.colorGreen(_image);
    if (_image != null) {
      return CustomPaint(
        painter: PageTurnEffect(
          amount: widget.amount,
          image: _image!,
          backgroundColor: widget.backgroundColor,
        ),
        size: Size.infinite,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback(_captureImage);
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final size = constraints.biggest;
          return Stack(
            children: <Widget>[
              Positioned(
                left: 1 + size.width,
                top: 1 + size.height,
                width: size.width,
                height: size.height,
                child: RepaintBoundary(key: _boundaryKey, child: widget.child),
              ),
            ],
          );
        },
      );
    }
  }
}

class PageTurnEffect extends CustomPainter {
  PageTurnEffect({
    required this.amount,
    required this.image,
    required this.backgroundColor,
    this.radius = 0.18,
  }) : super(repaint: amount);

  final Animation<double> amount;
  final ui.Image image;
  final Color backgroundColor;
  final double radius;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final pos = amount.value;
    final movX = (1.0 - pos) * 0.85;
    final calcR = (movX < 0.20) ? radius * movX * 5 : radius;
    final wHRatio = 1 - calcR;
    final hWRatio = image.height / image.width;
    final hWCorrection = (hWRatio - 1.0) / 2.0;

    final w = size.width.toDouble();
    final h = size.height.toDouble();
    final c = canvas;
    final shadowXf = (wHRatio - movX);
    final shadowSigma =
        Shadow.convertRadiusToSigma(8.0 + (32.0 * (1.0 - shadowXf)));
    final pageRect = Rect.fromLTRB(0.0, 0.0, w * shadowXf, h);
    c.drawRect(pageRect, Paint()..color = backgroundColor);
    if (pos != 0) {
      c.drawRect(
        pageRect,
        Paint()
          ..color = Colors.black54
          ..maskFilter = MaskFilter.blur(BlurStyle.outer, shadowSigma),
      );
    }

    final ip = Paint();
    for (double x = 0; x < size.width; x++) {
      final xf = (x / w);
      final v = (calcR * (math.sin(math.pi / 0.5 * (xf - (1.0 - pos)))) +
          (calcR * 1.1));
      final xv = (xf * wHRatio) - movX;
      final sx = (xf * image.width);
      final sr = Rect.fromLTRB(sx, 0.0, sx + 1.0, image.height.toDouble());
      final yv = ((h * calcR * movX) * hWRatio) - hWCorrection;
      final ds = (yv * v);
      final dr = Rect.fromLTRB(xv * w, 0.0 - ds, xv * w + 1.0, h + ds);
      c.drawImageRect(image, sr, dr, ip);
    }
  }

  @override
  bool shouldRepaint(PageTurnEffect oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.amount.value != amount.value;
  }
}

class PageTurnImage extends StatefulWidget {
  const PageTurnImage({
    Key? key,
    required this.amount,
    required this.image,
    this.backgroundColor = const Color(0xFFFFFFCC),
  }) : super(key: key);

  final Animation<double> amount;
  final ImageProvider image;
  final Color backgroundColor;

  @override
  _PageTurnImageState createState() => _PageTurnImageState();
}

class _PageTurnImageState extends State<PageTurnImage> {
  ImageStream? _imageStream;
  ImageInfo? _imageInfo;
  bool _isListeningToStream = false;

  late ImageStreamListener _imageListener;

  @override
  void initState() {
    super.initState();
    _imageListener = ImageStreamListener(_handleImageFrame);
  }

  @override
  void dispose() {
    _stopListeningToStream();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _resolveImage();
    if (TickerMode.of(context)) {
      _listenToStream();
    } else {
      _stopListeningToStream();
    }
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(PageTurnImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _resolveImage();
    }
  }

  @override
  void reassemble() {
    _resolveImage(); // in case the image cache was flushed
    super.reassemble();
  }

  void _resolveImage() {
    final ImageStream newStream =
        widget.image.resolve(createLocalImageConfiguration(context));
    _updateSourceStream(newStream);
  }

  void _handleImageFrame(ImageInfo imageInfo, bool synchronousCall) {
    setState(() => _imageInfo = imageInfo);
  }

  // Updates _imageStream to newStream, and moves the stream listener
  // registration from the old stream to the new stream (if a listener was
  // registered).
  void _updateSourceStream(ImageStream newStream) {
    if (_imageStream?.key == newStream.key) return;

    if (_isListeningToStream) _imageStream?.removeListener(_imageListener);

    _imageStream = newStream;
    if (_isListeningToStream) _imageStream?.addListener(_imageListener);
  }

  void _listenToStream() {
    if (_isListeningToStream) return;
    _imageStream?.addListener(_imageListener);
    _isListeningToStream = true;
  }

  void _stopListeningToStream() {
    if (!_isListeningToStream) return;
    _imageStream?.removeListener(_imageListener);
    _isListeningToStream = false;
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo != null) {
      return GestureDetector(
        onTap: () => Log.colorGreen("tap"),
        child: CustomPaint(
          painter: PageTurnEffect(
            amount: widget.amount,
            image: _imageInfo!.image,
            backgroundColor: widget.backgroundColor,
          ),
          size: Size.infinite,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
