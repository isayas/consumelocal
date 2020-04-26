import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
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
    Widget aboutPage = AboutPage(
      title: Text('Acerca de'),
      applicationVersion: 'Version 1.0.2',
      applicationDescription: Text(
        'Brinda una solución práctica para llamar a los negocios locales de la ciudad. Estos pueden contar con servicio a domicilio o bien hacer uso de los motoservicios que también se encuentran en este directorio.\n#ConsumeLocal',
        textAlign: TextAlign.justify,
      ),
      applicationIcon: Image(
        image: AssetImage('images/appIcon.png'),
        height: 128,
      ),
      applicationLegalese: '© Isaias Contreras <impulsAPP>, {{ year }}',
      children: <Widget>[
        Card(
          child: ListTile(
            title: Text('Comparte esta app'),
            leading: FaIcon(FontAwesomeIcons.shareAlt),
            onTap: () {
              _shareApp(context);
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Califica esta app'),
            leading: FaIcon(FontAwesomeIcons.star),
            onTap: () {
              _launched = _makePhoneCall(
                  'https://play.google.com/store/apps/details?id=me.impulsapp.consumelocal');
            },
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Contacta al desarrollador'),
            leading: FaIcon(FontAwesomeIcons.solidEnvelope),
            onTap: () {
              _launched = _makePhoneCall('mailto:isaias.cb@gmail.com');
            },
          ),
        ),
      ],
    );

    return Scaffold(
      body: aboutPage,
    );
  }
}

_shareApp(BuildContext context) {
  final RenderBox box = context.findRenderObject();
  Share.share(
      'Descarga la app #ConsumeLocal y contacta facilmente a tu negocio favorito https://play.google.com/store/apps/details?id=me.impulsapp.consumelocal',
      subject: 'Descarga la app ConsumeLocal',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}
