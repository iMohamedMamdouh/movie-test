import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_routes/app_routes.dart';
import '../../../../core/utils/app_assets.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../profile/presentation/widgets/custom_button.dart';
import '../../../profile/presentation/widgets/custom_text_field.dart';
import '../../../profile/presentation/widgets/language_toggle.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;

  void _handleState(BuildContext context, LoginState state) {
    if (state is LoginSuccess) {
      Navigator.pushReplacement(context, AppRoutes.updateProfile());
    } else if (state is PasswordResetEmailSent) {
      _showMessage(
        context,
        'A reset link has been sent to ${state.email}',
        AppColors.primary,
      );
    } else if (state is LoginFailure) {
      _showMessage(context, state.errorMessage, AppColors.red);
    }
  }

  void _showMessage(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), backgroundColor: color),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: _handleState,
          builder: (context, state) {
            final LoginCubit cubit = context.read<LoginCubit>();
            final bool isLoading = state is LoginLoading;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: Image.asset(
                        AppAssets.appLogo,
                        height: 118,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 70),

                    CustomTextField(
                      controller: cubit.emailController,
                      hintText: 'Email',
                      prefixIcon: Icons.email,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: cubit.validateEmail,
                    ),
                    const SizedBox(height: 22),

                    CustomTextField(
                      controller: cubit.passwordController,
                      hintText: 'Password',
                      prefixIcon: Icons.lock,
                      obscureText: _isPasswordHidden,
                      textInputAction: TextInputAction.done,
                      validator: cubit.validatePassword,
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _isPasswordHidden = !_isPasswordHidden,
                        ),
                        icon: Icon(
                          _isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Align(
                      alignment: AlignmentDirectional.centerEnd,
                      child: GestureDetector(
                        onTap: isLoading ? null : cubit.sendPasswordResetEmail,
                        child: const Text(
                          'Forget Password ?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primaryYellow,
                        ),
                      )
                    else
                      CustomButton(
                        text: 'Login',
                        onPressed: cubit.loginWithEmail,
                      ),
                    const SizedBox(height: 22),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't Have Account ? ",
                          style: TextStyle(color: AppColors.white, fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: isLoading
                              ? null
                              : () => Navigator.push(
                                    context,
                                    AppRoutes.register(),
                                  ),
                          child: const Text(
                            'Create One',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    Row(
                      children: const [
                        Expanded(child: Divider(color: AppColors.primaryYellow)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(color: AppColors.primaryYellow),
                          ),
                        ),
                        Expanded(child: Divider(color: AppColors.primaryYellow)),
                      ],
                    ),
                    const SizedBox(height: 28),

                    CustomButton(
                      text: 'Login With Google',
                      onPressed: isLoading ? () {} : cubit.loginWithGoogle,
                      iconPath: AppAssets.google,
                    ),
                    const SizedBox(height: 32),

                    Center(
                      child: LanguageToggleButton(
                        leftFlagPath: AppAssets.flagLeft,
                        rightFlagPath: AppAssets.flagRight,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
