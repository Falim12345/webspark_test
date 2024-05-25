import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';
import 'package:webspark_test/data/repo/sharedpref_rep_imp.dart';

import '../../domain/repo/webspark_rep.dart';
import '../model/params.dart';

class WebsparkRepImp implements WebsparkRepo {
  final SharedpreferencesRepImp _sharedpreferencesRepImp =
      SharedpreferencesRepImp();
  Dio? _dio;
  final talker = Talker();

  Future<void> initializeDio() async {
    final baseUrl = await _sharedpreferencesRepImp.loadUrl();
    if (baseUrl != null && baseUrl.isNotEmpty) {
      _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
        ),
      );
    } else {
      talker.error('Base URL not found in shared preferences');
    }
  }

  @override
  Future<ApiResponse?> getInputParameters() async {
    if (_dio == null) {
      await initializeDio();
    }
    try {
      final response = await _dio!.get(
        '/',
        options: Options(
          headers: {
            'Host': 'flutter.webspark.dev',
          },
        ),
      );
      final responseModel =
          ApiResponse.fromJson(response.data as Map<String, dynamic>);
      return responseModel;
    } catch (e) {
      if (e is DioException) {
        talker.error('Dio error: ${e.message}', e);
      } else {
        talker.error('Unexpected error: $e', e);
      }
    }
    return null;
  }

  List<Map<String, dynamic>> createPayload(List<List<List<int>>> paths) {
    return paths.map((path) {
      final steps = path.map((point) {
        return {'x': point[0].toString(), 'y': point[1].toString()};
      }).toList();

      final pathStr =
          path.map((point) => '(${point[0]},${point[1]})').join('->');

      return {
        'id': _generateUuid(),
        'result': {
          'steps': steps,
          'path': pathStr,
        },
      };
    }).toList();
  }

  String _generateUuid() {
    return const Uuid().v4();
  }

  @override
  Future<void> sendAnswers(List<List<List<int>>> paths) async {
    if (_dio == null) {
      await initializeDio();
    }
    try {
      final payload = createPayload(paths);
      final response = await _dio!.post(
        'https://flutter.webspark.dev/flutter/api',
        data: jsonEncode(payload),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Host': 'flutter.webspark.dev',
          },
        ),
      );

      if (response.statusCode == 200) {
        talker.info('Data sent successfully');
      } else {
        talker.error('Failed to send data: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        talker.error('Dio error: ${e.message}', e);
      } else {
        talker.error('Unexpected error: $e', e);
      }
    }
  }
}
