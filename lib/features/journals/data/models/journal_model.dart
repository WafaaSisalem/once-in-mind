import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:onceinmind/core/constants/app_keys.dart';
import 'package:onceinmind/features/location/data/models/location_model.dart';

class JournalModel extends Equatable {
  JournalModel({
    required this.id,
    required this.content,
    required this.date,
    required this.isLocked,
    required this.location,
    this.weather = '',
    this.imagesUrls = const [],
    this.status = '',
    this.signedUrls,
  });

  final String id; //the id is datetime.now
  final String content;
  final DateTime date;
  final bool isLocked;
  final String weather;
  final LocationModel? location;
  final List<dynamic> imagesUrls;
  final String status;
  List<String>? signedUrls;

  // get formatedDate {
  //   return DateFormat(AppStrings.dateFormat).format(date);
  //February 11, 2021. Thu. 03:30 PM
  // }

  toMap() {
    return {
      AppKeys.id: id,
      AppKeys.content: content,
      AppKeys.date: date,
      AppKeys.isLocked: isLocked ? 1 : 0,
      AppKeys.location: location == null ? {} : location!.toMap(),
      AppKeys.imageUrl: imagesUrls,
      AppKeys.status: status,
      AppKeys.weather: weather,
    };
  }

  JournalModel.fromMap(map)
    : id = map[AppKeys.id],
      content = map[AppKeys.content],
      isLocked = map[AppKeys.isLocked] == 1 ? true : false,
      location = LocationModel.fromMap(
        map[AppKeys.location] as Map<String, dynamic>,
      ),
      date = (map[AppKeys.date] is Timestamp)
          ? (map[AppKeys.date] as Timestamp).toDate()
          : map[AppKeys.date],
      imagesUrls = map[AppKeys.imageUrl],
      weather = map[AppKeys.weather],
      status = map[AppKeys.status];

  @override
  List<Object?> get props => [
    content,
    date,
    location,
    status,
    imagesUrls,
    signedUrls,
  ];

  JournalModel copyWith({
    String? content,
    DateTime? date,
    bool? isLocked,
    LocationModel? location,
    String? weather,
    List<dynamic>? imagesUrls,
    String? status,
    List<String>? signedUrls,
  }) {
    return JournalModel(
      id: id,
      content: content ?? this.content,
      date: date ?? this.date,
      isLocked: isLocked ?? this.isLocked,
      location: location ?? this.location,
      weather: weather ?? this.weather,
      imagesUrls: imagesUrls ?? this.imagesUrls,
      status: status ?? this.status,
      signedUrls: signedUrls ?? this.signedUrls,
    );
  }
}
