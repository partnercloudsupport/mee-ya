import 'package:medical_app/data/network/user_repository.dart';
import 'package:medical_app/data/prefs/prefs_repository.dart';
import 'package:medical_app/redux/app/app_action.dart';
import 'package:medical_app/redux/app/app_state.dart';
import 'package:medical_app/redux/auth/auth_action.dart';
import 'package:medical_app/redux/login/login_action.dart';
import 'package:medical_app/redux/medicine_list/medicine_list_action.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return [
    new TypedMiddleware<AppState, InitAppAction>(
      _initApp(userRepository, sharedPrefRepository),
    ),
  ];
}

Middleware<AppState> _initApp(
  UserRepository userRepository,
  SharedPreferencesRepository sharedPrefRepository,
) {
  return (Store store, action, NextDispatcher next) async {
    if (action is InitAppAction) {
      try {
        var userId = await sharedPrefRepository.getUser();

        if (userId != null) {
          next(ShowSilentLoadingAction());
          var user = await userRepository.loginById(userId);
          next(HideSilentLoadingAction());
          next(SuccessLoginAction(user));
        }
      } catch (error) {
        print(error);
        next(HideSilentLoadingAction());
      }
      next(action);
    }
  };
}