import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/app/data/health_state.dart';
import 'package:getx/app/module/home_module/home_controller.dart';
import 'package:health/health.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height-35,
        child:(controller.datastate.value == AppState.DATA_NOT_FETCHED) ?
        Center(
          child: CircularProgressIndicator(
          ),
        ):GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.healthDataList.length,
          itemBuilder: (context, int index) {
            return Card(child: _buildHealthTypeWidgets(
                controller.healthDataList[index].unit.name,
                controller.healthDataList[index]));
          },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
        ),
        ),
      ),
    );
  }

  _buildHealthTypeWidgets(String name, HealthDataPoint healthDataList) {
    if (name.toUpperCase() == "MINUTES") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm,
            color: Colors.lightBlueAccent,
            size: 80,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Sleep Time"),
          SizedBox(
            height: 10,
          ),
          Text("${controller.durationToString(healthDataList.value.toInt())}")
        ],
      );
    } else if (name.toUpperCase() == "LITER") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.water_drop,
            size: 80,
            color: Colors.lightBlueAccent,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Water Intake ${name.capitalize}"),
          SizedBox(
            height: 10,
          ),
          Text("${healthDataList.value.toStringAsFixed(2)} L"),
        ],
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_walk,
            size: 80,
            color: Colors.lightBlueAccent,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Step ${name.capitalize}"),
          SizedBox(
            height: 10,
          ),
          Text("${controller.convertValue(healthDataList.value.toString())}"),
        ],
      );
    }
  }
}
