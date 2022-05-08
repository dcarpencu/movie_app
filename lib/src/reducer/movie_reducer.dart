import 'package:movie_app/src/actions/index.dart';
import 'package:movie_app/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<AppState> movieReducer = combineReducers<AppState>(<Reducer<AppState>>[
  TypedReducer<AppState, GetMoviesSuccessful>(_getMoviesSuccessful),
  TypedReducer<AppState, OnCommentsEvent>(_onCommentEvent),
  TypedReducer<AppState, SetSelectedMovieId>(_setMovieId),
]);

AppState _getMoviesSuccessful(AppState state, GetMoviesSuccessful action) {
  return state.copyWith(
    pageNumber: state.pageNumber + 1,
    movies: <Movie>[...state.movies, ...action.movies],
  );
}

AppState _onCommentEvent(AppState state, OnCommentsEvent action) {
  return state.copyWith(
    comments: <Comment>{...state.comments, ...action.comments}.toList(),
  );
}

AppState _setMovieId(AppState state, SetSelectedMovieId action) {
  return state.copyWith(selectedMovieId: action.movieId);
}
