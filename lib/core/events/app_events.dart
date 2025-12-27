import 'dart:async';

// Event khi contract được đăng ký thành công
class ContractRegisteredEvent {
  final int? contractId;

  ContractRegisteredEvent({this.contractId});
}

// Event khi vehicle được thêm thành công
class VehicleAddedEvent {
  final int? vehicleId;

  VehicleAddedEvent({this.vehicleId});
}

// Event khi itinerary được tạo thành công
class CreateItinerarySuccessEvent {}

// Event when a stop is added
class StopAddedEvent {}

// Event when an itinerary is deleted
class ItineraryDeletedEvent {}

// Event when a stop is updated (e.g. media added)
class StopUpdatedEvent {
  final int stopId;
  StopUpdatedEvent(this.stopId);
}

// Event when user profile is updated
class ProfileUpdatedEvent {}

// Event when vehicle status is changed (enable/disable)
class VehicleStatusChangedEvent {
  final String licensePlate;
  VehicleStatusChangedEvent(this.licensePlate);
}

// Singleton EventBus
class AppEventBus {
  static final AppEventBus _instance = AppEventBus._internal();
  factory AppEventBus() => _instance;
  AppEventBus._internal();

  final StreamController<dynamic> _eventController =
      StreamController.broadcast();

  Stream<T> on<T>() {
    return _eventController.stream.where((event) => event is T).cast<T>();
  }

  void fire(dynamic event) {
    _eventController.add(event);
  }

  void dispose() {
    _eventController.close();
  }
}

// Global instance
final eventBus = AppEventBus();
