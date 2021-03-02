Pod::Spec.new do |s|
    s.name             = 'EaseCallKit'
    s.version          = '3.8.0.2'
    s.summary          = 'A UI framework with video and audio call'
    s.description      = <<-DESC
        ‘A UI framework which implemented by Easemob and Agora SDK. User can make video or audio call with it.'
    DESC
    s.homepage = 'https://www.easemob.com'
    s.license          = { :type => 'MIT', :text => 'LICENSE text' }
    s.author           = { 'easemob' => 'sdk@easemob.com' }
    s.source           = { :http => 'https://downloadsdk.easemob.com/downloads/EaseCallKit/iOS_Pod_EaseCallKit_V3.8.0.zip' }
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '9.0'
    s.preserve_paths = '*.framework'
    s.requires_arc = true
    s.vendored_frameworks = '*.framework'
    s.dependency 'HyphenateChat'
    s.dependency 'Masonry'
    s.dependency 'SDWebImage', '~> 3.7.2'
    s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES','EXCLUDED_ARCHS[sdk=iphonesimulator*]'=>'i386' }
end
