import 'package:ankiishopii/themes/constant.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  final ScrollController scrollController;

  AccountPage(this.scrollController);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          buildAvatar(),
          SingleChildScrollView(
            controller: widget.scrollController,
            child: buildProfile(),
          )
        ],
      ),
    );
  }

  Widget buildAvatar() {
    return Container(
      padding: EdgeInsets.all(30),
      alignment: Alignment.topCenter,
      decoration: BoxDecoration(color: FOREGROUND_COLOR),
      child: CircleAvatar(
        radius: 70,
        backgroundImage: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/vi/thumb/b/b0/Avatar-Teaser-Poster.jpg/220px-Avatar-Teaser-Poster.jpg'),
      ),
    );
  }

  Widget buildProfile() {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 200),
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black38,
              offset: Offset(0, -3),
              blurRadius: 5
            )],
              color: BACKGROUND_COLOR,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Column(
            children: <Widget>[
              Container(
                height: 1000,
              )
            ],
          ),
        )
      ],
    );
  }
}
