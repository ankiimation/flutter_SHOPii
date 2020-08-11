import 'dart:ui';

import 'package:ankiishopii/blocs/category_bloc/bloc.dart';
import 'package:ankiishopii/blocs/category_bloc/event.dart';
import 'package:ankiishopii/blocs/category_bloc/state.dart';
import 'package:ankiishopii/models/category_model.dart';
import 'package:ankiishopii/pages/product/product_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesPage extends StatefulWidget {
  static const String routeName = "categoriesPage";
  final ScrollController scrollController;

  CategoriesPage(this.scrollController);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  CategoryBloc bloc = CategoryBloc(CategoriesLoading())..add(GetCategories());

  @override
  void dispose() {
    // TODO: implement dispose
    bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BACKGROUND_COLOR,
        body: Container(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            child: Column(
              children: <Widget>[
                InPageAppBar(
                  title: 'Categories',
                ),
                BlocBuilder(
                  builder: (_, state) {
                    if (state is CategoriesLoaded) {
                      return buildListCategories(state.categories);
                    } else if (state is CategoriesLoadingError) {
                      return Center(
                        child: CustomErrorWidget(),
                      );
                    } else {
                      return Center(
                        child: CustomDotLoading(),
                      );
                    }
                  },
                  cubit: bloc,
                )
              ],
            ),
          ),
        ));
  }

  Widget buildListCategories(List<CategoryModel> categories) {
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Column(
            children: categories
                .map((category) => _buildCategoryItem(category))
                .toList()));
  }

  Widget _buildCategoryItem(CategoryModel category) {
    return CustomOnTapWidget(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (b) => ProductPage(category: category)));
      },
      child: Container(
        margin: EdgeInsets.only(top: 20),
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(category.image),
                fit: BoxFit.cover),
            color: FOREGROUND_COLOR,
            borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          decoration: BoxDecoration(
              color: PRIMARY_COLOR.withOpacity(0.7),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                category.name ?? '',
                style: TEXT_STYLE_PRIMARY.copyWith(
                    fontSize: 40, color: BACKGROUND_COLOR),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                category.description ?? '',
                style: TEXT_STYLE_PRIMARY.copyWith(
                    fontSize: 20, color: BACKGROUND_COLOR.withOpacity(0.5)),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
