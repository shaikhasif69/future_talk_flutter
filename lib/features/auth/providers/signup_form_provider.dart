import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'signup_form_provider.g.dart';

/// Simple model to hold signup form data temporarily
class SignUpFormData {
  final String fullName;
  final String email;
  final String username;
  final String password;
  final String confirmPassword;
  final bool acceptTerms;
  final bool acceptPrivacy;

  const SignUpFormData({
    this.fullName = '',
    this.email = '',
    this.username = '',
    this.password = '',
    this.confirmPassword = '',
    this.acceptTerms = false,
    this.acceptPrivacy = false,
  });

  SignUpFormData copyWith({
    String? fullName,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    bool? acceptTerms,
    bool? acceptPrivacy,
  }) {
    return SignUpFormData(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      acceptTerms: acceptTerms ?? this.acceptTerms,
      acceptPrivacy: acceptPrivacy ?? this.acceptPrivacy,
    );
  }
}

@riverpod
class SignUpFormState extends _$SignUpFormState {
  @override
  SignUpFormData build() {
    return const SignUpFormData();
  }

  void updateFormData({
    String? fullName,
    String? email,
    String? username,
    String? password,
    String? confirmPassword,
    bool? acceptTerms,
    bool? acceptPrivacy,
  }) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      username: username,
      password: password,
      confirmPassword: confirmPassword,
      acceptTerms: acceptTerms,
      acceptPrivacy: acceptPrivacy,
    );
  }

  void clearFormData() {
    state = const SignUpFormData();
  }
}