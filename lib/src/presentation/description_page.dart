import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:movie_app/src/actions/index.dart';
import 'package:movie_app/src/containers/description_container.dart';
import 'package:movie_app/src/models/index.dart';
import 'package:redux/redux.dart';


class DescriptionPage extends StatefulWidget {
  const DescriptionPage({Key? key}) : super(key: key);

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage> {
  late Store<AppState> _store;

  @override
  void initState() {
    super.initState();
    _store = StoreProvider.of<AppState>(context, listen: false);
    _store.dispatch(ListenForComments.start(_store.state.selectedMovieId!));
  }

  @override
  void dispose() {
    _store.dispatch(ListenForCommentsDone(_store.state.selectedMovieId!));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectedMovieContainer(
      builder: (BuildContext context, Movie movie) {
        return Scaffold(
          appBar: AppBar(
            title: Text(movie.title),
          ),
          body: Center(
            child: Text(movie.description_full),),
        );
      },
    );
  }
}



















/*
class DescriptionPage extends StatelessWidget {
  const DescriptionPage({Key? key, required this.builder}) : super(key: key);

  final ViewModelBuilder<AppState> builder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Center(
        child: Text(movie.description),
      ),
      ),
    );
  }
}
*/
