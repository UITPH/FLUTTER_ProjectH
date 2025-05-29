class ParameterModel {
  int isMaintainance;
  String maintainanceInfo;

  ParameterModel({
    required this.isMaintainance,
    required this.maintainanceInfo,
  });

  factory ParameterModel.fromListMap(List<Map<String, dynamic>> list) {
    return ParameterModel(
      isMaintainance: int.parse(list[0]['value']),
      maintainanceInfo: list[1]['value'],
    );
  }

  List<Map<String, dynamic>> toListMap() {
    return [
      {'key': 'IS_MAINTAINANCE', 'value': isMaintainance.toString()},
      {'key': 'MAINTAINANCE_INFO', 'value': maintainanceInfo},
    ];
  }
}
