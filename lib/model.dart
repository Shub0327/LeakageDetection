
class SensorData{

  String? flow;
  String? temp;
  String? tds;

  SensorData({this.flow, this.temp,this.tds});
  SensorData.fromJson(Map<dynamic,dynamic> json){
    flow=json["flow_rate"].toString();
    temp=json["tds_value"].toString();
    tds=json["temperature"].toString();

  }
}