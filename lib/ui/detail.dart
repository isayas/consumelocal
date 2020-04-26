import 'dart:ui';

import 'package:consumelocal/main.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LocalStoreDetail extends StatelessWidget {
  final Record _localStore;

  LocalStoreDetail(this._localStore);
  Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget titleSection = Container(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _localStore.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Text(
                  _localStore.phone,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /* RANKING
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          Text('41'),
          */
        ],
      ),
    );

    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FlatButton(
            onPressed: () {
              _launched = _makePhoneCall('tel:' + _localStore.phone);
            },
            color: Colors.orange,
            padding: EdgeInsets.all(10.0),
            child: Column(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                FaIcon(FontAwesomeIcons.phoneAlt, color: Colors.white),
                Text("Llamar",
                    style: TextStyle(
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              _launched = _makePhoneCall('https://api.whatsapp.com/send?phone=521' +
                  _localStore.phone +
                  '&text=%5B%F0%9F%87%B2%F0%9F%87%BD%20CL%5D%20Hola%20quiero%20%20');
            },
            color: Colors.green,
            padding: EdgeInsets.all(10.0),
            child: Column(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                Text("Whatsapp",
                    style: TextStyle(
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              final RenderBox box = context.findRenderObject();
              Share.share(
                  'Te recomiendo ' +
                      _localStore.name +
                      ' puedes llamar al ' +
                      _localStore.phone +
                      ' // Descarga la app #ConsumeLocal',
                  subject: '#ConsumeLocal ' + _localStore.name,
                  sharePositionOrigin:
                      box.localToGlobal(Offset.zero) & box.size);
            },
            color: Colors.blue,
            padding: EdgeInsets.all(10.0),
            child: Column(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                FaIcon(FontAwesomeIcons.shareAlt, color: Colors.white),
                Text("Compartir", style: TextStyle(color: Colors.white))
              ],
            ),
          ),
        ],
      ),
    );

    Widget textSection = Container(
      padding: const EdgeInsets.all(32),
      child: Text(
        '#ConsumeLocal',
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_localStore.subcategory),
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              width: 120,
              child: Hero(
                tag: "avatar_" + _localStore.id.toString(),
                child: CachedNetworkImage(
                  fit: BoxFit.fitWidth,
                  imageUrl: _localStore.avatar,
                  placeholder: (context, url) => CircularProgressIndicator(),
                ),
              ),
            ),
            titleSection,
            buttonSection,
            textSection,
          ],
        ),
      ),
    );
  }
}
