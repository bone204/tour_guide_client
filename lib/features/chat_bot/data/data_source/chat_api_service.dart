import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/core/error/failures.dart';
import 'package:tour_guide_app/core/network/dio_client.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_request.dart';
import 'package:tour_guide_app/features/chat_bot/data/models/chat_response.dart';
import 'package:tour_guide_app/service_locator.dart';

abstract class ChatApiService {
  Future<Either<Failure, ChatResponse>> sendMessage(ChatRequest request);
}

class ChatApiServiceImpl extends ChatApiService {
  @override
  Future<Either<Failure, ChatResponse>> sendMessage(ChatRequest request) async {
    try {
      final response = await sl<DioClient>().post(
        ApiUrls.chatbot,
        data: request.toJson(),
      );

      final data = response.data;
      if (data is! Map<String, dynamic>) {
        return const Left(
          ServerFailure(message: 'Invalid chat response format from server'),
        );
      }

      final chatResponse = ChatResponse.fromJson(data);
      return Right(chatResponse);
    } on DioException catch (e) {
      final data = e.response?.data;
      String message = 'Unknown error';
      if (data is Map<String, dynamic>) {
        message = data['message']?.toString() ?? message;
      } else if (data is String) {
        message = data;
      }

      return Left(
        ServerFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
