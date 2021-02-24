Pod::Spec.new do |s|
    s.name             = 'EaseCallKit'
    s.version          = '0.1.0'
    s.summary          = '测试'
    s.description      = <<-DESC
        ‘测试’
    DESC
    s.homepage = 'https://www.easemob.com'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'easemob' => 'dev@easemob.com' }
    s.source           = { :http => 'https://downloadsdk.easemob.com/downloads/EaseCallKit0_1_0.zip' }
    s.frameworks = 'UIKit'
    s.libraries = 'stdc++'
    s.ios.deployment_target = '9.0'
    s.dependency 'HyphenateChat'
    s.dependency 'Masonry'
    s.dependency 'SDWebImage', '~> 3.7.2'
end
