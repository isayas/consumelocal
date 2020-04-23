import 'package:material_about/material_about.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Acerca de"),
        backgroundColor: Color(0xFFC17900),
      ),
      body: MaterialAbout(
        name: "Isaias Contreras",
        position: "<impulsAPP>",
        seperatorColor: Colors.grey,
        iconColor:  Color(0xFFC17900),
        textColor: Colors.black,
//        playstoreID: "1111111111111",
//        github: "YourID", //e.g JideGuru
//        bitbucket: "YourID",
//        facebook: "YourID", //e.g jideguru
        twitter: "isayasmx", //e.g JideGuru
//        instagram: "yourID", //e.g jideguru
//        youtube: "yourID",
//        dribble: "yourID",
        linkedin: "isayas",
        email: "isaias.cb@gmail.com",
        whatsapp: "+5215544224810", //without international code e.g 22994684468.
//        skype: "yourID",
//        google: "yourSearchQuery",
//        android: "yourID",
//        website: "yourURL",
        appIcon: "images/appIcon.png",
        appName: "ConsumeLocal",
        appVersion: "1.0.0",
//        removeAds: "Link to pro app",
        description: "Brinda una solución práctica para llamar a los negocios locales de la ciudad. \n Los negocios pueden contar con servicio a domicilio o bien hacer uso de los motoservicios que también se encuentran en este directorio.",
        donate: "https://docs.google.com/forms/d/e/1FAIpQLSdNMuX0EbTvcGqsBWE_WXuQUWtWuF0uKf_X6GGcwpgfdrHLFQ/viewform?usp=sf_link",
//        changelog: "Link to changeLog",
//        help: "Link to about app", //to be improved soon
        share: "Te invito a instalar la app #ConsumeLocal #Chetumal para que contactes facilmente a tu negocio local preferido.",
        devID: "8634998114706028276",
      ),
    );
  }

}