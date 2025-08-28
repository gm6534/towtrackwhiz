class AddVehicleReqModel {
  String? licensePlate;
  String? make;
  String? model;
  String? year;
  String? color;
  String? registrationState;

  AddVehicleReqModel({
    this.licensePlate,
    this.make,
    this.model,
    this.year,
    this.color,
    this.registrationState,
  });

  AddVehicleReqModel.fromJson(Map<String, dynamic> json) {
    licensePlate = json['license_plate'];
    make = json['make'];
    model = json['model'];
    year = json['year'];
    color = json['color'];
    registrationState = json['registration_state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['license_plate'] = licensePlate;
    data['make'] = make;
    data['model'] = model;
    data['year'] = year;
    data['color'] = color;
    data['registration_state'] = registrationState;
    return data;
  }
}
