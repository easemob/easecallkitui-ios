Pod::Spec.new do |spec|
  spec.name         = 'EaseCallKit'
  spec.version      = '0.1.1'
  spec.license 	    = { :type => 'Copyright', :text => 'Hyphenate Inc. 2017' }
  spec.summary      = 'An Objective-C UI framework'
  spec.description  = 'Test'
  spec.homepage     = 'http://www.easemob.com/'
  spec.author       = {'Hyphenate Inc.' => 'sdk@easemob.com'}
  spec.source       = {:http => 'https://downloadsdk.easemob.com/downloads/EaseCallKit0_1_0.zip' }
  spec.platform     = :ios, '9.0'
  spec.requires_arc = true
  spec.preserve_paths = '*.framework'
  spec.vendored_frameworks = '*.framework'
  spec.xcconfig     = {'OTHER_LDFLAGS' => '-ObjC'}
  spec.dependency 'HyphenateChat'
  spec.dependency 'Masonry'
  spec.dependency 'SDWebImage', '~> 3.7.2'
end
