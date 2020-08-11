import 'dart:core';

abstract class BlocService<M> {
  String getQueryString(Map<String, dynamic> condition) {
    String result = '';
    for (var key in condition.keys) {
      String value =
          condition[key] == null ? '' : '${condition[key].toString()}';
      result += '&$key=$value';
    }
    //remove first &
    result = result.replaceFirst('&', '');
    return result;
  }

  Future<List<M>> getAll({int from = 0, int limit});

  Future<M> get(int id);
}
