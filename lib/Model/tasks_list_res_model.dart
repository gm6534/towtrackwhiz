class TasksListResModel {
  bool? status;
  String? message;
  List<TaskModel>? taskModel;

  TasksListResModel({this.status, this.message, this.taskModel});

  TasksListResModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      taskModel = <TaskModel>[];
      json['data'].forEach((v) {
        taskModel?.add(TaskModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (taskModel != null) {
      data['data'] = taskModel?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TaskModel {
  int? id;
  String? taskNumber;
  String? clientName;
  String? contact;
  String? email;
  String? cleanerId;
  String? date;
  String? time;
  String? payAmount;
  String? city;
  dynamic countryId;
  String? location;
  String? lat;
  String? long;
  dynamic streetAddress;
  dynamic deletedAt;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<Notes>? notes;

  TaskModel({
    this.id,
    this.taskNumber,
    this.clientName,
    this.contact,
    this.email,
    this.cleanerId,
    this.date,
    this.time,
    this.payAmount,
    this.city,
    this.countryId,
    this.location,
    this.lat,
    this.long,
    this.streetAddress,
    this.deletedAt,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.notes,
  });

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taskNumber = json['task_number'];
    clientName = json['client_name'];
    contact = json['contact'];
    email = json['email'];
    cleanerId = json['cleaner_id'];
    date = json['date'];
    time = json['time'];
    payAmount = json['pay_amount'];
    city = json['city'];
    countryId = json['country_id']?.toString();
    location = json['location'];
    lat = json['lat'];
    long = json['long'];
    streetAddress = json['street_address']?.toString();
    deletedAt = json['deleted_at']?.toString();
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['notes'] != null) {
      notes = <Notes>[];
      json['notes'].forEach((v) {
        notes!.add(Notes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['task_number'] = taskNumber;
    data['client_name'] = clientName;
    data['contact'] = contact;
    data['email'] = email;
    data['cleaner_id'] = cleanerId;
    data['date'] = date;
    data['time'] = time;
    data['pay_amount'] = payAmount;
    data['city'] = city;
    data['country_id'] = countryId;
    data['location'] = location;
    data['lat'] = lat;
    data['long'] = long;
    data['street_address'] = streetAddress;
    data['deleted_at'] = deletedAt;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (notes != null) {
      data['notes'] = notes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notes {
  int? id;
  String? appointmentId;
  String? userId;
  String? type;
  String? note;
  String? createdAt;
  String? updatedAt;

  Notes({
    this.id,
    this.appointmentId,
    this.userId,
    this.type,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  Notes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appointmentId = json['appointment_id'];
    userId = json['user_id'];
    type = json['type'];
    note = json['note'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['appointment_id'] = appointmentId;
    data['user_id'] = userId;
    data['type'] = type;
    data['note'] = note;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
