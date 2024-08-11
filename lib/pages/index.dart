import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/themes/color.dart';
import 'package:myapp/themes/state.dart';
import 'package:myapp/pages/detail.dart';
import 'package:http/http.dart' as http;

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  List users = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUser();
  }

  fetchUser() async {
    setState(() {
      isLoading = true;
    });
    var url =
        "https://datausa.io/api/data?drilldowns=State&measures=Population&year=latest";
    var response = await http.get(Uri.parse(url));
    // print(response.body);
    if (response.statusCode == 200) {
      var items = json.decode(response.body)['data'];
      setState(() {
        users = items;
        isLoading = false;
      });
    } else {
      users = [];
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List States"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (users.contains(null) || isLoading) {
      return const Center(
          child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(primary),
      ));
    }
    return ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return getCard(users[index]);
        });
  }

  Widget getCard(item) {
    var fullName = item['State'];
    var population = 'Population: ${item['Population']}';
    var profileUrl =
        'https://flagcdn.com/h40/${stateCode[item['Slug State']]}.png';
    List<double> latLng = stateLatLng[item['Slug State']] ?? [36.056332, -161.4299172];

    return GestureDetector(
      onTap: () {
        // Navigate to the detail page when the ListTile is tapped.
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(
              title: fullName,
              lat: latLng[0],
              lng: latLng[1],
            ),
          ),
        );
      },
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius:
                BorderRadiusDirectional.vertical(top: Radius.circular(8))),
        // elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            title: Row(
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: primary,
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage(profileUrl))),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        width: MediaQuery.of(context).size.width - 140,
                        child: Text(
                          fullName,
                        )),
                    Text(
                      population.toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
