part of 'selection_widget.dart';

class _ScrollPaginationListener<T> {
  final ScrollController scrollController;
  final TextEditingController searchBoxController;
  final ValueNotifier<bool> loadingNotifier;
  final AsyncItemsPaginatedProps<T> props;
  final ValueSetter<List<T>> onNewItemsFetched;
  final void Function(Object error, StackTrace? stackTrace) onError;

  _ScrollPaginationListener({
    required this.scrollController,
    required this.searchBoxController,
    required this.loadingNotifier,
    required this.props,
    required this.onNewItemsFetched,
    required this.onError,
  }) {
    scrollController.addListener(_paginationListener);
  }

  int _currentPage = 1;
  bool _hasReachEnd = false;

  void dispose() {
    scrollController.removeListener(_paginationListener);
  }
  
  void _paginationListener() {
    if(loadingNotifier.value) {
      return;
    }

    if(_hasReachEnd) {
      return;
    }
    
    final scrollPosition = scrollController.position;

    final currentPixel = scrollPosition.pixels;

    if(currentPixel!=scrollPosition.maxScrollExtent) {
      return;
    }

    _doPagination();
  }

  Future<void> _doPagination() {
    final completer = Completer();

    loadingNotifier.value = true;

    props.getter(AsyncItemsPaginatedParam(
      filter: searchBoxController.text,
      page: ++_currentPage,
      perPage: props.perPage,
    )).then((value) {
      if(value.isEmpty) {
        _hasReachEnd = true;
      }

      onNewItemsFetched(value);
    }).catchError((e, trace) {
      log('_paginationListener error', error: e, stackTrace: trace);

      if(props.endOfPageErrorIndication?.call(e) ?? false) {
        _hasReachEnd = true;

        return;
      }

      onError(e, trace);
    }).whenComplete(() {
      loadingNotifier.value = false;

      completer.complete();
    });

    return completer.future;
  }

  void resetPage() {
    _currentPage = 1;
  }

  void autoPaginatingSmallPerPage() async {
    while(scrollController.position.maxScrollExtent==0 && !_hasReachEnd) {
      await _doPagination();
    }
  }
}
