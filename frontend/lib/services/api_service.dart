import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';
import 'auth_service.dart';

/// Change this to your deployed backend URL, e.g.
/// 'https://cbse-paper-backend.onrender.com'
class ApiConfig {
  static const String baseUrl = 'https://cbse-paper-backend.onrender.com';
  // For local testing against `uvicorn app.main:app` on your machine, use:
  // static const String baseUrl = 'http://10.0.2.2:8000'; // Android emulator
  // static const String baseUrl = 'http://localhost:8000'; // iOS simulator / web
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class ApiService {
  final AuthService authService;
  ApiService(this.authService);

  Uri _u(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('${ApiConfig.baseUrl}$path').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, v.toString())),
    );
  }

  Map<String, String> _headers({bool auth = false, bool json = true}) {
    final headers = <String, String>{};
    if (json) headers['Content-Type'] = 'application/json';
    if (auth && authService.token != null) {
      headers['Authorization'] = 'Bearer ${authService.token}';
    }
    return headers;
  }

  void _checkOk(http.Response res) {
    if (res.statusCode >= 200 && res.statusCode < 300) return;
    String detail = 'Request failed (${res.statusCode})';
    try {
      final body = jsonDecode(res.body);
      if (body is Map && body['detail'] != null) detail = body['detail'].toString();
    } catch (_) {}
    throw ApiException(detail);
  }

  // ---------------- AUTH ----------------

  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final res = await http.post(
      _u('/auth/register'),
      headers: _headers(),
      body: jsonEncode({'name': name, 'email': email, 'password': password, 'role': role}),
    );
    _checkOk(res);
    return AppUser.fromJson(jsonDecode(res.body));
  }

  Future<AppUser> login({required String email, required String password}) async {
    final res = await http.post(
      _u('/auth/login'),
      headers: _headers(),
      body: jsonEncode({'email': email, 'password': password}),
    );
    _checkOk(res);
    final data = jsonDecode(res.body);
    await authService.saveToken(data['access_token']);
    return AppUser.fromJson(data['user']);
  }

  // ---------------- FIXED PAPERS ----------------

  Future<List<FixedPaper>> listFixedPapers({String? subject, String? difficulty, int? marks}) async {
    final query = <String, dynamic>{};
    if (subject != null) query['subject'] = subject;
    if (difficulty != null) query['difficulty'] = difficulty;
    if (marks != null) query['marks'] = marks;
    final res = await http.get(_u('/papers/list', query), headers: _headers());
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => FixedPaper.fromJson(e)).toList();
  }

  /// Returns the direct download URL for the question paper (no auth required).
  String paperUrl({required String subject, required String difficulty, required int marks}) {
    return '${ApiConfig.baseUrl}/papers/fixed/$subject/$difficulty/$marks';
  }

  /// Returns the direct download URL for the answer key.
  /// Note: this endpoint requires a Bearer token, so it can't be opened directly
  /// in a browser without auth; use `downloadAnswerKeyBytes` instead if you need
  /// the raw bytes to save/share from within the app.
  String answerKeyUrl({required String subject, required String difficulty, required int marks}) {
    return '${ApiConfig.baseUrl}/papers/fixed/$subject/$difficulty/$marks/key';
  }

  Future<List<int>> downloadAnswerKeyBytes({
    required String subject,
    required String difficulty,
    required int marks,
  }) async {
    final res = await http.get(
      Uri.parse(answerKeyUrl(subject: subject, difficulty: difficulty, marks: marks)),
      headers: _headers(auth: true, json: false),
    );
    _checkOk(res);
    return res.bodyBytes;
  }

  // ---------------- QUESTION BANK ----------------

  Future<List<Question>> listQuestions({String? subject, String? chapter, String? difficulty}) async {
    final query = <String, dynamic>{};
    if (subject != null) query['subject'] = subject;
    if (chapter != null) query['chapter'] = chapter;
    if (difficulty != null) query['difficulty'] = difficulty;
    final res = await http.get(_u('/questions/', query), headers: _headers(auth: true));
    _checkOk(res);
    final List data = jsonDecode(res.body);
    return data.map((e) => Question.fromJson(e)).toList();
  }

  Future<Question> createQuestion(Question q) async {
    final res = await http.post(_u('/questions/'), headers: _headers(auth: true), body: jsonEncode(q.toJson()));
    _checkOk(res);
    return Question.fromJson(jsonDecode(res.body));
  }

  Future<Question> updateQuestion(int id, Question q) async {
    final res = await http.put(_u('/questions/$id'), headers: _headers(auth: true), body: jsonEncode(q.toJson()));
    _checkOk(res);
    return Question.fromJson(jsonDecode(res.body));
  }

  Future<void> deleteQuestion(int id) async {
    final res = await http.delete(_u('/questions/$id'), headers: _headers(auth: true));
    _checkOk(res);
  }
}
