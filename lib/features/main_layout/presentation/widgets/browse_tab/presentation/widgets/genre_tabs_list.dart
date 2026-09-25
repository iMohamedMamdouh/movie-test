import 'package:flutter/material.dart';
import 'genre_tab_item.dart';

class GenreTabsList extends StatelessWidget {
  final List<String> genres;
  final int selectedIndex;
  final ValueChanged<int> onGenreSelected;

  const GenreTabsList({
    super.key,
    required this.genres,
    required this.selectedIndex,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          return GenreTabItem(
            title: genres[index],
            isSelected: index == selectedIndex,
            onTap: () => onGenreSelected(index),
          );
        },
      ),
    );
  }
}
