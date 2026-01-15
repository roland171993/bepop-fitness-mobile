import 'package:bepop_fitness/models/pagination_model.dart';

class ScheduledResponse {
  Pagination? pagination;
  List<ScheduledModelData>? data;

  ScheduledResponse({this.pagination, this.data});

  ScheduledResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <ScheduledModelData>[];
      json['data'].forEach((v) {
        data!.add(new ScheduledModelData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduledModelData {
  int? id;
  String? className;
  int? workoutId;
  String? workout;
  String? workoutTitle;
  String? workoutType;
  String? startDate;
  String? endDate;
  String? startTime;
  String? endTime;
  String? name;
  String? link;
  String? isPaid;
  int? price;
  int? isClassSchedulePlan;
  String? createdAt;
  String? updatedAt;

  ScheduledModelData(
      {this.id,
      this.className,
      this.workoutId,
      this.workout,
      this.workoutTitle,
      this.workoutType,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.name,
      this.link,
      this.isPaid,
      this.price,
      this.isClassSchedulePlan,
      this.createdAt,
      this.updatedAt});

  ScheduledModelData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    className = json['class_name'];
    workoutId = json['workout_id'];
    workout = json['workout'];
    workoutTitle = json['workout_title'];
    workoutType = json['workout_type'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    name = json['name'];
    link = json['link'];
    isPaid = json['is_paid'];
    price = json['price'];
    isClassSchedulePlan = json['is_class_schedule_plan'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['class_name'] = this.className;
    data['workout_id'] = this.workoutId;
    data['workout'] = this.workout;
    data['workout_title'] = this.workoutTitle;
    data['workout_type'] = this.workoutType;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['start_time'] = this.startTime;
    data['end_time'] = this.endTime;
    data['name'] = this.name;
    data['link'] = this.link;
    data['is_paid'] = this.isPaid;
    data['price'] = this.price;
    data['is_class_schedule_plan'] = this.isClassSchedulePlan;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
