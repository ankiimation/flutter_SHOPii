import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
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
        statusColor = PRICE_COLOR;
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Order: ',
                      style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    Text(
                      '${orderingModel.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Created: ',
                      style: DEFAULT_TEXT_STYLE.copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      ' ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(orderingModel.createdDate))}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: DEFAULT_TEXT_STYLE.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: PRIMARY_COLOR.withOpacity(0.5),
                          letterSpacing: 1.2),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total: ',
                      style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${numberToMoneyString(countOrderTotal(orderingModel))}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: PRICE_COLOR),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Status: ',
                      style: DEFAULT_TEXT_STYLE.copyWith(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${getOrderStatus(orderingModel)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: DEFAULT_TEXT_STYLE.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 14, color: PRIMARY_COLOR, letterSpacing: 1.2),
                    ),
                  ],
                )
              ],
            ),
          ),
          SizedBox(
            width: 20,
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
