import 'package:ankiishopii/global/global_function.dart';
import 'package:ankiishopii/helpers/string_helper.dart';
import 'package:ankiishopii/models/ordering_model.dart';
import 'package:ankiishopii/pages/ordering/ordering_detail_page.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/base/custom_ontap_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomNotificationListItem extends StatelessWidget {
  final String title;
  final String description;
  final String dateTimeString;

  CustomNotificationListItem(
      {this.title, this.description, this.dateTimeString});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10, top: 10, bottom: 10),
      decoration: BoxDecoration(
          color: FOREGROUND_COLOR, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                fontWeight: FontWeight.bold, fontSize: 25),
          ),
          Text(
            description,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TEXT_STYLE_ON_FOREGROUND.copyWith(fontSize: 20),
          ),
          Text(
            dateTimeString,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: PRIMARY_COLOR.withOpacity(0.5)),
          )
        ],
      ),
    );
  }
}

class CustomOrderItem extends StatefulWidget {
  final OrderingModel orderingModel;
  final double elevation;
  final Function onTap;

  CustomOrderItem({this.orderingModel, this.elevation = 1, this.onTap});

  @override
  _CustomOrderItemState createState() => _CustomOrderItemState();
}

class _CustomOrderItemState extends State<CustomOrderItem> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.yellow;
    switch (widget.orderingModel.status) {
      case 1:
        statusColor = Colors.yellow;
        break;
      case 2:
        statusColor = Colors.orange;
        break;
      case 3:
        statusColor = Colors.green;
        break;
      default:
        statusColor = Colors.red;
        break;
    }
    return Container(
      margin: EdgeInsets.only(bottom: widget.elevation + 5),
      child: RaisedButton(
        onPressed: widget.onTap,
        elevation: widget.elevation,
        color: FOREGROUND_COLOR,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
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
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        '${widget.orderingModel.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Created: ',
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        ' ${DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.parse(widget.orderingModel.createdDate))}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            letterSpacing: 1.2),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total: ',
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${numberToMoneyString(countOrderTotal(widget.orderingModel))}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: PRICE_COLOR_ON_FORE),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Status: ',
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${getOrderStatus(widget.orderingModel)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                        style: TEXT_STYLE_ON_FOREGROUND.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1.2),
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
      ),
    );
  }
}
