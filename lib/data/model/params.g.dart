// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse _$ApiResponseFromJson(Map<String, dynamic> json) => ApiResponse(
      error: json['error'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ApiResponseToJson(ApiResponse instance) =>
    <String, dynamic>{
      'error': instance.error,
      'message': instance.message,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: json['id'] as String,
      field: (json['field'] as List<dynamic>).map((e) => e as String).toList(),
      start: Point.fromJson(json['start'] as Map<String, dynamic>),
      end: Point.fromJson(json['end'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'field': instance.field,
      'start': instance.start,
      'end': instance.end,
    };

Point _$PointFromJson(Map<String, dynamic> json) => Point(
      x: (json['x'] as num).toInt(),
      y: (json['y'] as num).toInt(),
    );

Map<String, dynamic> _$PointToJson(Point instance) => <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
    };
