Pod::Spec.new do |s|
  s.name             = 'sf-wkt-ios'
  s.version          = '3.0.0'
  s.license          =  {:type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'iOS SDK for Simple Features Well-Known Text'
  s.homepage         = 'https://github.com/ngageoint/simple-features-wkt-ios'
  s.authors          = { 'NGA' => '', 'BIT Systems' => '', 'Brian Osborn' => 'bosborn@caci.com' }
  s.social_media_url = 'https://twitter.com/NGA_GEOINT'
  s.source           = { :git => 'https://github.com/ngageoint/simple-features-wkt-ios.git', :tag => s.version }
  s.requires_arc     = true
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }

  s.platform         = :ios, '15.0'
  s.ios.deployment_target = '15.0'

  s.source_files = 'sf-wkt-ios/**/*.{h,m}'

  s.frameworks = 'Foundation'

  s.dependency 'sf-ios', '5.0.0'
end
