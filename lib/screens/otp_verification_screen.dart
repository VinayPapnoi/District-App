import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/colors.dart';
import '../providers/auth_provider.dart';
import 'dart:async';

class OTPVerificationScreen extends ConsumerStatefulWidget {
  const OTPVerificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends ConsumerState<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  
  int _resendTimer = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _resendTimer = 60;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() {
          _resendTimer--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOTP() {
    return _controllers.map((controller) => controller.text).join();
  }

  bool _isOTPComplete() {
    return _getOTP().length == 6;
  }

  Future<void> _verifyOTP() async {
    final otp = _getOTP();
    final success = await ref.read(authProvider.notifier).verifyOTP(otp);
    
    if (success && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  Future<void> _resendOTP() async {
    if (_canResend) {
      await ref.read(authProvider.notifier).resendOTP();
      _startTimer();
      
      // Clear OTP fields
      for (var controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Listen for errors
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
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
              final horizontalPad = (constraints.maxWidth * 0.06).clamp(16.0, 24.0);
              final availableWidthForOtp = constraints.maxWidth - (horizontalPad * 2) - 32;
              final boxWidth = ((availableWidthForOtp - (5 * 6)) / 6).clamp(34.0, 48.0);
              final boxHeight = boxWidth * (55.0 / 45.0);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // Back button
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: AppColors.white,
                                size: 28,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: (constraints.maxHeight * 0.03).clamp(10.0, 40.0)),

                        // OTP Verification Section
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPad,
                              vertical: 24.0,
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 19, 18, 18),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 16),

                                // Title
                                const Text(
                                  'Verify your number',
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Subtitle with phone number
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'We have sent a verification code to\n',
                                      ),
                                      TextSpan(
                                        text: '${authState.countryCode} ${authState.phoneNumber}',
                                        style: const TextStyle(
                                          color: AppColors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: (constraints.maxHeight * 0.04).clamp(16.0, 40.0)),

                                // OTP Input Fields
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(6, (index) {
                                    return Container(
                                      margin: EdgeInsets.symmetric(
                                        horizontal: (constraints.maxWidth < 360 ? 2.5 : 4.0),
                                      ),
                                      width: boxWidth,
                                      height: boxHeight,
                                      child: TextField(
                                        controller: _controllers[index],
                                        focusNode: _focusNodes[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize: (boxWidth * 0.5).clamp(16.0, 24.0),
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          counterText: '',
                                          filled: true,
                                          fillColor: const Color.fromARGB(255, 10, 10, 11),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: Color.fromARGB(255, 47, 47, 58),
                                              width: 1,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: const BorderSide(
                                              color: AppColors.primaryPurple,
                                              width: 2,
                                            ),
                                          ),
                                        ),
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                        ],
                                        onChanged: (value) {
                                          if (value.isNotEmpty && index < 5) {
                                            _focusNodes[index + 1].requestFocus();
                                          } else if (value.isEmpty && index > 0) {
                                            _focusNodes[index - 1].requestFocus();
                                          }
                                          
                                          // Auto-verify when all fields are filled
                                          if (_isOTPComplete()) {
                                            _verifyOTP();
                                          }
                                          
                                          setState(() {});
                                        },
                                      ),
                                    );
                                  }),
                                ),
                                SizedBox(height: (constraints.maxHeight * 0.04).clamp(20.0, 40.0)),

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : (_isOTPComplete() ? _verifyOTP : null),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isOTPComplete()
                                    ? AppColors.primaryPurple
                                    : const Color.fromARGB(255, 47, 47, 58),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                disabledBackgroundColor:
                                    const Color.fromARGB(255, 68, 68, 73),
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
                                      'Verify',
                                      style: TextStyle(
                                        color: _isOTPComplete()
                                            ? AppColors.white
                                            : const Color.fromARGB(255, 140, 136, 136),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Resend OTP
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Didn't receive code? ",
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                if (_canResend)
                                  TextButton(
                                    onPressed: _resendOTP,
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(0, 0),
                                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    child: const Text(
                                      'Resend',
                                      style: TextStyle(
                                        color: AppColors.primaryPurple,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  )
                                else
                                  Text(
                                    'Resend in ${_resendTimer}s',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
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