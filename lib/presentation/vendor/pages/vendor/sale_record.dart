import 'package:dexter_vendor/app/shared/app_colors/app_colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dexter_vendor/datas/model/bar_chart_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesRecord extends StatefulWidget {
  const SalesRecord({Key? key}) : super(key: key);

  @override
  State<SalesRecord> createState() => _SalesRecordState();
}

class _SalesRecordState extends State<SalesRecord> {
  final List<BarChartModel> data = [
    BarChartModel(
      year: "Mon",
      financial: 250,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
    BarChartModel(
      year: "Tues",
      financial: 300,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
    BarChartModel(
      year: "Wed",
      financial: 100,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
    BarChartModel(
      year: "Thur",
      financial: 450,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
    BarChartModel(
      year: "Fri",
      financial: 630,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
    BarChartModel(
      year: "Sat",
      financial: 1000,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
    BarChartModel(
      year: "Sun",
      financial: 400,
      color: charts.ColorUtil.fromDartColor
        (greenPea), month: '',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Financial",
          data: data,
          domainFn: (BarChartModel series, _) => series.year,
          measureFn: (BarChartModel series, _) => series.financial,
          colorFn: (BarChartModel series, _) => series.color),
    ];

    final buttonTitle = [
      "Weekly",
      "Daily",
    ];
    return SafeArea(top: false, bottom: false,
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: GestureDetector(
                onTap: (){
                  Navigator.of(context).pop();
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: const BoxDecoration(color: Color(0xffF2F2F2), shape: BoxShape.circle),
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                )),
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text("Sales", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: black, fontSize: 20, fontWeight: FontWeight.w700),),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: [
                Stack(
                  children: [
                    SizedBox(height: 270,
                      child: PieChart(PieChartData(
                          centerSpaceRadius: 70,
                          borderData: FlBorderData(show: false),
                          sections: [
                            PieChartSectionData(
                                titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                                value: 1500, showTitle: false,
                                color: greenPea, radius: 40),
                            PieChartSectionData(
                                titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                                value: 500, showTitle: false,
                                color: Colors.amber, radius: 40),
                            PieChartSectionData(
                                titleStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                                value: 254, showTitle: false,
                                color: Color(0xffF2F2F7), radius: 40),
                          ])),
                    ),
                    Positioned(bottom: 50, top: 50, right: 50, left: 50,
                      child: Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("Balance", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w400, fontSize: 12, color: Color(0xffAEAEB2)),),
                            const SizedBox(height: 5,),
                            Text("N 5300.14", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 16),),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 10, width: 10,
                            decoration: BoxDecoration(color: greenPea, borderRadius: BorderRadius.circular(5)),
                          ),
                          const SizedBox(height: 10,),
                          Text("Income",),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 10, width: 10,
                            decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(5)),
                          ),
                          const SizedBox(height: 10,),
                          Text("Service fee",),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            height: 10, width: 10,
                            decoration: BoxDecoration(color: Color(0xffF2F2F7), borderRadius: BorderRadius.circular(5)),
                          ),
                          const SizedBox(height: 10,),
                          Text("Withdrawal",),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 38,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Sales Report", style: Theme.of(context).textTheme.bodyLarge?.
                    copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff1C1C1E)),),
                    PopupMenuButton(
                      position: PopupMenuPosition.under,
                      child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Text("Filter"),
                                Icon(Icons.keyboard_arrow_down_outlined, size: 20, color: Color(0XFF187226),),
                              ],
                            ),
                          )
                      ),
                      itemBuilder: (context) {
                        return List.generate(buttonTitle.length, (index) {
                          return PopupMenuItem(
                            child: Text(buttonTitle[index]),
                            onTap: (){
                              if(index == 0){
                              }else(){
                              };
                            },
                          );
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Container(
                  height: MediaQuery.of(context).size.height/3, width: double.infinity, 
                  decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(16)),
                  child: SizedBox(height: 600,
                    child: charts.BarChart(series,
                        animate: true)
                  ),
                ),
                const SizedBox(height: 15,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Orders", style: Theme.of(context).textTheme.bodyLarge?.
                    copyWith(fontWeight: FontWeight.w400, fontSize: 16, color: Color(0xff1C1C1E)),),
                    PopupMenuButton(
                      position: PopupMenuPosition.under,
                      child:  Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(border: Border.all(color: Colors.black), borderRadius: BorderRadius.circular(15)),
                            child: Row(
                              children: [
                                Text("Filter"),
                                Icon(Icons.keyboard_arrow_down_outlined, size: 20, color: Color(0XFF187226),),
                              ],
                            ),
                          )
                      ),
                      itemBuilder: (context) {
                        return List.generate(buttonTitle.length, (index) {
                          return PopupMenuItem(
                            child: Text(buttonTitle[index]),
                            onTap: (){
                              if(index == 0){
                              }else(){
                              };
                            },
                          );
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(16)),
                      height: MediaQuery.of(context).size.height/7, width: MediaQuery.of(context).size.width / 2.4,
                      padding: EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/png/money-add.png", height: 40, width: 40,),
                          Text("5000", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),),
                          Text("Total orders", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999)),)
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(border: Border.all(color: Colors.black26), borderRadius: BorderRadius.circular(16)),
                      height: MediaQuery.of(context).size.height/7, width: MediaQuery.of(context).size.width / 2.4,
                      padding: EdgeInsets.all(10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset("assets/png/money-forbidden.png", height: 40, width: 40,),
                          Text("50", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),),
                          Text("Canceled orders", style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Color(0xff999999)),),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50,),
              ],
            ),
          ),
        )
    );
  }
}
