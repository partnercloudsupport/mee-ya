import 'package:medical_app/data/network/notification_repository.dart';
import 'package:medical_app/redux/app/app_state.dart';
import 'package:medical_app/redux/notification_list/notification_list_action.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createNotificationListMiddleware(
  NotificationRepository notificationRepository,
) {
  return [
    new TypedMiddleware<AppState, FetchNotifications>(
      _fetchNotifications(notificationRepository),
    ),
    new TypedMiddleware<AppState, DeleteNotification>(
      _deleteNotification(notificationRepository),
    ),
  ];
}

Middleware<AppState> _fetchNotifications(
  NotificationRepository notificationRepository,
) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    if (action is FetchNotifications) {
      next(ShowNotificationLoadingAction());
      final token = store.state.token;

      try {
        final medicinesWithNotifications = await notificationRepository.fetchMedicineWithNotifications(token);
        store.dispatch(new FetchNotificationsSuccess(medicinesWithNotifications));
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}

Middleware<AppState> _deleteNotification(
  NotificationRepository notificationRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is DeleteNotification) {
      final token = store.state.token;

      try {
        await notificationRepository.deleteNotification(action.notificationId, token);
        store.dispatch(FetchNotifications());
      } catch (error) {
        print(error);
      }

      next(action);
    }
  };
}
