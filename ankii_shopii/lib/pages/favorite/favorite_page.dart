import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/product_item.dart';
import 'package:ankiishopii/widgets/tab_view.dart';
import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  static const String pageRoute = '/favoritePage';
  final ScrollController scrollController;

  FavoritePage(this.scrollController);

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: Column(
        children: <Widget>[
          InPageAppBar(
            title: 'Favorite',
          ),
          Expanded(child: buildFavorite()),
        ],
      ),
    );
  }

  Widget buildFavorite() {
    return CustomTabView(
      barShadow: false,
      backgroundColor: BACKGROUND_COLOR,
      children: [
        CustomTabViewItem(
            icon: Icons.fastfood,
            label: 'Noodle',
            color: PRIMARY_COLOR,
            child: SingleChildScrollView(
              controller: widget.scrollController,
              child: Column(
                children: <Widget>[
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  FlatButton(
                      onPressed: () {},
                      child: Text(
                        'View More >>',
                        style: DEFAULT_TEXT_STYLE.copyWith(color: PRIMARY_COLOR),
                      ))
                ],
              ),
            )),
        CustomTabViewItem(
            icon: Icons.free_breakfast,
            label: 'Snack',
            color: PRIMARY_COLOR,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  FlatButton(
                      onPressed: () {},
                      child: Text(
                        'View More >>',
                        style: DEFAULT_TEXT_STYLE.copyWith(color: PRIMARY_COLOR),
                      ))
                ],
              ),
            )),
        CustomTabViewItem(
            icon: Icons.local_drink,
            label: 'Drink',
            color: PRIMARY_COLOR,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  CustomProductListItem(
                    image: NetworkImage(
                        'https://conbovang.vn/wp-content/uploads/2017/06/m%E1%BB%B9-x%C3%A0o-th%E1%BA%ADp-c%E1%BA%A9m.jpg'),
                    title: 'Mì xào hải sản',
                    price: '50000đ',
                    priceTextColor: Colors.red,
                    backgroundColor: FOREGROUND_COLOR,
                  ),
                  FlatButton(
                      onPressed: () {},
                      child: Text(
                        'View More >>',
                        style: DEFAULT_TEXT_STYLE.copyWith(color: PRIMARY_COLOR),
                      ))
                ],
              ),
            )),
      ],
    );
  }
}
