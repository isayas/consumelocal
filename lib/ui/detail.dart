import 'package:consumelocal/main.dart';
import "package:flutter/material.dart";
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

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
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    _localStore.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
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
              _launched = _makePhoneCall('tel:'+_localStore.phone);
            }
            ,color: Colors.orange,
            padding: EdgeInsets.all(10.0),
            child: Column( // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(Icons.call,color:Colors.white),
                Text("Llamar",style: TextStyle(
                  color: Colors.white,
                ))
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              _launched = _makePhoneCall('https://api.whatsapp.com/send?phone=521'+_localStore.phone+'&text=%F0%9F%87%B2%F0%9F%87%BD%20#CL%20Hola%20quiero%20');
            },
            color: Colors.green,
            padding: EdgeInsets.all(10.0),
            child: Column( // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(Icons.message,color:Colors.white),
                Text("Whatsapp",style: TextStyle(
                  color: Colors.white,
                )),
              ],
            ),
          ),
          FlatButton(
                onPressed: () {
              final RenderBox box = context.findRenderObject();
              Share.share('Te recomiendo '+_localStore.name+' puedes llamar al '+_localStore.phone+' // Descarga la app #ConsumeLocal',
                  subject: '#ConsumeLocal '+_localStore.name,
                  sharePositionOrigin:
                  box.localToGlobal(Offset.zero) &
                  box.size);
            },
            color: Colors.blue,
            padding: EdgeInsets.all(10.0),
            child: Column( // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(Icons.share,color:Colors.white),
                Text("Compartir",style: TextStyle(
                  color: Colors.white,
                ))
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
        title: Text(_localStore.name),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Hero(
                tag: "avatar_" + _localStore.id.toString(),
                child:
                CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(_localStore.avatar),
                )
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