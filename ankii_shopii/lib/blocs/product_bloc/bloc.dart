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
    } else if (event is GetAllProductsByCategoryId) {
      yield* mapGetAppProductsViaCategoryIdToState(event);
    } else if (event is GetProductById) {
      yield* mapGetProductByIdToState(event);
    } else if (event is DoFavorite) {
      yield* mapDoFavoriteByIdToState(event);
    } else if (event is GetProductsForYou) {
      yield* mapGetProductsForYouToState(event);
    } else if (event is SearchProduct) {
      yield* mapSearchProductToState(event);
    }
  }

  Stream<ProductState> mapGetAppProductsToState(GetAllProducts event) async* {
    var rs = await ProductService().getAll();
    if (rs != null) {
      yield ListProductsLoaded(rs);
    } else {
      yield ProductLoadingError();
    }
  }

  Stream<ProductState> mapGetAppProductsViaCategoryIdToState(
      GetAllProductsByCategoryId event) async* {
    await Future.delayed(Duration(seconds: 2));
    var rs = await ProductService().getAllWithCategoryId(event.categoryID);
    if (rs != null) {
      yield ListProductsLoaded(rs);
    } else {
      yield ProductLoadingError();
    }
  }

  Stream<ProductState> mapGetProductByIdToState(GetProductById event) async* {
    var rs = await ProductService().get(event.productID);
    if (rs != null) {
      yield ProductLoaded(rs);
    } else {
      yield ProductLoadingError();
    }
  }

  Stream<ProductState> mapDoFavoriteByIdToState(DoFavorite event) async* {
    // rs = await ProductService().get(event.product.id);
    var rs = await ProductService().doFavorite(event.product);
    // print(rs.isFavoriteByCurrentUser);
    // yield ProductLoaded(rs);
  }

  Stream<ProductState> mapGetProductsForYouToState(
      GetProductsForYou event) async* {
    var rs = await ProductService().getProductsForYou();
    if (rs != null) {
      yield ListProductsLoaded(rs);
    } else {
      yield ProductLoadingError();
    }
  }

  Stream<ProductState> mapSearchProductToState(SearchProduct event) async* {
    var rs = await ProductService().searchProduct(event.keyword);
    if (rs != null) {
      yield ListProductsLoaded(rs);
    } else {
      yield ProductLoadingError();
    }
  }
}
