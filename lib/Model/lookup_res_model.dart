class LookupResModel {
  String? cityName;
  String? cityCode;
  String? lookupUrl;
  String? buttonText;
  List<String>? tips;

  LookupResModel({
    this.cityName,
    this.cityCode,
    this.lookupUrl,
    this.buttonText,
    this.tips,
  });

  LookupResModel.fromJson(Map<String, dynamic> json) {
    cityName = json['city_name'];
    cityCode = json['city_code'];
    lookupUrl = json['lookup_url'];
    buttonText = json['button_text'];
    tips = json['tips'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['city_name'] = cityName;
    data['city_code'] = cityCode;
    data['lookup_url'] = lookupUrl;
    data['button_text'] = buttonText;
    data['tips'] = tips;
    return data;
  }
}
