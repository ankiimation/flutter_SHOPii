import 'package:ankiishopii/helpers/media_query_helper.dart';
import 'package:ankiishopii/themes/constant.dart';
import 'package:ankiishopii/widgets/app_bar.dart';
import 'package:ankiishopii/widgets/notification_item.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  static const String routeName = 'notificationPage';
  final ScrollController scrollController;

  NotificationPage(this.scrollController);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BACKGROUND_COLOR,
      body: SingleChildScrollView(
          controller: widget.scrollController,
          child: Column(
            children: <Widget>[
              InPageAppBar(
                title: 'Notification',
              ),
              buildNotification(),
            ],
          )),
    );
  }

  Widget buildNotification() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        children: List<Widget>.generate(
            10,
            (index) => Container(
                  width: double.maxFinite,
                  margin: EdgeInsets.only(top: index == 0 ? 10 : 0, bottom: 10),
                  child: CustomNotificationListItem(
                    title: 'Notification' + index.toString(),
                    description:
                        'description description description description description description description description description description',
                    dateTimeString: DateTime.now().toString(),
                  ),
                )).toList(),
      ),
    );
  }
}
