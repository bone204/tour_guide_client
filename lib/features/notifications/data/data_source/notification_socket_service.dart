import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:tour_guide_app/common/constants/app_urls.constant.dart';
import 'package:tour_guide_app/features/auth/data/data_sources/local/auth_local_service.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/core/utils/jwt_helper.dart';

class NotificationSocketService {
  IO.Socket? _socket;
  final AuthLocalService authLocalService = sl<AuthLocalService>();

  Future<void> initSocket() async {
    final token = await authLocalService.getAccessToken();
    if (token == null) return;

    _socket = IO.io(
      '${ApiUrls.baseURL}/notifications', // Connect to /notifications namespace
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .build(),
    );

    _socket?.onConnect((_) {
      print('Connected to Notification Socket');
      // Get user ID from token or local storage if needed to join specific room
      // Server-side gateway handleJoinRoom uses 'join' event
      _joinRoom(token);
    });

    _socket?.onDisconnect((_) {
      print('Disconnected from Notification Socket');
    });

    _socket?.onConnectError((data) {
      print('Notification Socket Connection Error: $data');
    });
  }

  void _joinRoom(String token) async {
    try {
      Map<String, dynamic> decodedToken = JwtHelper.decode(token);
      final userId = decodedToken['id'] ?? decodedToken['sub'];
      if (userId != null) {
        _socket?.emit('join', {'userId': userId});
        print('Joined room for user $userId');
      }
    } catch (e) {
      print('Error decoding token or joining room: $e');
    }
  }

  void listenToNotifications(Function(dynamic) onNotificationReceived) {
    _socket?.on('notification', (data) {
      print('Received notification event: $data');
      onNotificationReceived(data);
    });
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
