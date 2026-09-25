import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies_app/core/theme/app_colors.dart';
import 'package:movies_app/features/main_layout/presentation/cubit/main_layout_cubit.dart';
import 'package:movies_app/features/main_layout/presentation/cubit/main_layout_state.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/browse_tab/presentation/pages/browse_tab_body.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:movies_app/features/main_layout/presentation/widgets/home_tab/presentation/pages/home_tab_body.dart';

class MainLayoutScreen extends StatelessWidget {
  const MainLayoutScreen({super.key});
  static const List<Widget> _screens = [
    HomeTabBody(),
    Center(
      child: Text(
        'Search Screen',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    BrowseTabBody(),
    Center(
      child: Text(
        'Profile Screen',
        style: TextStyle(
          color: AppColors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainLayoutCubit(),
      child: BlocBuilder<MainLayoutCubit, MainLayoutState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.scaffoldBackground,
            extendBody: true,
            body: IndexedStack(
              index: state.currentIndex,
              children: _screens,
            ),
            bottomNavigationBar: CustomBottomNavBar(
              currentIndex: state.currentIndex,
              onTap: (index) {
                context.read<MainLayoutCubit>().changeIndex(index);
              },
            ),
          );
        },
      ),
    );
  }
}
