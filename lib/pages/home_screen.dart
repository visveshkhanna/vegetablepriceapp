import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vegetableapp/functions/api_fetch.dart';
import 'package:vegetableapp/pages/vegetable_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var finalVegetableList;
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVegetableData().then((value) {
      setState(() {
        finalVegetableList = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Madurai",
          style: TextStyle(
              color: Colors.black, fontSize: 25, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
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
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, __, ___) => VegetableScreen(
                                vegetableData: finalVegetableList[index]),
                            transitionDuration: Duration(milliseconds: 150),
                            transitionsBuilder: (_, a, __, c) =>
                                FadeTransition(opacity: a, child: c),
                          ),
                        );
                      },
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.transparent,
                        backgroundImage: CachedNetworkImageProvider(
                          finalVegetableList[index]["photourl"],
                        ),
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
