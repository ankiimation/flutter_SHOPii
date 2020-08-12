import 'dart:async';

import 'package:ankiishopii/blocs/product_bloc/bloc.dart';
import 'package:ankiishopii/blocs/product_bloc/event.dart';
import 'package:ankiishopii/blocs/product_bloc/state.dart';
import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/pages/product/product_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:ankiishopii/widgets/debug_widget.dart';
import 'package:ankiishopii/widgets/graphic_widget.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  static const String routeName = 'searchPage';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  ProductBloc bloc = ProductBloc(ProductLoading())..add(GetProductsForYou());
  TextEditingController textEditingController = TextEditingController();

  Timer searchTimer;

  onChangeSearch(String s) {
    if (searchTimer != null) {
      searchTimer.cancel();
    } else {}
  }

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
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: ScreenHelper.getPaddingTop(context) + 70,
                ),
                _buildResultList()
              ],
            ),
          ),
          _buildSearchBar()
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.only(
          left: 10, right: 10, top: ScreenHelper.getPaddingTop(context)),
      child: Row(
        children: <Widget>[
          CustomOnTapWidget(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: PRIMARY_TEXT_COLOR,
              size: 20,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Card(
              color: BACKGROUND_COLOR,
              elevation: 10,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      child: TextField(
                        controller: textEditingController,
                        onSubmitted: (s) {
                          bloc.add(SearchProduct(s));
                        },
                        onChanged: (s) {
                          bloc.add(SearchProduct(s));
                        },
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            hintText: 'Search', border: InputBorder.none),
                      ),
                    )),
                    CustomOnTapWidget(
                      onTap: () {
                        bloc.add(SearchProduct(textEditingController.text));
                      },
                      child: Icon(
                        Icons.search,
                        color: PRIMARY_TEXT_COLOR,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultList() {
    return BlocBuilder(
        cubit: bloc,
        builder: (context, state) {
          if (state is ListProductsLoaded) {
            return Column(
              children: state.products
                  .map((product) => CustomProductListItem(
                        product: product,
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (b) => ProductDetailPage(product)));
                        },
                        backgroundColor: FOREGROUND_COLOR,
                        showQuickActionButtons: false,
                      ))
                  .toList(),
            );
          } else if (state is ProductLoading) {
            return Center(
              child: CustomDotLoading(),
            );
          } else {
            return Center(
              child: CustomErrorWidget(
                error: 'No Result',
              ),
            );
          }
        });
  }
}
