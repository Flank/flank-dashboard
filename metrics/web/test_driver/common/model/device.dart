import 'enum.dart';

/// A enum representing the device id of the device the application will be ran.
///
/// The following devices are currently supported: chrome, web-server (default)
class Device extends Enum<String> {
  static const Device chrome = Device._("chrome");
  static const Device webServer = Device._("web-server");

  const Device._(String deviceId) : super(deviceId);
}
