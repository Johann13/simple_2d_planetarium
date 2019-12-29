import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_util/hover/hover_widget.dart';
import 'package:screen_size_util/screen_size_util.dart';
import 'package:simple_2d_planetarium/planetarium_painter.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double size = min(
      MediaQuery.of(context).size.width,
      MediaQuery.of(context).size.height,
    )*0.9;

    return Scaffold(
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          children: <Widget>[
            Container(
              width: size,
              height: size,
              child: Planetarium(),
            ),
            Footer(),
          ],
        ),
      ),
    );
  }
}


class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      extraSmall: (_) {
        return Container(
          height:
          max(MediaQuery.of(context).height, MediaQuery.of(context).width) *
              0.1,
          child: Card(
            child: Center(
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    LinkWidget(
                      text: 'Made by Johann Feser',
                      url: 'https://johannfeser.dev',
                      linkStyle: TextStyle(),
                    ),
                    LinkWidget(
                      text: 'Using Flutter 💙',
                      url: 'https://flutter.dev',
                      linkStyle: TextStyle(),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
      large: (_) {
        return Container(
          height: MediaQuery.of(context).height * 0.1,
          child: Card(
            child: Center(
              child: LayoutBuilder(builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    LinkWidget(
                      text: 'Made by Johann Feser',
                      url: 'https://johannfeser.dev',
                      linkStyle: TextStyle(),
                    ),
                    LinkWidget(
                      text: 'With Flutter',
                      url: 'https://flutter.dev',
                      linkStyle: TextStyle(),
                    ),
                  ],
                );
              }),
            ),
          ),
        );
      },
    );
  }
}

class LinkWidget extends StatelessWidget {
  final String text;
  final String url;
  final TextStyle linkStyle;

  const LinkWidget({
    Key key,
    @required this.text,
    @required this.url,
    @required this.linkStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HoverBoolWidget(
      builder: (BuildContext context, bool value) {
        return GestureDetector(
          child: Text(
            text,
            style: (linkStyle ?? TextStyle()).copyWith(
              decoration: TextDecoration.underline,
              color: value ? Colors.green[300] : null,
            ),
          ),
          onTap: () {
            launch(url.replaceAll(',', '').trim());
          },
        );
      },
    );
  }
}



