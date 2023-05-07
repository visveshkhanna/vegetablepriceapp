import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegetableapp/functions/api_fetch.dart';
import 'package:vegetableapp/pages/vegetable_screen.dart';
import 'package:vegetableapp/pages/vegetable_screen_area.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var finalVegetableList;
  var citiesList;
  bool _isLoading = true;
  bool _isCitiesLoading = true;
  var city;

  // Shared Preferences
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCities().then((value) async {
      //print(value);

      // Gets the city, and get the values.
      setState(() {
        _isCitiesLoading = false;
        citiesList = value;
        _prefs.then((value) {
          setState(() {
            if (value.getString("city") != null) {
              city = value.getString("city");
            } else {
              city = citiesList[0]["value"];
            }
            getVegetableData(city).then((value) {
              finalVegetableList = value;
              setState(() {
                _isLoading = false;
              });
            });
          });
        });
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: _isCitiesLoading
            ? Text("")
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(30),
                  value: city,
                  isExpanded: true,
                  iconSize: 30,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  items: [
                    for (int i = 0; i < citiesList.length; i++)
                      DropdownMenuItem(
                        child: Padding(padding: EdgeInsets.only(left: 10),child: Text(citiesList[i]["name"]),),
                        value: citiesList[i]["value"],
                      ),
                  ],
                  onChanged: (val) {
                    setState(() {
                      city = val as String;
                      //_fetchPrices();
                      setState(() {
                        _isLoading = true;
                      });
                      getVegetableData(city).then((value) {
                        setState(() {
                          _isLoading = false;
                          finalVegetableList = value;
                        });
                      });
                    });
                    _prefs.then((value) {
                      log("set $val");
                      value.setString("city", val as String);
                    });
                  },
                ),
              ),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator(
                color: Colors.black,
              )
            : ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: finalVegetableList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: ListTile(
                      tileColor: Color.fromRGBO(1, 1, 1, 0.05),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onTap: () {
                        SPL_CITIES.contains(city) ?
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => VegetableAreaScreen(
                                vegetableData: finalVegetableList[index],
                                city: city),
                            transitionDuration: Duration(milliseconds: 150),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c),
                          ),
                        )
                        : Navigator.push(
                        context,
                        PageRouteBuilder(
                        pageBuilder: (_, __, ___) => VegetableScreen(
                        vegetableData: finalVegetableList[index],
                        city: city),
                        transitionDuration: Duration(milliseconds: 150),
                        transitionsBuilder: (_, a, __, c) =>
                        FadeTransition(opacity: a, child: c),
                        ),
                        );
                      },
                      leading: Image(
                        image: CachedNetworkImageProvider(
                          finalVegetableList[index]["photourl"],
                        ),
                        width: 70,
                      ),
                      title: Text(
                        "${finalVegetableList[index]["englishName"]}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      subtitle:
                          Text("${finalVegetableList[index]["tamilName"]}"),
                      trailing: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white70),
                        padding: EdgeInsets.all(8),
                        child: Text(
                          "1kg",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
