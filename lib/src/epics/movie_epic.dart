import 'package:movie_app/src/actions/index.dart';
import 'package:movie_app/src/data/movie_api.dart';
import 'package:movie_app/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class MovieEpic {
  MovieEpic(this._api);

  final MovieApi _api;

  Epic<AppState> getEpics() {
    return combineEpics(<Epic<AppState>>[
      _getMovies,
      _listenForComments,
      TypedEpic<AppState, CreateCommentStart>(_createCommentStart),
    ]);
  }

  Stream<AppAction> _getMovies(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions
        .where((dynamic action) => action is GetMoviesStart || action is GetMoviesMore)
        .flatMap((dynamic action) {
      String pendingId = '';
      ActionResult onResult = (_) {};
      if (action is GetMoviesStart) {
        pendingId = action.pendingId;
        onResult = action.onResult;
      } else if (action is GetMoviesMore) {
        pendingId = action.pendingId;
        onResult = action.onResult;
      }
      return Stream<void>.value(null)
          .asyncMap((_) => _api.getMovies(store.state.pageNumber))
          .map<GetMovies>((List<Movie> movies) {
        return GetMovies.successful(movies, pendingId);
      }).onErrorReturnWith((Object error, StackTrace stackTrace) {
        return GetMovies.error(error, stackTrace, pendingId);
      }).doOnData(onResult);
    });
  }

  Stream<AppAction> _listenForComments(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ListenForCommentsStart>().flatMap((ListenForCommentsStart action) {
      return _api
          .listenForComments(action.movieId)
          .expand((List<Comment> comments) {
            return <AppAction>[
              ListenForComments.event(comments),
              ...comments
                  .where((Comment comment) => store.state.users[comment.uid] == null)
                  .map((Comment comment) => GetUser(comment.uid))
                  .toSet(),
            ];
      })
          .takeUntil<dynamic>(
        actions.where((dynamic event) {
          return event is ListenForCommentsDone && event.movieId == action.movieId;
        }),
      ).onErrorReturnWith($ListenForComments.error);
    });
  }

  Stream<AppAction> _createCommentStart(Stream<CreateCommentStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((CreateCommentStart action) {
      return Stream<void>.value(null)
          .asyncMap((_) {
            return _api.createComment(
                uid: store.state.user!.uid, movieId: store.state.selectedMovieId!, text: action.text,);
          })
          .mapTo(const CreateComment.successful())
          .onErrorReturnWith($CreateComment.error);
    });
  }
}
