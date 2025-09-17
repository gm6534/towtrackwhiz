import Flutter
import UIKit
import FirebaseCore
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   if FirebaseApp.app() == nil {
            FirebaseApp.configure()
      }
      
      // 👇 Initialize Google Maps with API key from Info.plist
         if let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSServicesAPIKey") as? String {
           GMSServices.provideAPIKey(apiKey)
         }
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
