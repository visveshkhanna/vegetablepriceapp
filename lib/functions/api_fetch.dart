import 'dart:convert';
import 'package:http/http.dart' as http;

var headers = {
  "Accept":
      "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
  "Accept-Encoding": "gzip, deflate",
  "Accept-Language": "en-US,en;q=0.9",
  "Cache-Control": "max-age=0",
  "Connection": "keep-alive",
  "Host": "vegetablemarketprice.com",
  "Upgrade-Insecure-Requests": "1",
  "Content-type": "application/json",
  "User-Agent":
      "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36",
};

Future<List> getCities() async {
  var out;
  var url = Uri.parse(
      "https://vegetablemarketprice.com/api/site/goto_data?pagetype=market&state=tamilNadu");
  var resp = await http.get(url, headers: headers);
  out = jsonDecode(resp.body);
  return out;
}

Future<Map> getVegetableChartData(String city, String id) async {
  var vegetableChart = {};

  var url = Uri.https("vegetablemarketprice.com",
      "/api/data/market/$city/latestchartdata", {"days": "7", "vegIds": id});

  var resp = await http.get(
    url,
    headers: headers,
  );
  //print("Response status: ${resp.statusCode}");
  String utf8Body = utf8.decode(resp.bodyBytes);
  Map<String, dynamic> jsondata = jsonDecode(utf8Body);

  vegetableChart["startDate"] = jsondata["startDate"];
  vegetableChart["endDate"] = jsondata["endDate"];
  vegetableChart["wholesale"] = [];
  vegetableChart["retail"] = [];
  vegetableChart["mall"] = [];

  jsondata['data'][0]['data'].asMap().forEach((index, element) {
    vegetableChart["wholesale"].add([element["y"], jsondata["columns"][index]]);
    vegetableChart["retail"].add([
      int.parse(element["retailPrice"].split("-")[0].trim()),
      jsondata["columns"][index]
    ]);
    vegetableChart["mall"].add([
      int.parse(element["shopingMallPrice"].split("-")[0].trim()),
      jsondata["columns"][index]
    ]);
  });

  return vegetableChart;
}

Future<List> getVegetableData(String city) async {
  var vegetableDataList = [];

  DateTime today = DateTime.now();
  String date = "${today.year}-${today.month}-${today.day}";

  var url = Uri.https("vegetablemarketprice.com",
      "api/data/market/$city/daywise", {"date": date});

  var resp = await http.get(
    url,
    headers: headers,
  );
  print("Response status: ${resp.statusCode}");
  String utf8Body = utf8.decode(resp.bodyBytes);
  Map<String, dynamic> jsondata = jsonDecode(utf8Body);

  jsondata["data"].forEach((element) {
    Map<String, dynamic> content = {};
    content["id"] = element["id"];
    content["photourl"] =
        "https://vegetablemarketprice.com/${element["table"]["imageUrl"].replaceFirst("64", "256")}";
    content["englishName"] = element["vegetableName"].split("(")[0].trim();
    content["tamilName"] =
        element["vegetableName"].split("(")[1].split(")")[0].trim();
    content["size"] = element["units"].trim();
    vegetableDataList.add(content);
  });

  return vegetableDataList;
}
