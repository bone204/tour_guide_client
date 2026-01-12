import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tour_guide_app/core/usecases/no_params.dart';
import 'package:tour_guide_app/features/notifications/data/data_source/notification_socket_service.dart';
import 'package:tour_guide_app/features/notifications/data/models/notification.dart';
import 'package:tour_guide_app/features/notifications/domain/usecases/get_my_notifications.dart';
import 'package:tour_guide_app/features/notifications/domain/usecases/mark_notification_read.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final GetMyNotificationsUseCase getMyNotificationsUseCase;
  final MarkNotificationReadUseCase markNotificationReadUseCase;
  final NotificationSocketService socketService;
  Timer? _pollingTimer;

  NotificationCubit({
    required this.getMyNotificationsUseCase,
    required this.markNotificationReadUseCase,
    required this.socketService,
  }) : super(NotificationInitial()) {
    _initSocket();
    // Poll notifications every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!isClosed) {
        getNotifications();
      }
    });
  }

  Future<void> _initSocket() async {
    await socketService.initSocket();
    getNotifications(); // Fetch initial notifications
    socketService.listenToNotifications((data) {
      if (isClosed) return;
      // Refresh notifications when a new one arrives
      getNotifications();

      // Trigger event to refresh rental lists/details if related
      // Assuming all notifications might be relevant or we just trigger refresh safely
      eventBus.fire(RentalSocketNotificationReceivedEvent());
    });
  }

  Future<void> getNotifications() async {
    if (isClosed) return;

    // Don't emit loading if we already have data (silent update)
    if (state is! NotificationLoaded) {
      emit(NotificationLoading());
    }

    final result = await getMyNotificationsUseCase(NoParams());

    if (isClosed) return;

    result.fold((failure) => emit(NotificationError(failure.message)), (
      notifications,
    ) {
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(
        NotificationLoaded(
          notifications: notifications,
          unreadCount: unreadCount,
        ),
      );
    });
  }

  Future<void> markAsRead(int id) async {
    if (state is! NotificationLoaded || isClosed) return;

    final currentState = state as NotificationLoaded;
    final notifications = currentState.notifications;
    final index = notifications.indexWhere((n) => n.id == id);

    if (index == -1) return;

    // Optimistic update
    final updatedNotification = Notification(
      id: notifications[index].id,
      title: notifications[index].title,
      body: notifications[index].body,
      type: notifications[index].type,
      data: notifications[index].data,
      isRead: true, // Mark as read
      createdAt: notifications[index].createdAt,
      updatedAt: notifications[index].updatedAt,
    );

    final updatedList = List<Notification>.from(notifications);
    updatedList[index] = updatedNotification;
    final unreadCount = updatedList.where((n) => !n.isRead).length;

    emit(
      NotificationLoaded(notifications: updatedList, unreadCount: unreadCount),
    );

    final result = await markNotificationReadUseCase(
      MarkNotificationReadParams(id: id),
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        // Revert on failure if needed, or just show error
        // For now, we keep optimistic state or refresh
        getNotifications();
      },
      (success) {
        // Confirmed
      },
    );
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    socketService.disconnect();
    return super.close();
  }
}
