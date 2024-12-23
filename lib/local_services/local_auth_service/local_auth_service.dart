/**
 * @author Akshit Jha
 * Creation Date: 11-12-2024
 */
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_darwin/types/auth_messages_ios.dart';
import 'package:transform_docs/viewmodels/local_auth_viewmodel/local_auth_viewmodel.dart';

class LocalAuthService {
  /// Initialize the local auth
  final LocalAuthentication _localAuth = LocalAuthentication();
  final LocalAuthViewmodel localAuthViewModel = Get.put(LocalAuthViewmodel());

  /// Auth Bool
  bool isAuthenticated = false;

  Future<bool> authenticate({bool? canCancel}) async {
    /// Checking if User Authenticated
    if (!isAuthenticated) {
      final bool canAuthenticateWithBiometrics =
          await _localAuth.canCheckBiometrics;

      /// When Biometrics is available
      if (canAuthenticateWithBiometrics) {
        try {
          final bool didAuthenticate = await _localAuth.authenticate(
            localizedReason: "  ",
            options: const AuthenticationOptions(
              stickyAuth: true,
              useErrorDialogs: true,
              biometricOnly: false,
              sensitiveTransaction: true,
            ),
            authMessages: <AuthMessages>[
              // Custom messages for Android
              const AndroidAuthMessages(
                biometricSuccess: "Succesfully Authenticated",
                signInTitle: 'Unlock to use Softboard Lite', // Dialog title
                cancelButton: 'Cancel', // Cancel button text
                goToSettingsButton:
                    'Go to Settings', // Button to navigate to settings
                goToSettingsDescription:
                    'Please set up your biometrics.', // Description when biometrics are not set up
              ),
              // Custom messages for iOS
              const IOSAuthMessages(
                lockOut: 'Please re-enable your Face ID/Touch ID.',
                cancelButton: 'Cancel', // Cancel button text
                goToSettingsButton:
                    'Go to Settings', // Button to navigate to settings
                goToSettingsDescription:
                    'Biometric authentication is not set up on your device. Please enable Face ID/Touch ID in the settings.', // Description when biometrics are not set up
                localizedFallbackTitle:
                    'Use Passcode', // Fallback title when biometrics fail
              ),
            ],
          );
          if (didAuthenticate) {
            localAuthViewModel.authenticated(true);
            return true;
          } else {
            if (canCancel == true && canCancel != null) {
              localAuthViewModel.authenticated(true);
            }
            return false;
          }
        } catch (e) {
          throw "Error while authenticating: ${e.toString()}";
        }
      } else {
        return false;
      }
    } else {
      return true;

      /// User is Authenticated
    }
  }
}
