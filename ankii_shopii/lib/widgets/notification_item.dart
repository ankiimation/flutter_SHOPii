import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

class CustomNotificationListItem extends StatelessWidget {
  final String title;
  final String description;
  final String dateTimeString;

  CustomNotificationListItem({this.title, this.description, this.dateTimeString});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20),
          ),
          Text(
            dateTimeString,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: DEFAULT_TEXT_STYLE.copyWith(
                fontWeight: FontWeight.bold, fontSize: 10, color: PRIMARY_COLOR.withOpacity(0.5)),
          )
        ],
      ),
    );
  }
}
