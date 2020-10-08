import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:metrics/auth/domain/entities/auth_error_code.dart';
import 'package:metrics/auth/domain/entities/authentication_exception.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:metrics/auth/domain/entities/user_profile.dart';
import 'package:metrics/auth/domain/usecases/create_user_profile_usecase.dart';
import 'package:metrics/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_credentials_param.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_id_param.dart';
import 'package:metrics/auth/domain/usecases/parameters/user_profile_param.dart';
import 'package:metrics/auth/domain/usecases/receive_authentication_updates.dart';
import 'package:metrics/auth/domain/usecases/receive_user_profile_updates.dart';
import 'package:metrics/auth/domain/usecases/sign_in_usecase.dart';
import 'package:metrics/auth/domain/usecases/sign_out_usecase.dart';
import 'package:metrics/auth/domain/usecases/update_user_profile_usecase.dart';
import 'package:metrics/auth/presentation/models/auth_error_message.dart';
import 'package:metrics/auth/presentation/models/user_profile_model.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/presentation/models/persistent_store_error_message.dart';
import 'package:metrics_core/metrics_core.dart';

/// The [ChangeNotifier] that holds the authentication state.
///
/// Provides the ability to sign in and sign out user from the app,
/// track the [isLoggedIn] status and authentication error message if any.
class AuthNotifier extends ChangeNotifier {
  /// A [List] of [AuthErrorCode]s that defines which errors are related to the email address.
  static const List<AuthErrorCode> _emailErrorCodes = [
    AuthErrorCode.invalidEmail,
    AuthErrorCode.userNotFound,
  ];

  /// A [List] of [AuthErrorCode]s that defines which errors are related to the password.
  static const List<AuthErrorCode> _passwordErrorCodes = [
    AuthErrorCode.wrongPassword,
  ];

  /// Used to receive authentication updates.
  final ReceiveAuthenticationUpdates _receiveAuthUpdates;

  /// Used to sign in a user.
  final SignInUseCase _signInUseCase;

  /// Used to sign in a user via Google.
  final GoogleSignInUseCase _googleSignInUseCase;

  /// Used to sign out a user.
  final SignOutUseCase _signOutUseCase;

  /// A use case needed to be able to receive the user profile updates.
  final ReceiveUserProfileUpdates _receiveUserProfileUpdates;

  /// A use case needed to be able to create a new user profile.
  final CreateUserProfileUseCase _createUserProfileUseCase;

  /// A use case needed to be able to update the existing user profile.
  final UpdateUserProfileUseCase _updateUserProfileUseCase;

  /// A class that represents a user profile model.
  UserProfileModel _userProfileModel;

  /// The stream subscription needed to be able to unsubscribe
  /// from user profile updates.
  StreamSubscription _userProfileSubscription;

  /// Holds the [PersistentStoreErrorMessage] that occurred
  /// during the user profile saving.
  PersistentStoreErrorMessage _userProfileSavingErrorMessage;

  /// Holds the [PersistentStoreErrorMessage] that occurred
  /// during loading user profile data.
  PersistentStoreErrorMessage _userProfileErrorMessage;

  /// Contains a user's authentication status.
  bool _isLoggedIn;

  /// The stream subscription needed to be able to unsubscribe
  /// from authentication state updates.
  StreamSubscription _authUpdatesSubscription;

  /// Stores the loading status for the sign-in process.
  bool _isLoading = false;

  /// A currently selected [ThemeType].
  ThemeType _selectedTheme;

  /// Contains a text description of any authentication exception that may occur.
  AuthErrorMessage _authErrorMessage;

  /// Contains a text description of an email authentication exception that may occur.
  AuthErrorMessage _emailErrorMessage;

  /// Contains a text description of a password authentication exception that may occur.
  AuthErrorMessage _passwordErrorMessage;

  /// Creates a new instance of auth notifier.
  ///
  /// All the parameters must not be null.
  AuthNotifier(
    this._receiveAuthUpdates,
    this._signInUseCase,
    this._googleSignInUseCase,
    this._signOutUseCase,
    this._receiveUserProfileUpdates,
    this._createUserProfileUseCase,
    this._updateUserProfileUseCase,
  )   : assert(_receiveAuthUpdates != null),
        assert(_signInUseCase != null),
        assert(_googleSignInUseCase != null),
        assert(_signOutUseCase != null),
        assert(_receiveUserProfileUpdates != null),
        assert(_createUserProfileUseCase != null),
        assert(_updateUserProfileUseCase != null);

  /// Determines if a user is authenticated.
  bool get isLoggedIn => _isLoggedIn;

  /// Indicates whether the sign-in process is in progress or not.
  bool get isLoading => _isLoading;

  /// Provides a currenlty selected theme.
  ThemeType get selectedTheme => _selectedTheme;

  /// Provides a class that represents a user profile model.
  UserProfileModel get userProfileModel => _userProfileModel;

  /// Returns an [AuthErrorMessage], containing an authentication error message.
  String get authErrorMessage => _authErrorMessage?.message;

  /// Returns an [AuthErrorMessage], containing an email authentication error message.
  String get emailErrorMessage => _emailErrorMessage?.message;

  /// Returns an [AuthErrorMessage], containing a password authentication error message.
  String get passwordErrorMessage => _passwordErrorMessage?.message;

  /// Provides an error description that occurred during
  /// the user profile saving operation.
  String get userProfileSavingErrorMessage =>
      _userProfileSavingErrorMessage?.message;

