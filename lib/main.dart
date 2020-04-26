import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:consumelocal/ui/upload.dart';
import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:consumelocal/ui/about.dart';
import 'package:consumelocal/ui/detail.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ConsumeLocal',
        theme: new ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false);
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController editingController = TextEditingController();

  int selectedIndex = 2;
  String selectedItem = 'OPB';
  final List<String> categories = [
    "Salud",
    "Tienda",
    "Comida",
    "Envios",
    "Servicios"
  ];
  String _searchText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Theme(
          data: new ThemeData.dark(),
          child: new DropdownButtonHideUnderline(
            child: new DropdownButton<String>(
              value: selectedItem,
              items: <DropdownMenuItem<String>>[
                new DropdownMenuItem(
                  child: new Text('Chetumal'),
                  value: 'OPB',
                ),
                /*new DropdownMenuItem(
                    child: new Text('Felipe Carrillo Puerto'),
                    value: 'FCP',
                  ),*/
              ],
              onChanged: (String value) {
                setState(() => selectedItem = value);
              },
            ),
          ),
        ),
        backgroundColor: Colors.deepOrangeAccent,
        actions: <Widget>[
          IconButton(
              icon: FaIcon(FontAwesomeIcons.plusCircle),
              onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => UploadFormField()))),
          IconButton(
              icon: FaIcon(FontAwesomeIcons.infoCircle),
              onPressed: () => Navigator.push(
                  context,
                  PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (_, __, ___) => About()))),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() => _searchText = "");
                  }
                  if (value.length > 3) {
                    setState(() => _searchText = value);
                  }
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: "Buscador",
                    hintText: "Ingresa el nombre del negocio",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)))),
              ),
            ),
            Expanded(
              child: _buildBody(context, selectedIndex),
            ),
          ],
        ),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Colors.deepOrange,
          selectedItemBackgroundColor: Colors.green,
          selectedItemIconColor: Colors.white,
          selectedItemLabelColor: Colors.black,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: FontAwesomeIcons.medkit,
            label: 'Salud',
            selectedBackgroundColor: Colors.blue,
          ),
          FFNavigationBarItem(
            iconData: FontAwesomeIcons.shoppingBasket,
            label: 'Tienda',
            selectedBackgroundColor: Colors.red,
          ),
          FFNavigationBarItem(
            iconData: FontAwesomeIcons.utensils,
            label: 'Comida',
            selectedBackgroundColor: Colors.orange,
          ),
          FFNavigationBarItem(
            iconData: FontAwesomeIcons.motorcycle,
            label: 'Envios',
            selectedBackgroundColor: Colors.grey,
          ),
          FFNavigationBarItem(
            iconData: FontAwesomeIcons.handshake,
            label: 'Servicios',
            selectedBackgroundColor: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, int filter) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('locales')
          .where('categoria', isEqualTo: categories[filter])
          .orderBy("subcategoria")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, snapshot.data.documents);
      },
    );
  }

  Widget _buildGroupSeparator(dynamic groupByValue) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        groupByValue,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      )),
    );
  }

  Widget _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return GroupedListView(
      elements: snapshot.toList(),
      groupBy: (element) => element['subcategoria'],
      groupSeparatorBuilder: _buildGroupSeparator,
      itemBuilder: _buildListItem,
      order: GroupedListOrder.ASC,
    );
  }

  Widget _buildListItem(BuildContext context, DocumentSnapshot data) {
    final record = Record.fromSnapshot(data);
    if (_searchText != "" &&
        record.name.toLowerCase().contains(_searchText.toLowerCase())) {
      return InkWell(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => LocalStoreDetail(record))),
        child: Container(
          color: Colors.deepOrange,
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Hero(
                tag: "avatar_" + record.id.toString(),
                child: Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: record.avatar,
                    placeholder: (context, url) => CircularProgressIndicator(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(record.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              )
            ],
          ),
        ),
      );
    } else {
      return InkWell(
        onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => LocalStoreDetail(record))),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Row(
            children: <Widget>[
              Hero(
                tag: "avatar_" + record.id.toString(),
                child: Container(
                  width: 64.0,
                  height: 64.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: CachedNetworkImage(
                    imageUrl: record.avatar,
                    placeholder: (context, url) => CircularProgressIndicator(),
                  ),
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(record.name,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}

class Record {
  final String id;
  final String name;
  final String phone;
  final String subcategory;
  final String avatar;
  final DocumentReference reference;

  Record.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['nombre'] != null),
        assert(map['telefono'] != null),
        assert(map['subcategoria'] != null),
        id = reference.documentID,
        name = map['nombre'],
        phone = map['telefono'].toString(),
        subcategory = map['subcategoria'],
        avatar =
            'https://ui-avatars.com/api/?background=FF6E40&color=fff&name=' +
                map['nombre'];

  Record.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$id:$name:$phone:$subcategory:$avatar>";
}
