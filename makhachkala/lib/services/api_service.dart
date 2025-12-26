import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category.dart';
import '../models/menu_item.dart';

class ApiService {
  final String base;
  
  ApiService(this.base);

  Uri _uri(String path, [Map<String, String>? queryParams]) {
    return Uri.parse(base + path).replace(queryParameters: queryParams);
  }

  // Headers для правильной работы с UTF-8 и кириллицей
  Map<String, String> get _headers => {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json; charset=utf-8',
    'Accept-Charset': 'utf-8',
  };

  // Правильное декодирование JSON с учетом разных кодировок
  dynamic _decodeJson(http.Response response) {
    // Сначала пробуем UTF-8 (самый распространенный вариант)
    try {
      final bodyString = utf8.decode(response.bodyBytes, allowMalformed: false);
      final decoded = jsonDecode(bodyString);
      return decoded;
    } catch (e) {
      print('UTF-8 decode failed, trying alternatives...');
    }
    
    // Если UTF-8 не сработал, пробуем другие кодировки
    final encodings = [
      () => utf8.decode(response.bodyBytes, allowMalformed: true),
      () => latin1.decode(response.bodyBytes),
      () => response.body, // Пробуем как есть
    ];
    
    for (var i = 0; i < encodings.length; i++) {
      try {
        final bodyString = encodings[i]();
        final decoded = jsonDecode(bodyString);
        print('Successfully decoded with encoding method $i');
        return decoded;
      } catch (e) {
        if (i == encodings.length - 1) {
          // Последняя попытка - выводим отладочную информацию
          print('All decode attempts failed. Last error: $e');
          print('Response Content-Type: ${response.headers['content-type']}');
          print('Response body bytes (first 100): ${response.bodyBytes.take(100).toList()}');
          print('Response body as string (first 300 chars): ${response.body.substring(0, response.body.length > 300 ? 300 : response.body.length)}');
          rethrow;
        }
      }
    }
    
    throw Exception('Failed to decode response');
  }

  Future<List<Category>> fetchCategories() async {
    try {
      final res = await http.get(
        _uri('/api/categories'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final decoded = _decodeJson(res);
        final list = decoded as List;
        return list.map((e) => Category.fromJson(e)).toList();
      }
      throw Exception('Failed to load categories: ${res.statusCode}');
    } catch (e) {
      print('Error fetching categories: $e');
      rethrow;
    }
  }

  Future<List<MenuItemModel>> fetchMenu({
    String? categoryId,
    int skip = 0,
    int limit = 100,
  }) async {
    try {
      final queryParams = <String, String>{
        'skip': skip.toString(),
        'limit': limit.toString(),
      };
      if (categoryId != null) {
        queryParams['category_id'] = categoryId;
      }
      final res = await http.get(
        _uri('/api/menu', queryParams),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        // Отладочная информация
        print('Response Content-Type: ${res.headers['content-type']}');
        print('Response body bytes (first 100): ${res.bodyBytes.take(100).toList()}');
        print('Response body string (first 200 chars): ${res.body.substring(0, res.body.length > 200 ? 200 : res.body.length)}');
        
        final decoded = _decodeJson(res);
        final list = decoded as List;
        
        // Проверяем первый элемент для отладки
        if (list.isNotEmpty) {
          print('First item decoded: ${list[0]}');
        }
        
        return list.map((e) => MenuItemModel.fromJson(e)).toList();
      }
      throw Exception('Failed to load menu: ${res.statusCode}');
    } catch (e) {
      print('Error fetching menu: $e');
      rethrow;
    }
  }

  Future<MenuItemModel> fetchItem(String id) async {
    try {
      final res = await http.get(
        _uri('/api/menu/$id'),
        headers: _headers,
      );
      if (res.statusCode == 200) {
        final decoded = _decodeJson(res);
        final json = decoded as Map<String, dynamic>;
        return MenuItemModel.fromJson(json);
      }
      throw Exception('Failed to load item: ${res.statusCode}');
    } catch (e) {
      print('Error fetching item: $e');
      rethrow;
    }
  }

  String fullImageUrl(String imagePath) {
    if (imagePath.isEmpty) return '';
    // If backend returns absolute URL already - return as is
    if (imagePath.startsWith('http')) return imagePath;
    // Join base origin + path
    final uri = Uri.parse(base);
    final origin = '${uri.scheme}://${uri.host}${uri.hasPort ? ':${uri.port}' : ''}';
    return origin + imagePath;
  }
}

