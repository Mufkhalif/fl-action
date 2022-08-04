import 'package:fl_cicd/pages/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';

class ScrollVerticalPage extends StatefulWidget {
  const ScrollVerticalPage({Key? key}) : super(key: key);

  @override
  State<ScrollVerticalPage> createState() => _ScrollVerticalPageState();
}

class _ScrollVerticalPageState extends State<ScrollVerticalPage>
    with SingleTickerProviderStateMixin {
  bool isLoading = true;

  int pagesCount = 0;
  int imagesCount = 0;

  List<PdfPageImage> listImages = [];

  double _currentSliderValue = 0;
  double _maxValue = 100;

  late ScrollController _scrollController;

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getLocalAssets();
  }

  Future<void> initAnimations() async {
    _controller = AnimationController(
      value: 0.0,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      vsync: this,
    )..addStatusListener((AnimationStatus status) {
        setState(() {});
      });

    _controller.forward();

    await Future.delayed(const Duration(seconds: 5));

    _controller.reverse();
  }

  Future<void> getLocalAssets() async {
    setState(() {
      isLoading = true;
    });

    List<PdfPageImage> data = <PdfPageImage>[];

    // https://pibo.imgix.net/books/121/121.pdf
    // https://pibo.imgix.net/books/file/1656741894.pdf

    final document = await PdfDocument.openData(
      InternetFile.get('https://pibo.imgix.net/books/121/121.pdf'),
    );

    final pageCount = document.pagesCount;

    for (var i = 1; i < pageCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        backgroundColor: "#00000",
      );

      data.add(pageImage!);
      await page.close();
    }

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      listImages = data;
      isLoading = false;
    });

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    _scrollController = ScrollController();

    _scrollController.addListener(() {
      setState(() {
        _maxValue = _scrollController.position.maxScrollExtent;
        if (_scrollController.offset > 0) {
          _currentSliderValue = _scrollController.offset;
        }
      });
    });

    initAnimations();
  }

  bool get _isAnimationRunningForwardsOrComplete {
    switch (_controller.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return true;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return false;
    }
  }

  Future<void> onClickPage() async {
    if (_isAnimationRunningForwardsOrComplete) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
      _controller.reverse();
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );

      _controller.forward();
    }

    // await Future.delayed(const Duration(seconds: 4));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Container(
              child: isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Sedang menyiapkan",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 28),
                          CircularProgressIndicator(color: Colors.white)
                        ],
                      ),
                    )
                  : _renderScrollView(),
            ),
            // if (!isLoading)
            //   Positioned(
            //     bottom: 40,
            //     left: 0,
            //     right: 0,
            //     child: AnimatedBuilder(
            //       animation: _controller,
            //       builder: (BuildContext context, Widget? child) =>
            //           FadeScaleTransition(animation: _controller, child: child),
            //       child: Container(
            //         margin: const EdgeInsets.symmetric(
            //           horizontal: 24,
            //           vertical: 24,
            //         ),
            //         decoration: BoxDecoration(
            //           color: Colors.black.withOpacity(0.4),
            //           borderRadius: BorderRadius.circular(55),
            //         ),
            //         child: Slider(
            //           thumbColor: Colors.white,
            //           activeColor: Colors.white,
            //           value: _currentSliderValue,
            //           max: _maxValue,
            //           label: _currentSliderValue.round().toString(),
            //           onChanged: (double value) {
            //             _controller.stop();
            //             setState(() {
            //               _currentSliderValue = value;
            //               _scrollController.jumpTo(value);
            //             });
            //           },
            //           onChangeEnd: (_) => onClickPage(),
            //         ),
            //       ),
            //     ),
            //   ),
            if (!isLoading)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                top: _isAnimationRunningForwardsOrComplete ? 0 : -400,
                left: 0,
                right: 0,
                child: _renderHeader(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _renderHeader() {
    return Container(
      padding: const EdgeInsets.only(
        top: 60,
        bottom: 20,
      ),
      decoration: BoxDecoration(
          color: Colors.black,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black,
              Colors.black.withOpacity(0.7),
              Colors.black.withOpacity(0.6),
              Colors.black.withOpacity(0.5),
            ],
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 12,
            ),
            child: Column(
              children: const [
                Text(
                  "Mengapa Ekor cecak putus",
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _renderScrollView() {
    return Scrollbar(
      controller: _scrollController,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: listImages.length,
        itemBuilder: (context, index) =>
            ContentPage(data: listImages[index], onTap: onClickPage),
      ),
    );
  }
}
