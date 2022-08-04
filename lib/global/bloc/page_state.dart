part of 'page_bloc.dart';

class PageState extends Equatable {
  final List<Widget> pages;
  final List<Widget> showPages;
  final int pageNumber;
  final bool isLoading;

  const PageState({
    this.pages = const [],
    this.showPages = const [],
    this.pageNumber = 0,
    this.isLoading = false,
  });

  factory PageState.initial() => const PageState();

  PageState copyWith(
          {List<Widget>? pages,
          List<Widget>? showPages,
          int? pageNumber,
          bool? isLoading}) =>
      PageState(
        pages: pages ?? this.pages,
        showPages: showPages ?? this.showPages,
        pageNumber: pageNumber ?? this.pageNumber,
        isLoading: isLoading ?? this.isLoading,
      );

  @override
  List<Object> get props => [
        pages,
        showPages,
        pageNumber,
        isLoading,
      ];
}
