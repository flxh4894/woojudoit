import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:woojudoit/src/controller/home_controller.dart';
import 'package:woojudoit/src/model/EatInfo.dart';
import 'package:woojudoit/src/model/bar.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomeController _controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appbar(),
      body: _body(),
    );
  }

  AppBar _appbar() {
    return AppBar(
      backgroundColor: Colors.deepPurpleAccent,
      title: Row(
        children: [
          Image.asset(
            "assets/logo/woojoodoit.png",
            width: 100,
          )
        ],
      ),
      centerTitle: false,
      elevation: 0,
    );
  }

  Container _body() {
    return Container(
      width: Get.size.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (EatInfo eat in _controller.eatInfoList) _eatTile(eat),
            _chartArea(),
          ],
        ),
      ),
    );
  }

  Container _chartArea() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('다량영양소', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          for (BarData nutrient in _controller.nutrientList) _barChart(nutrient.name, nutrient.percent, nutrient.color),
          Container(
            height: 300,
            width: 300,
            child: Obx(
              () => PieChart(PieChartData(
                  pieTouchData: PieTouchData(touchCallback: (response) {
                    final desiredTouch =
                        response.touchInput is! PointerExitEvent && response.touchInput is! PointerUpEvent;
                    if (desiredTouch && response.touchedSection != null) {
                      _controller.touchIndex(response.touchedSection!.touchedSectionIndex);
                    } else {
                      _controller.touchIndex(-1);
                    }
                  }),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  centerSpaceRadius: 0,
                  sections: _showingSections())),
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    int length = _controller.pieData.length;
    return List.generate(length, (index) {
      final size = Get.size.width / 2;
      final isTouched = index == _controller.touchIndex.value;
      final fontSize = isTouched ? 22.0 : 16.0;
      final radius = isTouched ? size * 0.8 : size * 0.7;

      var data = _controller.pieData[index];
      return PieChartSectionData(
          color: data.color,
          value: data.percent,
          title: '${data.name} \n${data.percent}%',
          radius: radius,
          titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold));
    });
  }

  Container _barChart(String title, double value, int color) {
    double width = Get.size.width * 0.75;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    color: Colors.grey.withOpacity(0.1),
                    width: width,
                    height: 30,
                  ),
                  TweenAnimationBuilder(
                    duration: Duration(seconds: 2),
                    tween: Tween<double>(begin: 0, end: value),
                    builder: (BuildContext context, double value, Widget? child) {
                      return Container(
                        color: Color(color),
                        width: width * (value / 100),
                        height: 30,
                        padding: EdgeInsets.only(right: 5),
                        alignment: Alignment.centerRight,
                        child: Text('${value.toInt()}', style: TextStyle(color: Colors.white)),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(width: 10),
              Text('100%')
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Container _eatTile(EatInfo eat) {
    int index = _controller.eatInfoList.indexOf(eat);
    bool last = false;
    if (index == _controller.eatInfoList.length - 1) last = true;

    return Container(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 제목
          Container(
            width: Get.size.width * 0.3,
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
                    right: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
                    bottom: last ? BorderSide(color: Colors.black.withOpacity(0.2), width: 1) : BorderSide.none)),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(eat.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                SizedBox(height: 20),
                Row(
                  children: [
                    Text('${eat.totalKcal}',
                        style: TextStyle(fontSize: 18, color: Color(0xff01BB84), fontWeight: FontWeight.bold)),
                    Text(' kcal'),
                  ],
                ),
              ],
            ),
          ),
          // 내용
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: DottedDecoration(
                    shape: Shape.line,
                    dash: [3],
                    linePosition: LinePosition.right,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(color: Colors.black.withOpacity(0.2), width: 1),
                          bottom: last ? BorderSide(color: Colors.black.withOpacity(0.2), width: 1) : BorderSide.none)),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(eat.food, style: TextStyle(fontSize: 18)),
                          Obx(
                            () => GestureDetector(
                                onTap: () {
                                  _controller.eatInfoList[index].favorite = !_controller.eatInfoList[index].favorite;
                                  _controller.eatInfoList.refresh();
                                },
                                child: _controller.eatInfoList[index].favorite
                                    ? Icon(
                                        Icons.favorite,
                                        color: Colors.pink,
                                      )
                                    : Icon(
                                        Icons.favorite_outline,
                                        color: Colors.pink,
                                      )),
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      _infoRow('종류', eat.category),
                      _infoRow('재료', eat.ingredient),
                      _infoRow('정량', '${eat.gram}g'),
                      _infoRow('칼로리', '${eat.kcal}kal'),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoRow(String title, String text) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.black.withOpacity(0.5))),
          Text(text, style: TextStyle(color: Colors.black.withOpacity(0.5))),
        ],
      ),
      SizedBox(height: 5)
    ]);
  }
}
