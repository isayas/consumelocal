import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';

ProgressDialog pr;

class UploadFormField extends StatefulWidget {
  @override
  _UploadFormFieldState createState() => _UploadFormFieldState();
}

class _UploadFormFieldState extends State<UploadFormField> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  List<String> _categories = <String>[
    '',
    "Salud",
    "Tienda",
    "Comida",
    "Envios",
    "Servicios"
  ];
  bool _validate = false;
  String _name = "";
  String _phone = "";
  String _category = "";
  String _address = "";
  String _urlFace = "";
  bool _homeDelivery = false;


  @override
  Widget build(BuildContext context) {
    pr = ProgressDialog(context);
    pr.style(
        message: 'Enviando datos...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Agregar un negocio"),
      ),
      body: new SafeArea(
          top: false,
          bottom: false,
          child: new Form(
              key: _formKey,
              autovalidate: _validate,
              child: new ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: <Widget>[
                  new TextFormField(
                    onSaved: (val) => _name = val,
                    decoration: const InputDecoration(
                      icon: const FaIcon(FontAwesomeIcons.store),
                      hintText: 'Nombre del negocio',
                      labelText: 'Nombre',
                    ),
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(30),
                    ],
                    validator: (val) => val.isEmpty ? 'Nombre requerido' : null,
                  ),
                  new FormField(
                    builder: (FormFieldState state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          icon: const FaIcon(FontAwesomeIcons.cubes),
                          labelText: 'Categoria',
                        ),
                        isEmpty: _category == '',
                        child: new DropdownButtonHideUnderline(
                          child: new DropdownButton(
                            value: _category,
                            isDense: true,
                            onChanged: (String newValue) {
                              setState(() {
                                _category = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: _categories.map((String value) {
                              return new DropdownMenuItem(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                  new TextFormField(
                    onSaved: (val) => _phone = val,
                    decoration: const InputDecoration(
                      icon: const FaIcon(FontAwesomeIcons.phoneAlt),
                      hintText: 'Ingresa teléfono para pedidos',
                      labelText: 'Teléfono',
                    ),
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      WhitelistingTextInputFormatter.digitsOnly,
                      new LengthLimitingTextInputFormatter(10),
                    ],
                    validator: (String arg) {
                      if (arg.length != 10)
                        return 'Teléfono debe ser de 10 digitos';
                      else
                        return null;
                    },
                  ),
                  new TextFormField(
                    onSaved: (val) => _urlFace = val,
                    decoration: const InputDecoration(
                      icon: const FaIcon(FontAwesomeIcons.facebook),
                      hintText: 'fb.com/nombreDeNegocio',
                      labelText: 'Facebook',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (String value) {
                      if (value.isNotEmpty) {
                        Pattern pattern =
                            r'^((^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$))$';
                        RegExp regex = new RegExp(pattern);
                        if (!regex.hasMatch(value))
                          return 'Ingresa una URL correcta';
                        else
                          return null;
                      } else {
                        return null;
                      }
                    },
                  ),
                  new TextFormField(
                    onSaved: (val) => _address = val,
                    decoration: const InputDecoration(
                        icon: const FaIcon(FontAwesomeIcons.mapMarkedAlt),
                        hintText: "Calle Numero Colonia CP Municipio",
                        labelText: "Dirección"),
                    maxLines: 4,
                  ),
                  new CheckboxListTile(
                    secondary: const FaIcon(FontAwesomeIcons.motorcycle),
                    title: const Text('¿Ofrece servicio a domicilio?'),
                    value: _homeDelivery,
                    onChanged: (val) {
                      setState(() {
                        _homeDelivery = val;
                      });
                    },
                  ),
                  new Container(
                      padding: const EdgeInsets.all(10),
                      child: new RaisedButton(
                        color: Colors.deepOrange,
                        child: const Text('Enviar',style: TextStyle(color: Colors.white,fontSize: 18),),
                        onPressed: () async {
                          pr.show();
                          _sendToServer();
                        },
                      )),
                ],
              ))),
    );
  }

  _sendToServer() {
    if (_formKey.currentState.validate()) {
      //No error in validator
      _formKey.currentState.save();

        Firestore.instance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              Firestore.instance.collection('propuestos');

          await reference.add({
            "nombre": "$_name",
            "categoria": "$_category",
            "telefono": "$_phone",
            "urlFace": "$_urlFace",
            "direccion": "$_address",
            "aDomicilio": "$_homeDelivery",
            "created_at": FieldValue.serverTimestamp()
          });

        }).then((val) {
          // do something upon success
          print(val);
          _successDialog();

        }).catchError((e) {
          // do something upon error

        });

    } else {
      // validation error
      setState(() {
        _validate = true;
      });
    }
  }
  Future<void> _successDialog() async {
    pr.hide();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gracias'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Revisaremos la información'),
                Text('Pronto aparecerá el negocio y recuerda #ConsumeLocal'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Limpiar'),
              onPressed: () {
                _formKey.currentState.reset();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
