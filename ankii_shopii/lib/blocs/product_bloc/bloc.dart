import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/service.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc(ProductState initialState) : super(initialState);

  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    // TODO: implement mapEventToState
    if (event is GetAllProducts) {
      yield* mapGetAppProductsToState(event);
    } else if (event is GetAllProductsViaCategoryId) {
      yield* mapGetAppProductsViaCategoryIdToState(event);
    }
  }

  Stream<ProductState> mapGetAppProductsToState(GetAllProducts event) async* {
    var rs = await ProductService().getAll();
    if (rs != null) {
      yield ListProductsLoaded(rs);
    } else {
      yield ListProductsLoadingError();
    }
  }

  Stream<ProductState> mapGetAppProductsViaCategoryIdToState(GetAllProductsViaCategoryId event) async* {
    var rs = await ProductService().getAllWithCategoryId(event.categoryID);
    if (rs != null) {
      yield ListProductsLoaded(rs);
    } else {
      yield ListProductsLoadingError();
    }
  }
}
