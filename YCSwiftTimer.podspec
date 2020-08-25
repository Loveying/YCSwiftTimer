#
# Be sure to run `pod lib lint YCSwiftTimer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YCSwiftTimer'
  s.version          = '0.1.0'
  s.summary          = 'GCD实现自定义Timer'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  GCD实现自定义Timer，不会造成循环引用，支持队列、动态改变事件间隔、支持闭包方便使用
                       DESC

  s.homepage         = 'https://github.com/Loveying/YCSwiftTimer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Loveying' => 'xyy_ios@163.com' }
  s.source           = { :git => 'https://github.com/Loveying/YCSwiftTimer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'YCSwiftTimer/Classes/**/*'
  s.requires_arc = true
  s.frameworks = 'Foundation'
end
