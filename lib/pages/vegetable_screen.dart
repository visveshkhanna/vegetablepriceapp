import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vegetableapp/functions/api_fetch.dart';

class VegetableScreen extends StatefulWidget {
  final vegetableData, city;
  const VegetableScreen({Key? key, required this.vegetableData, required this.city})
      : super(key: key);

  @override
  State<VegetableScreen> createState() => _VegetableScreenState();
}

class PriceData {
  PriceData(this.date, this.price);
  final String date;
  final int price;
}

class _VegetableScreenState extends State<VegetableScreen> {
  var chartData;
  bool _isLoading = true;
  late TooltipBehavior _tooltipBehavior;
  late TooltipBehavior _tooltipBehavior2;
  late TooltipBehavior _tooltipBehavior3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true, header: "Price");
    _tooltipBehavior2 = TooltipBehavior(enable: true, header: "Price");
    _tooltipBehavior3 = TooltipBehavior(enable: true, header: "Price");

    getVegetableChartData(widget.city,widget.vegetableData["id"]).then((value) {
      setState(() {
        chartData = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_sharp,
            color: Colors.black,
            size: 30,
          ),
        ),
        title: Column(
          children: [
            Text(
              widget.vegetableData["englishName"],
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              widget.vegetableData["tamilName"],
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: Center(
          child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: _isLoading
            ? CircularProgressIndicator(
                color: Colors.black,
              )
            : Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Image(
                    image: CachedNetworkImageProvider(
                      widget.vegetableData["photourl"],
                    ),
                    width: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Wholesale price",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Text(
                    "₹${widget.vegetableData["wholesale"]}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Retail price",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Text(
                    "₹${widget.vegetableData["retail"]}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Shoppinng Mall price",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                  Text(
                    "₹${widget.vegetableData["mall"]}",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 22,
                    ),
                  ),

                  // Wholesale chart
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              "Wholesale Chart",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              "${chartData['startDate']} to ${chartData['endDate']}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior3,
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<PriceData, String>>[
                      LineSeries<PriceData, String>(
                          // Bind data source
                          dataSource: <PriceData>[
                            for (int i = 0;
                                i < chartData["wholesale"].length;
                                i++)
                              PriceData(chartData["wholesale"][i][1].toString(),
                                  chartData["wholesale"][i][0]),
                          ],
                          xValueMapper: (PriceData sales, _) => sales.date,
                          yValueMapper: (PriceData sales, _) => sales.price,
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ],
                  ),

                  // Retail Chart
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              "Retail Chart",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              "${chartData['startDate']} to ${chartData['endDate']}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior2,
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<PriceData, String>>[
                      LineSeries<PriceData, String>(
                          // Bind data source
                          dataSource: <PriceData>[
                            for (int i = 0; i < chartData["retail"].length; i++)
                              PriceData(chartData["retail"][i][1].toString(),
                                  chartData["retail"][i][0]),
                          ],
                          xValueMapper: (PriceData sales, _) => sales.date,
                          yValueMapper: (PriceData sales, _) => sales.price,
                          dataLabelSettings: DataLabelSettings(isVisible: true))
                    ],
                  ),

                  // Mall Chart
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              "Shopping Mall Chart",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 10, bottom: 5),
                            child: Text(
                              "${chartData['startDate']} to ${chartData['endDate']}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SfCartesianChart(
                    tooltipBehavior: _tooltipBehavior,
                    // Initialize category axis
                    primaryXAxis: CategoryAxis(),
                    series: <LineSeries<PriceData, String>>[
                      LineSeries<PriceData, String>(
                          // Bind data source
                          dataSource: <PriceData>[
                            for (int i = 0; i < chartData["mall"].length; i++)
                              PriceData(chartData["mall"][i][1].toString(),
                                  chartData["mall"][i][0]),
                          ],
                          xValueMapper: (PriceData sales, _) => sales.date,
                          yValueMapper: (PriceData sales, _) => sales.price,
                          dataLabelSettings:
                              DataLabelSettings(isVisible: true)),
                    ],
                  ),
                ],
              ),
      )),
    );
  }
}
