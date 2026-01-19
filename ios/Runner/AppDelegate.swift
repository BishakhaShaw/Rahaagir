// import UIKit
// import Flutter
// import GoogleMaps

// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GMSServices.provideAPIKey("AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY")
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }


import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    /// ✅ Google Maps API key
    GMSServices.provideAPIKey("AIzaSyBKPLjj-Upqy4tTkO4VnBY9XxN8dKLuSyY")
    
    /// ✅ Register plugins
    GeneratedPluginRegistrant.register(with: self)

    /// ✅ Return superclass method
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
