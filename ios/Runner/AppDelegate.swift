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
        // Try multiple URL schemes to ensure compatibility
        let urls = [
          "App-Prefs:root=General&path=ACCESSIBILITY/VOICEOVER",
          "app-settings:root=General&path=ACCESSIBILITY/VOICEOVER",
          "prefs:root=General&path=ACCESSIBILITY/VOICEOVER"
        ]
        
        var opened = false
        for urlString in urls {
          if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:]) { success in
              if success {
                opened = true
                result(true)
              }
            }
            break
          }
        }
        
        if !opened {
          // Fallback to general settings
          if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(settingsUrl, options: [:]) { success in
              result(success)
            }
          } else {
            result(false)
          }
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
