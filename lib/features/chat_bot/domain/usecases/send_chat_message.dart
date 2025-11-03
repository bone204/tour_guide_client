import 'package:dartz/dartz.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/usecases/usecase.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_request.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/features/chat_bot/domain/repository/chat_repository.dart';
import 'package:tour_guide_app/service_locator.dart';

class SendChatMessageUseCase
    implements UseCase<Either<Failure, ChatResponse>, ChatRequest> {
  @override
  Future<Either<Failure, ChatResponse>> call(ChatRequest params) async {
    return sl<ChatRepository>().sendMessage(params);
  }
}
