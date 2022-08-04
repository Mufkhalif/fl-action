part of 'page_bloc.dart';

abstract class PageEvent extends Equatable {
  const PageEvent();

  @override
  List<Object> get props => [];
}

class InitialPage extends PageEvent {
  final List<Widget> pages;
  final List<Widget> showPages;
  final int pageNumber;

  const InitialPage({
    required this.pageNumber,
    required this.pages,
    required this.showPages,
  });

  @override
  List<Object> get props => [pageNumber, pages, showPages];
}

class OnNextPage extends PageEvent {
  final int pageNumber;

  const OnNextPage({required this.pageNumber});

  @override
  List<Object> get props => [pageNumber];
}

class LoadOtherPage extends PageEvent {
  final int index;

  const LoadOtherPage(this.index);

  @override
  List<Object> get props => [index];
}
