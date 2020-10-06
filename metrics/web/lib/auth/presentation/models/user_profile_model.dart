import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';

/// A class that represents a user profile model used to
/// transfer data between [ChangeNotifier]s.
class UserProfileModel extends Equatable {
  /// A unique identifier of the user profile.
  final String id;

  /// A selected theme of the user profile.
  final ThemeType selectedTheme;

  @override
  List<Object> get props => [id, selectedTheme];

  /// Creates the [UserProfileModel] with the given [id] and the [selectedTheme].
  ///
  /// The [id] must not be null.
  const UserProfileModel({
    @required this.id,
    this.selectedTheme,
  }) : assert(id != null);

  /// Creates the new instance of the [UserProfileModel]
  /// based on the current instance.
  ///
  /// If any of the passed parameters are `null`, or parameter isn't specified,
  /// the value will be copied from the current instance.
  UserProfileModel copyWith({
    String id,
    ThemeType selectedTheme,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }
}
