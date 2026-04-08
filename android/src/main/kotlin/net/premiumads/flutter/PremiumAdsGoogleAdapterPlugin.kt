package net.premiumads.flutter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class PremiumAdsGoogleAdapterPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "premium_ads_v2")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "setDebug" -> {
                val enabled = call.argument<Boolean>("enabled") ?: false
                try {
                    val cls = Class.forName("net.premiumads.sdk.adapter.PremiumAdsAdapter")
                    val method = cls.getMethod("setDebug", Boolean::class.javaPrimitiveType)
                    method.invoke(null, enabled)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("ADAPTER_ERROR", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
