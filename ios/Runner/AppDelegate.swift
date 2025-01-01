import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.trackeat.app/accessibility",
                                              binaryMessenger: controller.binaryMessenger)
    
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      guard let _ = self else { return }
      
      switch call.method {
      case "toggleVoiceOver":
        // Try to open VoiceOver settings directly
        if let url = URL(string: "App-Prefs:root=General&path=ACCESSIBILITY/VOICEOVER") {
          if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
              result(success)
            }
          } else {
            // Fallback to general settings
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(settingsUrl, options: [:]) { success in
                result(success)
              }
            } else {
              result(false)
            }
          }
        } else {
          result(false)
        }
      case "isVoiceAssistantEnabled":
        result(UIAccessibility.isVoiceOverRunning)
      default:
        result(FlutterMethodNotImplemented)
      }
    })
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
