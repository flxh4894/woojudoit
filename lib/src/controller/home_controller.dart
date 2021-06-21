import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:woojudoit/src/model/EatInfo.dart';
import 'package:woojudoit/src/model/bar.dart';
import 'package:woojudoit/src/model/pie.dart';

class HomeController extends GetxController with SingleGetTickerProviderMixin{

  RxList<EatInfo> eatInfoList = <EatInfo>[
    EatInfo(
      title: "조식",
      totalKcal: 828,
      food: '율무밥',
      category: '밥류',
      ingredient: '흰쌀',
      gram: 210,
      kcal: 130,
      favorite: false
    ),
    EatInfo(
        title: "중식",
        totalKcal: 781,
        food: '열무보리비빔밥',
        category: '밥류',
        ingredient: '보리쌀',
        gram: 210,
        kcal: 130,
        favorite: false
    ),
    EatInfo(
        title: "석식",
        totalKcal: 724,
        food: '찹쌀땅콩밥',
        category: '밥류',
        ingredient: '찹쌀, 땅콩',
        gram: 210,
        kcal: 130,
        favorite: false
    )
  ].obs;

  List<BarData> nutrientList = <BarData>[
    BarData(name: '탄수화물', percent: 25, color: 0xff4C7FFD),
    BarData(name: '단백질', percent: 65, color: 0xff4A99F2),
    BarData(name: '지방', percent: 51, color: 0xff48B1E8),
    BarData(name: '총 식이섬유', percent: 24, color: 0xff46C7DF),
    BarData(name: '콜레스테롤', percent: 48, color: 0xff43E1D5),
    BarData(name: '총 포화 지방산', percent: 48, color: 0xff41F9CB),
  ];

  RxInt touchIndex = RxInt(-1);
  List<PieData> pieData = <PieData>[
    PieData(name: "단백질", percent: 35.85, color: Colors.deepPurpleAccent),
    PieData(name: "지방", percent: 35.85, color: Colors.lightBlueAccent),
    PieData(name: "탄수화물", percent: 28.30, color: Colors.amber),
  ];
}