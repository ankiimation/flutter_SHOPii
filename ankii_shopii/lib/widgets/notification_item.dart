import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class CustomOrderItem extends StatelessWidget {
  final OrderingModel orderingModel;

  CustomOrderItem({this.orderingModel});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.yellow;
    switch (orderingModel.status) {
      case 1:
        statusColor = Colors.yellow;
        break;
      case 2:
        statusColor = Colors.orange;
        break;
      case 3:
        statusColor = Colors.green;
        break;
      case 4:
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.black26;
        break;
    }
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      decoration: BoxDecoration(color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Order: ${orderingModel.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              Text(
                'Created date: ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderingModel.createdDate))}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: DEFAULT_TEXT_STYLE.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 10, color: PRIMARY_COLOR.withOpacity(0.5)),
              ),
              Text(
                'Total: ${countOrderTotal(orderingModel)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20),
              ),
              Text(
                'Status: ${getOrderStatus(orderingModel)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: DEFAULT_TEXT_STYLE.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 12, color: PRIMARY_COLOR,letterSpacing: 1.2),
              )
            ],
          ),
          CircleAvatar(
            radius: 20,
            backgroundColor: BACKGROUND_COLOR,
            child: CircleAvatar(
              radius: 15,
              backgroundColor: statusColor,
            ),
          )
        ],
      ),
    );
  }
}
