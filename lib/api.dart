import 'package:dio/dio.dart';

class Api{
  static Future<Map> searchByName(String text) async {
    try {
      Response response = await Dio().get(
        'https://api.scryfall.com/cards/search?q=$text',
        options: Options(
          headers: {
            'User-Agent': 'MTGExampleApp/1.0',
            'Accept': 'application/json'
          }
        )
      );

      return response.data;
    }
    on DioException {
      return {
        'object': 'error',
        'status': 404,
        'message': 'Not Found'
      };
    }
  }

  static Future<Map> searchById(String id) async {
    try {
      Response response = await Dio().get(
        'https://api.scryfall.com/cards/$id',
        options: Options(
          headers: {
            'User-Agent': 'MTGExampleApp/1.0',
            'Accept': 'application/json'
          }
        )
      );

      return response.data;
    }
    on DioException {
      return {
        'object': 'error',
        'status': 404,
        'message': 'Not Found'
      };
    }
  }

  static Future<Map> searchRulings(String cardId) async {
    try {
      Response response = await Dio().get(
        'https://api.scryfall.com/cards/$cardId/rulings',
        options: Options(
          headers: {
            'User-Agent': 'MTGExampleApp/1.0',
            'Accept': 'application/json'
          }
        )
      );

      return response.data;
    }
    on DioException {
      return {
        'object': 'error',
        'status': 404,
        'message': 'Not Found'
      };
    }
  }
}