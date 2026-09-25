import 'package:flutter/material.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/home_tab/data/models/movie_model.dart';

class BrowseMovieCard extends StatelessWidget {
  final MovieModel movie;
  final double borderRadius;

  const BrowseMovieCard({
    super.key,
    required this.movie,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildPoster(),
          Positioned(
            top: 10,
            left: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    movie.rating,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // يدعم صور الـ assets (Dummy Data) وصور الـ network (API) لاحقاً
  Widget _buildPoster() {
    final isNetwork = movie.imageUrl.startsWith('http');
    Widget errorBuilder(BuildContext context, Object error, StackTrace? st) =>
        Container(
          color: AppColors.surfaceColor,
          child: const Icon(Icons.movie, color: Colors.white54, size: 40),
        );

    return isNetwork
        ? Image.network(
            movie.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: errorBuilder,
          )
        : Image.asset(
            movie.imageUrl,
            fit: BoxFit.cover,
            errorBuilder: errorBuilder,
          );
  }
}
