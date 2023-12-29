import 'package:dropdown_search/dropdown_search.dart';

abstract class AsyncItemsProps<T, Param> {
  Future<List<T>> getter(Param param);
}

class AsyncItemsBasicProps<T> extends AsyncItemsProps<T, String> {
  final DropdownSearchOnFind<T> fn;

  AsyncItemsBasicProps({required this.fn});

  @override
  Future<List<T>> getter(String filter) {
    return fn(filter);
  }
}

class AsyncItemsPaginatedParam {
  final String filter;
  final int page;
  final int perPage;

  AsyncItemsPaginatedParam({
    required this.filter,
    required this.page,
    required this.perPage,
  });
}

class AsyncItemsPaginatedProps<T> extends AsyncItemsProps<T, AsyncItemsPaginatedParam> {
  ///function to fetch data
  final DropdownSearchOnFindPaginated<T> fn;

  ///perpage properties
  final int perPage;

  ///would be tested when exception occured on <code>fn</code> calls and check whether
  ///the exception is end of page indication or not.
  ///by default, when fn return empty list, it will mark as end of page
  final bool Function(Object)? endOfPageErrorIndication;

  AsyncItemsPaginatedProps({
    required this.fn,
    required this.perPage,
    this.endOfPageErrorIndication
  });

  @override
  Future<List<T>> getter(AsyncItemsPaginatedParam param) {
    return fn(param.filter, param.page, param.perPage);
  }
}