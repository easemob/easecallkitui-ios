Pod::Spec.new do |s|
    s.name             = 'EaseCallKit'
    s.version          = '1.0.0'
    s.summary          = '测试'
    s.description      = <<-DESC
        ‘测试.’
    DESC
    s.homepage = 'https://www.easemob.com'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'easemob' => 'dev@easemob.com' }
    s.source           = { :git => 'http://XXX/EaseCallKit.git', :tag => s.version.to_s }
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '9.0'
    s.source_files = 'Classes/**/*.{h,m}'
    s.public_header_files = [
      'Classes/Process/EaseCallManager.h',
      'Classes/Utils/EaseCallDefine.h',
      'Classes/Utils/EaseCallError.h',
      'Classes/Store/EaseCallConfig.h',
      'Classes/EaseCallUIKit.h',
    ]
    s.resources = 'Assets/EaseCall.bundle'
    s.dependency 'HyphenateChat'
    s.dependency 'Masonry'
    s.dependency 'AgoraRtcEngine_iOS'
    s.dependency 'SDWebImage', '~> 3.7.2'
end
