import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/chat_bot/data/data_source/chat_api_service.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_request.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/features/chat_bot/domain/repository/chat_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class ChatRepositoryImpl extends ChatRepository {
  final _apiService = sl<ChatApiService>();

  @override
  Future<Either<Failure, ChatResponse>> sendMessage(ChatRequest request) async {
    return _apiService.sendMessage(request);
  }
}
