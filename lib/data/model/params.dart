import 'package:json_annotation/json_annotation.dart';

part 'params.g.dart';

@JsonSerializable()
class ApiResponse {
  ApiResponse({
    required this.error,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseFromJson(json);
  final bool error;
  final String message;
  final List<Data> data;
  Map<String, dynamic> toJson() => _$ApiResponseToJson(this);
}

@JsonSerializable()
class Data {
  Data({
    required this.id,
    required this.field,
    required this.start,
    required this.end,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  final String id;
  final List<String> field;
  final Point start;
  final Point end;
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Point {
  Point({
    required this.x,
    required this.y,
  });

  factory Point.fromJson(Map<String, dynamic> json) => _$PointFromJson(json);
  final int x;
  final int y;
  Map<String, dynamic> toJson() => _$PointToJson(this);
}
