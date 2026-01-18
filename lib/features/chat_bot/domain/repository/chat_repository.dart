import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_request.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/features/chat_bot/presentation/bloc/chat_state.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatResponse>> sendMessage(ChatRequest request);
  Future<Either<Failure, List<ChatUiMessage>>> getHistory({String? sessionId});
  Future<Either<Failure, bool>> deleteHistory({String? sessionId});
}
