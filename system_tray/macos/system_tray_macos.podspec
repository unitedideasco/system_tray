#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint system_tray.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'system_tray_macos'
  s.version          = '0.0.1'
  s.summary          = 'macOS implementation of the system_tray plugin.'
  s.description      = <<-DESC
Provides functionalities of system tray
                       DESC
  s.homepage         = 'http://unitedideas.co'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'United Ideas' => 'jakub.stefaniak@unitedideas.pl' }
  s.source           = { :http => 'https://github.com/unitedideasco/system_tray' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end