Pod::Spec.new do |s|
  s.name             = 'premium_ads_v2'
  s.version          = '1.0.1'
  s.summary          = 'PremiumAds Google AdMob Adapter V2 — Flutter plugin'
  s.description      = <<-DESC
PremiumAds custom mediation adapter for Google AdMob V2 — Flutter plugin.
                       DESC
  s.homepage         = 'https://premiumads.net'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'PremiumAds' => 'alex@premiumads.net' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'PremiumAdsGoogleAdapter', '~> 1.0.6'
  s.platform         = :ios, '13.0'
  s.swift_version    = '5.9'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
