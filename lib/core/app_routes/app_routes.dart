import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/cubit/login_cubit.dart';
import '../../features/auth/presentation/cubit/register_cubit.dart';
import '../../features/auth/presentation/views/forget_password_screen.dart';
import '../../features/auth/presentation/views/login_screen.dart';
import '../../features/auth/presentation/views/register_screen.dart';
import '../../features/onboarding/presentation/views/onboarding1_screen.dart';
import '../../features/onboarding/presentation/views/onboarding2_screen.dart';
import '../../features/onboarding/presentation/views/onboarding3_screen.dart';
import '../../features/onboarding/presentation/views/onboarding4_screen.dart';
import '../../features/onboarding/presentation/views/onboarding5_screen.dart';
import '../../features/onboarding/presentation/views/onboarding6_screen.dart';
import '../../features/profile/presentation/views/update_profile_screen.dart';

class AppRoutes {
  static Route onboarding1() =>
      MaterialPageRoute(builder: (_) => const Onboarding1Screen());

  static Route onboarding2() =>
      MaterialPageRoute(builder: (_) => const Onboarding2Screen());

  static Route onboarding3() =>
      MaterialPageRoute(builder: (_) => const Onboarding3Screen());

  static Route onboarding4() =>
      MaterialPageRoute(builder: (_) => const Onboarding4Screen());

  static Route onboarding5() =>
      MaterialPageRoute(builder: (_) => const Onboarding5Screen());

  static Route onboarding6() =>
      MaterialPageRoute(builder: (_) => const Onboarding6Screen());

  static Route login() => MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginScreen(),
    ),
  );

  static Route register() => MaterialPageRoute(
    builder: (_) => BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterScreen(),
    ),
  );

  static Route forgetPassword() =>
      MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());

  static Route updateProfile() =>
      MaterialPageRoute(builder: (_) => const UpdateProfileScreen());
}