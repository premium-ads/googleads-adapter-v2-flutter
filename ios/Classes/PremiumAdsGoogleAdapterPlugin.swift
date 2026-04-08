import Flutter
import UIKit

public class PremiumAdsGoogleAdapterPlugin: NSObject, FlutterPlugin {

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "premium_ads_v2", binaryMessenger: registrar.messenger())
        let instance = PremiumAdsGoogleAdapterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setDebug":
            guard let args = call.arguments as? [String: Any],
                  let enabled = args["enabled"] as? Bool else {
                result(FlutterError(code: "INVALID_ARGUMENT", message: "Missing 'enabled' argument", details: nil))
                return
            }

            // Use NSClassFromString to avoid hard linking the framework at compile time
            var adapterClass: AnyClass? = NSClassFromString("PremiumAdsGoogleAdapter.PremiumAdsAdapter")
            if adapterClass == nil {
                adapterClass = NSClassFromString("PremiumAdsAdapter")
            }
            if let cls = adapterClass {
                let selector = NSSelectorFromString("setDebug:")
                if cls.responds(to: selector) {
                    _ = (cls as AnyObject).perform(selector, with: enabled)
                    result(nil)
                    return
                }
            }
            result(FlutterError(code: "ADAPTER_ERROR", message: "PremiumAdsAdapter class not found", details: nil))

        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
