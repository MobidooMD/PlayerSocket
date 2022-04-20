#
# Be sure to run `pod lib lint PlayerSocket.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PlayerSocket'
  s.version          = '0.2.1'
  s.summary          = '플레이어 소켓입니다.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/devplaynew/PlayerSocket'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'devplaynew' => 'banwith7@gmail.com' }
  s.source           = { :git => 'https://github.com/devplaynew/PlayerSocket.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'PlayerSocket/Classes/**/*'
  # s.resource_bundles = {
  #   'PlayerSocket' => ['PlayerSocket/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  
  # 현재 swift 버전
  s.swift_versions = '5.0'
  # WebSocket
  s.dependency 'Socket.IO-Client-Swift', '~> 14.0.0'
  s.dependency 'lottie-ios'
end
