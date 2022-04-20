import 'dart:ffi';

import 'package:get/get.dart';
import 'package:health/health.dart';

import '../../data/health_state.dart';

class HomeController extends GetxController
{
  List<HealthDataPoint> healthDataList = [];
  var healthResult = <List>[].obs;
  var datastate = AppState.DATA_NOT_FETCHED.obs;
  Rx<int> _nofSteps = 0.obs;
  Rx<int> _asleepTime =0.obs;
  double _mgdl = 10.0;
  final types = [
    HealthDataType.STEPS,
    HealthDataType.WEIGHT,
    HealthDataType.HEIGHT,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.WATER,
    HealthDataType.SLEEP_ASLEEP
    // Uncomment this line on iOS - only available on iOS
    // HealthDataType.DISTANCE_WALKING_RUNNING,
  ]; // with coresponsing permissions
  final permissions = [
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
    HealthDataAccess.READ,
  ];

  // create a HealthFactory for use in the app
  HealthFactory health = HealthFactory();

    @override
  void onInit() {
    // TODO: implement onInit
      getHealthFeatchData();
      // define the types to get

    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  Future getHealthFeatchData() async
  {
    var healthJsonData;

    // get data within the last 24 hours
    final now = DateTime.now();
    final yesterday = now.subtract(Duration(days: 1));
    // requesting access to the data types before reading them
    // note that strictly speaking, the [permissions] are not
    // needed, since we only want READ access.
    bool requested =
    await health.requestAuthorization(types, permissions: permissions);

    if (requested) {
      healthDataList.clear();
      try {
        var jsonData;
        // fetch health data
        List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(yesterday, now, types);
        // save all the new data points (only the first 100)
        for(var data in healthData){
          if(data.unitString.contains("COUNT")){
            jsonData ={
              "unit":data.unitString,
              "value":data.value.floor() + data.value.floor()
            };
          }else if(data.unitString == "LITER"){
            jsonData ={
              "unit":data.unitString,
              "value":data.value.floor() + data.value.floor()
            };
          }else if(data.unitString == "MINUTES"){
            jsonData ={
              "unit":data.unitString,
              "value":data.value.floor() + data.value.floor()
            };
          }
        }
        healthDataList.addAll((healthData.length < 100) ? healthData : healthData.sublist(0, 100));
      } catch (error) {
        print("Exception in getHealthDataFromTypes: $error");
      }

      // filter out duplicates
      healthDataList = HealthFactory.removeDuplicates(healthDataList).toList();
      // print the results
      healthDataList.forEach((x) => {
        // healthJsonData = {
        //   "type":x.unit.toString(),
        //   "value"x.value.toString()
        // },
        // healthResult.add(healthJsonData),
        printInfo(info: "Health Data ${x.value}"),

      });
      // update the UI to display the results
        datastate.value = healthDataList.isEmpty ? AppState.NO_DATA : AppState.DATA_READY;
      print(datastate.value);
    } else {
      print("Authorization not granted");
      datastate.value = AppState.DATA_NOT_FETCHED;
    }
   //  fetchStepData();
  }

  getResultData()
  {

  }

  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')} H';
  }

   num convertValue(value){
   var data = double.parse(value).floor();
     return data;
   }
}