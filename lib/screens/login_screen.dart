import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isButtonEnabled = ref.watch(isLoginButtonEnabledProvider);

    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      // Show error if any
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }

      // Navigate to OTP screen when verification ID is available
      if (next.verificationId != null && previous?.verificationId != next.verificationId) {
        Navigator.pushNamed(context, '/otp');
      }

      // Navigate to home if already authenticated
      if (next.isAuthenticated && !(previous?.isAuthenticated ?? false)) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.black,
                const Color.fromARGB(255, 77, 25, 156),
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isShort = constraints.maxHeight < 680;
              final illustrationWidth = (constraints.maxWidth * 0.85).clamp(220.0, 328.0);
              final illustrationHeight = (illustrationWidth * (200.0 / 328.0)).clamp(130.0, 200.0);
              final topSpacing = isShort ? 16.0 : (constraints.maxHeight * 0.05).clamp(16.0, 80.0);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Skip button
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/home');
                              },
                              style: TextButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 34, 33, 33),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              ),
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Top section with logo and illustration
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // District logo
                              Image.asset(
                                'assets/images/district_logo.png',
                                width: (constraints.maxWidth * 0.32).clamp(90.0, 120.0),
                              ),
                              SizedBox(height: topSpacing),

                              // Placeholder for 3D illustration
                              Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                    "assets/images/place.png",
                                    height: illustrationHeight,
                                    width: illustrationWidth,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Tagline
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  'One app for all your going out plans',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Bottom section with login form
                        Expanded(
                          flex: 2,
                          child: SingleChildScrollView(
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24.0),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 19, 18, 18),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Log in or sign up text
                                  const Text(
                                    'Log in or sign up',
                                    style: TextStyle(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Phone number input
                            Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 10, 10, 11),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  const Text(
                                    '🇮🇳',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    authState.countryCode,
                                    style: const TextStyle(
                                      color: AppColors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: TextField(
                                      onChanged: (value) {
                                        ref.read(authProvider.notifier).updatePhoneNumber(value);
                                      },
                                      keyboardType: TextInputType.phone,
                                      style: const TextStyle(
                                        color: AppColors.white,
                                        fontSize: 16,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: '10-digit mobile number',
                                        hintStyle: TextStyle(
                                          color: AppColors.textSecondary,
                                          fontSize: 16,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Continue button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: authState.isLoading
                                    ? null
                                    : (isButtonEnabled
                                        ? () async {
                                            await ref.read(authProvider.notifier).submitPhoneNumber();
                                          }
                                        : null),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isButtonEnabled
                                      ? AppColors.primaryPurple
                                      : const Color.fromARGB(255, 47, 47, 58),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  disabledBackgroundColor: const Color.fromARGB(255, 68, 68, 73),
                                ),
                                child: authState.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.white,
                                        ),
                                      )
                                    : Text(
                                        'Continue',
                                        style: TextStyle(
                                          color: isButtonEnabled
                                              ? const Color.fromARGB(255, 255, 255, 255)
                                              : const Color.fromARGB(255, 140, 136, 136),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 30),

                            // Terms and privacy text
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 12,
                                ),
                                children: [
                                  TextSpan(text: 'By continuing, you agree to our\n'),
                                  TextSpan(
                                    text: 'Terms of Services',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                  TextSpan(text: '     '),
                                  TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                      color: AppColors.white,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
}