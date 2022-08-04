import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(PageState.initial()) {
    on<InitialPage>(_initialPage);
    on<OnNextPage>(_onNextPage);
    on<LoadOtherPage>(_loadOtherPage);
  }

  void _initialPage(InitialPage event, emit) {
    emit(state.copyWith(
      pageNumber: event.pageNumber,
      pages: event.pages,
      showPages: event.showPages,
    ));
  }

  void _onNextPage(OnNextPage event, emit) {
    emit(state.copyWith(pageNumber: event.pageNumber + 1));
  }

  void _loadOtherPage(LoadOtherPage event, emit) async {
    emit(state.copyWith(isLoading: true));

    var listPage = state.pages;
    var showPages = state.showPages;

    var nextPage = listPage.sublist(event.index, event.index + 5);

    showPages.clear();
    showPages.insertAll(0, nextPage);

    await Future.delayed(const Duration(seconds: 2));

    emit(state.copyWith(
      pageNumber: event.index + 1,
      showPages: showPages,
      isLoading: false,
    ));
  }
}
