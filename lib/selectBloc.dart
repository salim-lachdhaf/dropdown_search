import 'package:rxdart/rxdart.dart';

class SelectOneBloc<T> {
  final Future<List<T>> Function(String text) onFind;
  final _filter$ = BehaviorSubject.seeded("");
  BehaviorSubject<List<T>> _list$;

  Stream<List<T>> filteredListOut;
  Stream<List<T>> _filteredListOnlineOut;
  Stream<List<T>> _filteredListOfflineOut;

  SelectOneBloc(List<T> items, this.onFind) {
    _list$ = BehaviorSubject.seeded(items);

    _filteredListOfflineOut =
        
       CombineLatestStream.combine2(_list$, _filter$, filter);

    _filteredListOnlineOut = _filter$
        .where((_) => onFind != null)
        .distinct()
        .debounceTime(Duration(milliseconds: 500))
        .switchMap((val) => Stream.fromFuture(onFind(val)).startWith(null));

    filteredListOut =
        MergeStream([_filteredListOfflineOut, _filteredListOnlineOut]);
  }

  void onTextChanged(String filter) {
    _filter$.add(filter ?? "".toLowerCase());
  }

  List<T> filter(List<T> list, String filter) {
    return list
        ?.where(
          (item) =>
              _filter$.value == null ||
              item.toString().toLowerCase().contains(_filter$.value) ||
              _filter$.value.isEmpty,
        )
        ?.toList();
  }

  // bool isFiltered(T item, String filter)

  void dispose() {
    _filter$.close();
    _list$.close();
  }
}
