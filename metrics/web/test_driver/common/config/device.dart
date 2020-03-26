/// The device id of the device the application will be ran.
///
/// The following devices are currently supported: chrome, web-server (default)
class Device {
  static const Device chrome = Device._("chrome");
  static const Device webServer = Device._("web-server");

  final String deviceId;

  const Device._(this.deviceId);
}
