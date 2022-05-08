import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movie_app/src/actions/index.dart';
import 'package:movie_app/src/containers/home_page_container.dart';
import 'package:movie_app/src/containers/movies_container.dart';
import 'package:movie_app/src/containers/pending_container.dart';
import 'package:movie_app/src/containers/user_container.dart';
import 'package:movie_app/src/models/index.dart';
import 'package:redux/redux.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false).dispatch(GetMovies.start(_onResult));
    _controller.addListener(_onScroll);
  }

  void _onResult(AppAction action) {
    if (action is GetMoviesError) {
      final Object error = action.error;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error has occurred $error')));
    }
  }

  void _onScroll() {
    final double offset = _controller.offset;
    final double extent = _controller.position.maxScrollExtent;
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    final bool isLoading = <String>[GetMovies.pendingKey, GetMovies.pendingKeyMore].any(store.state.pending.contains);
    if (offset >= extent - MediaQuery.of(context).size.height && !isLoading) {
      store.dispatch(GetMovies.more(_onResult));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return HomePageContainer(
      builder: (BuildContext context, AppState state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Movies ${state.pageNumber}'),
            leading: IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                StoreProvider.of<AppState>(context).dispatch(const Logout());
              },
            ),
          ),
          body: PendingContainer(
            builder: (BuildContext context, Set<String> pending) {
              return MoviesContainer(
                builder: (BuildContext context, List<Movie> movies) {
                  final bool isLoading = state.pending.contains(GetMovies.pendingKey);
                  final bool isLoadingMore = state.pending.contains(GetMovies.pendingKeyMore);

                  if (isLoading && movies.isEmpty) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return UserContainer(
                    builder: (BuildContext context, AppUser? user) {
                      return ListView.builder(
                        controller: _controller,
                        itemCount: movies.length + (isLoadingMore ? 1 : 0),
                        itemBuilder: (BuildContext context, int index) {
                          if (index == movies.length) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          final Movie movie = movies[index];
                          final bool isFavorite = user!.favoriteMovies.contains(movie.id);

                          return GestureDetector(
                            onTap: () {
                              StoreProvider.of<AppState>(context).dispatch(SetSelectedMovieId(movie.id));
                              Navigator.pushNamed(context, '/comments');
                            },
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 320,
                                      child: Image.network(movie.poster),
                                    ),
                                    IconButton(
                                      color: Colors.red,
                                      icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                                      onPressed: () {
                                        StoreProvider.of<AppState>(context)
                                            .dispatch(UpdateFavorite(movie.id, add: !isFavorite));
                                      },
                                    )
                                  ],
                                ),
                                Text('${movie.year}'),
                                Text(movie.genres.join(', ')),
                                Text('${movie.rating}'),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
