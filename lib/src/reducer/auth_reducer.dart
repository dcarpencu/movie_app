import 'package:movie_app/src/actions/index.dart';
import 'package:movie_app/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<AppState> authReducer = combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, LoginSuccessful>(_loginSuccessful),
  TypedReducer<AppState, GetCurrentUserSuccessful>(_getCurrentUserSuccessful),
  TypedReducer<AppState, CreateUserSuccessful>(_createUserSuccessful),
  TypedReducer<AppState, UpdateFavoriteStart>(_updateFavoriteStart),
  TypedReducer<AppState, UpdateFavoriteError>(_updateFavoriteError),
  TypedReducer<AppState, LogoutSuccessful>(_logoutSuccessful),
  TypedReducer<AppState, GetUserSuccessful>(_getUserSuccessful),
]);

AppState _loginSuccessful(AppState state, LoginSuccessful action) {
  return state.copyWith(user: action.user);
}

AppState _getCurrentUserSuccessful(AppState state, GetCurrentUserSuccessful action) {
  return state.copyWith(user: action.user);
}

AppState _createUserSuccessful(AppState state, CreateUserSuccessful action) {
  return state.copyWith(user: action.user);
}

AppState _updateFavoriteStart(AppState state, UpdateFavoriteStart action) {
  final List<int> favoriteMovies = <int>[...state.user!.favoriteMovies];
  if (action.add) {
    favoriteMovies.add(action.id);
  } else {
    favoriteMovies.remove(action.id);
  }
  final AppUser user = state.user!.copyWith(favoriteMovies: favoriteMovies);
  return state.copyWith(user: user);
}

AppState _updateFavoriteError(AppState state, UpdateFavoriteError action) {
  final List<int> favoriteMovies = <int>[...state.user!.favoriteMovies];
  if (action.add) {
    favoriteMovies.remove(action.id);
  } else {
    favoriteMovies.add(action.id);
  }
  final AppUser user = state.user!.copyWith(favoriteMovies: favoriteMovies);
  return state.copyWith(user: user);
}

AppState _logoutSuccessful(AppState state, LogoutSuccessful action) {
  return state.copyWith(user: null);
}

AppState _getUserSuccessful(AppState state, GetUserSuccessful action) {
  return state.copyWith(
    users: <String, AppUser>{
      ...state.users,
      action.user.uid: action.user,
    },
  );
}
