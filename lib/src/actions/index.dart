import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:movie_app/src/models/index.dart';

part 'index.freezed.dart';
part 'login.dart';
part 'getmovies.dart';
part 'get_current_user.dart';
part 'create_user.dart';
part 'update_favorites.dart';
part 'logout.dart';

abstract class AppAction {}

abstract class ErrorAction implements AppAction {
  Object get error;

  StackTrace get stackTrace;
}

abstract class UserAction extends AppAction {
  AppUser? get user;
}

abstract class PendingAction {
  String get pendingId;
}

abstract class ActionStart implements PendingAction {}

abstract class ActionDone implements PendingAction {}

typedef ActionResult = void Function(AppAction action);