  /// Provides an error description that occurred during
  /// loading user profile data.
  String get userProfileErrorMessage => _userProfileErrorMessage?.message;

  /// Subscribes to a user authentication updates
  /// to get notified when the user got signed in or signed out.
  void subscribeToAuthenticationUpdates() {
    _authUpdatesSubscription?.cancel();
    _authUpdatesSubscription = _receiveAuthUpdates().listen((user) {
      if (user != null) {
        subscribeToUserProfileUpdates(user.id);
      } else {
        _cancelUserProfileSubscription();
        _isLoggedIn = false;
        notifyListeners();
      }
    });
  }

  /// Subscribes to a user profile updates.
  void subscribeToUserProfileUpdates(String id) {
    if (id == null) {
      return;
    }

    _userProfileSubscription?.cancel();

    final _userProfileUpdates = _receiveUserProfileUpdates(UserIdParam(id: id));

    _userProfileSubscription = _userProfileUpdates.listen(
      (userProfile) => _userProfileUpdatesListener(id, userProfile),
      onError: _errorHandler,
    );
  }

  /// Signs in a user to the app using an [email] and a [password].
  ///
  /// Does nothing if the [isLoading] status is `true`.
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    if (_isLoading) return;

    _isLoading = true;
    clearErrorMessages();

    try {
      await _signInUseCase(UserCredentialsParam(
        email: Email(email),
        password: Password(password),
      ));
    } on AuthenticationException catch (exception) {
      _handleAuthErrorMessage(exception.code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Signs in a user to the app using Google authentication.
  ///
  /// Does nothing if the [isLoading] status is `true`.
  Future<void> signInWithGoogle() async {
    if (_isLoading) return;

    _isLoading = true;
    clearErrorMessages();

    try {
      await _googleSignInUseCase();
    } on AuthenticationException catch (exception) {
      _handleAuthErrorMessage(exception.code);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears all authentication error messages.
  void clearErrorMessages() {
    _authErrorMessage = null;
    _emailErrorMessage = null;
    _passwordErrorMessage = null;
    notifyListeners();
  }

  /// Updates the existing user profile, based on the updated [userProfile].
  Future<void> updateUserProfile(UserProfileModel userProfile) async {
    if (userProfile == null || userProfile == _userProfileModel) {
      return;
    }

    _resetUserProfileSavingErrorMessage();

    try {
      await _updateUserProfileUseCase(
        UserProfileParam(
          id: userProfile.id,
          selectedTheme: userProfile.selectedTheme,
        ),
      );
      _changeTheme(userProfile.selectedTheme);
    } on PersistentStoreException catch (exception) {
      _userProfileSavingErrorHandler(exception.code);
    }
  }

  /// Signs out the user from the app.
  Future<void> signOut() async {
    await _signOutUseCase();
  }

  /// Changes the currently selected theme to the given [themeType].
  void _changeTheme(ThemeType themeType) {
    if (themeType == null) {
      return;
    }

    if (_selectedTheme != themeType) {
      _selectedTheme = themeType;
    }
  }

  /// Listens to user profile updates.
  Future<void> _userProfileUpdatesListener(
    String id,
    UserProfile userProfile,
  ) async {
    if (userProfile != null) {
      _userProfileModel = UserProfileModel(
        id: userProfile.id,
        selectedTheme: userProfile.selectedTheme,
      );

      _isLoggedIn = true;
    } else {
      await _createUserProfile(id, selectedTheme);
    }

    notifyListeners();
  }

  /// Creates the user profile, based on the given [id] and [selectedTheme].
  Future<void> _createUserProfile(String id, ThemeType selectedTheme) async {
    if (id == null || selectedTheme == null) {
      return;
    }

    _resetUserProfileSavingErrorMessage();

    try {
      await _createUserProfileUseCase(
        UserProfileParam(
          id: id,
          selectedTheme: selectedTheme,
        ),
      );
    } on PersistentStoreException catch (exception) {
      _userProfileSavingErrorHandler(exception.code);
    }
  }

  /// Handles an [error] occurred in user profile stream.
  void _errorHandler(error) {
    if (error is PersistentStoreException) {
      _userProfileErrorMessage = PersistentStoreErrorMessage(error.code);
      notifyListeners();
    }
  }

  /// Cancels created user profile subscription.
  void _cancelUserProfileSubscription() {
    _userProfileSubscription?.cancel();
    _userProfileModel = null;
    _selectedTheme = null;
  }

  /// Handles an authentication error message based on the [errorCode].
  void _handleAuthErrorMessage(AuthErrorCode errorCode) {
    final _errorMessage = AuthErrorMessage(errorCode);

    if (_emailErrorCodes.contains(errorCode)) {
      _emailErrorMessage = _errorMessage;
    } else if (_passwordErrorCodes.contains(errorCode)) {
      _passwordErrorMessage = _errorMessage;
    } else {
      _authErrorMessage = _errorMessage;
    }
  }

  /// Resets the user profile saving error message.
  void _resetUserProfileSavingErrorMessage() {
    _userProfileSavingErrorMessage = null;
    notifyListeners();
  }

  /// Handles an error occurred during saving a user profile.
  void _userProfileSavingErrorHandler(PersistentStoreErrorCode code) {
    _userProfileSavingErrorMessage = PersistentStoreErrorMessage(code);
    notifyListeners();
  }

  @override
  void dispose() {
    _authUpdatesSubscription?.cancel();
    _cancelUserProfileSubscription();

    super.dispose();
  }
}
