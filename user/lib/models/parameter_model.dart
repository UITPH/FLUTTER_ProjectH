class ParameterModel {
  final int isMaintainance;
  final String maintainanceInfo;

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
}
