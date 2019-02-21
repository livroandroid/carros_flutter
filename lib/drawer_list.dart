import 'package:flutter/material.dart';

class DrawerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 300,
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("Ricardo R Lecheta")/*FutureBuilder(
                future: Prefs.getString("nome"),
                builder: (context, snapshot) {
                  return Text(snapshot.hasData ? snapshot.data : "");
                },
              )*/,
              accountEmail: Text("rlecheta@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://cdn.iconscout.com/icon/free/png-256/avatar-372-456324.png"),
              ),
            ),
            ListTile(
              onTap: () {
                print("Item 1");
              },
              title: Text("Item 1"),
              subtitle: Text(
                "Mais informações...",
              ),
              leading: Icon(Icons.star),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              onTap: () {
                print("Item 2");
              },
              title: Text("Item 2"),
              subtitle: Text(
                "Mais informações...",
              ),
              leading: Icon(Icons.star),
              trailing: Icon(Icons.arrow_forward),
            ),
            ListTile(
              onTap: () {
                print("Item 3");
              },
              title: Text("Item 3"),
              subtitle: Text(
                "Mais informações...",
              ),
              leading: Icon(Icons.star),
              trailing: Icon(Icons.arrow_forward),
            )
          ],
        ),
      ),
    );
  }
}
