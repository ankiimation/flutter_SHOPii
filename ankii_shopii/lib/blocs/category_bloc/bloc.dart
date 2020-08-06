import 'package:ankiishopii/blocs/category_bloc/event.dart';
import 'package:ankiishopii/blocs/category_bloc/service.dart';
import 'package:ankiishopii/blocs/category_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc(CategoryState initialState) : super(initialState);

  @override
  Stream<CategoryState> mapEventToState(CategoryEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetCategories) {
      yield* mapLoadEventToState(event);
    }
  }

  Stream<CategoryState> mapLoadEventToState(GetCategories event) async* {
//    try {
    var rs = await CategoryService().getAll();
    if (rs != null) {
      rs = rs.reversed.toList();
      yield CategoriesLoaded(rs);
    } else {
      yield CategoriesLoadingError('List Null');
    }
//    } catch (e) {
//      yield CategoriesLoadingError(e.toString());
//    }
  }
}
