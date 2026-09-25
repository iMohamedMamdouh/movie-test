import 'package:flutter/material.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/home_tab/data/models/movie_model.dart';
import 'browse_movie_card.dart';

class BrowseMoviesGrid extends StatelessWidget {
  final List<MovieModel> movies;

  const BrowseMoviesGrid({
    super.key,
    required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      // مسافة سفلية حتى لا يغطي الـ Bottom Nav Bar آخر صف
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
      itemCount: movies.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 20,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        return BrowseMovieCard(movie: movies[index]);
      },
    );
  }
}
