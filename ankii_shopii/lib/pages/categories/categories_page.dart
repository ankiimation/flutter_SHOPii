import 'dart:ui';

import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  static const String routeName = "/categoriesPage";
  final ScrollController scrollController;

  CategoriesPage(this.scrollController);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
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
                buildListCategories(),
              ],
            ),
          ),
        ));
  }

  Widget buildListCategories() {
    List<String> urls = [
      'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg',
      'https://shipdoandemff.com/wp-content/uploads/2017/06/M%C3%AC-x%C3%A0o-gi%C3%B2n-shipdoandemFF.jpg',
      'https://cdn.tgdd.vn/Files/2020/03/08/1240753/3-cach-lam-mon-com-chien-thom-ngon-bo-duong-cho-bua-com-gia-dinh-2.png',
      'https://thucthan.com/media/2019/07/bun-rieu-cua/bun-rieu-cua.png',
    ];
    return Container(
        margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
        child: Column(
            children: urls
                .map((url) => _buildCategoryItem(url,
                    title: 'Category Category Category Category Category',
                    description: 'Description Description Description Description Description Description'))
                .toList()));
  }

  Widget _buildCategoryItem(String imageUrl, {String title, String description}) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
          color: FOREGROUND_COLOR,
          borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20),
        decoration: BoxDecoration(color: PRIMARY_COLOR.withOpacity(0.7), borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title ?? '',
              style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 40, color: BACKGROUND_COLOR),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              description ?? '',
              style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20, color: FOREGROUND_COLOR),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
