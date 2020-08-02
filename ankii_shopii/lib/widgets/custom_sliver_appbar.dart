import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/pages/cart/cart_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'app_bar.dart';

class CustomSliverAppBar extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final GlobalKey<CartWidgetState> cartIconKey;

  CustomSliverAppBar({@required this.expandedHeight, this.cartIconKey});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    bool isCollapsed = kToolbarHeight - shrinkOffset <= 0;
    return Container(
      decoration: BoxDecoration(color: FOREGROUND_COLOR, boxShadow: [
        BoxShadow(color: Colors.black26, offset: Offset(0, 3), blurRadius: 3)
      ]),
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          AnimatedOpacity(
            duration: Duration(milliseconds: 200),
            opacity: isCollapsed ? 0 : 1,
            child: CachedNetworkImage(
              imageUrl:
                  "https://www.arcgis.com/sharing/rest/content/items/8f762395cd204552bb958ecb1b54339d/resources/1588745514029.jpeg?w=2932",
              fit: BoxFit.cover,
            ),
          ),
//          Container(
//            margin: EdgeInsets.only(top: kToolbarHeight, left: 10),
//            child: AnimatedOpacity(
//              duration: Duration(milliseconds: 200),
//              opacity: isCollapsed ? 0 : 1,
//              child: Text(
//                "Commerce",
//                style: TEXT_STYLE_PRIMARY.copyWith(
//                  fontWeight: FontWeight.w700,
//                  fontSize: 23,
//                ),
//              ),
//            ),
//          ),
          Positioned(
            width: ScreenHelper.getWidth(context),
            child: Container(
              margin: EdgeInsets.only(
                  top: expandedHeight / 1.2 - shrinkOffset >= kToolbarHeight
                      ? expandedHeight / 1.2 - shrinkOffset
                      : kToolbarHeight,
                  right: 20,
                  left: 20),
              height: isCollapsed ? 65 : 70,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                elevation: 10,
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'SHOPii',
                          style:
                              TEXT_STYLE_PRIMARY.copyWith(letterSpacing: 1.2),
                        ),
                        CustomOnTapWidget(
                          onTap: () {
                            //  print('ok');
                            Navigator.push(context,
                                MaterialPageRoute(builder: (b) => CartPage()));
                          },
                          child: CartWidget(
                            cartIconKey,
                            size: 25,
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 70;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
