import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationRepository _notificationRepository;
  final AuthBloc _authBloc;

  StreamSubscription<List<Future<Notif?>>>? _notificationsSubscription;

  NotificationsBloc({
    required NotificationRepository notificationRepository,
    required AuthBloc authBloc,
  })  : _notificationRepository = notificationRepository,
        _authBloc = authBloc,
        super(NotificationsState.initial()) {
    on<NotificationsUpdateNotifications>(
        _mapNotificationsUpdateNotificationsToState);

    _notificationsSubscription?.cancel();
    _notificationsSubscription = _notificationRepository
        .getUserNotifications(userId: _authBloc.state.user!.uid)
        .listen((notifications) async {
      final allNotifications = await Future.wait(notifications);
      add(NotificationsUpdateNotifications(notifications: allNotifications));
    });
  }

  Future<void> _mapNotificationsUpdateNotificationsToState(
    NotificationsUpdateNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(state.copyWith(
      notifications: event.notifications,
      status: NotificationsStatus.loaded,
    ));
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
}
