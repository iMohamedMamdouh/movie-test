import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/browse_tab/data/models/browse_dummy_data.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/browse_tab/presentation/widgets/browse_movies_grid.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/browse_tab/presentation/widgets/genre_tabs_list.dart';

class BrowseTabBody extends StatefulWidget {
  const BrowseTabBody({super.key});

  @override
  State<BrowseTabBody> createState() => _BrowseTabBodyState();
}

class _BrowseTabBodyState extends State<BrowseTabBody> {
  int selectedGenreIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            GenreTabsList(
              genres: BrowseDummyData.genres,
              selectedIndex: selectedGenreIndex,
              onGenreSelected: (index) {
                setState(() {
                  selectedGenreIndex = index;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: BrowseMoviesGrid(
                movies: BrowseDummyData.movies,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
