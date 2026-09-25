import 'package:movies_app/core/utils/app_assets.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/home_tab/data/models/movie_model.dart';

// Dummy Data لاستخدامها في مرحلة تطوير الـ UI الخاص بصفحة الـ Browse
class BrowseDummyData {
  BrowseDummyData._();

  static const List<String> genres = [
    'Action',
    'Adventure',
    'Animation',
    'Biography',
    'Comedy',
    'Crime',
    'Drama',
    'Horror',
  ];

  static const List<String> _posters = [
    AppAssets.movieBlackWidow,
    AppAssets.movieBatman,
    AppAssets.movie1917,
    AppAssets.movieCivilWar,
    AppAssets.movieCaptainAmerica2,
    AppAssets.moviewar,
  ];

  static List<MovieModel> get movies => List.generate(
        12,
        (index) => MovieModel(
          id: '$index',
          imageUrl: _posters[index % _posters.length],
          rating: '7.7',
          backgroundUrl: _posters[index % _posters.length],
          genres: const ['Action'],
        ),
      );
}
