
Pod::Spec.new do |s|
  s.name             = 'JXUtilsKit'
  s.version          = '0.1.3'
  s.summary          = '工具类库'
  s.homepage         = 'https://github.com/Barnett2050/JXUtilsKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zjx_mywork@163.com' => 'zjx_mywork@163.com' }
  s.source           = { :git => 'https://github.com/Barnett2050/JXUtilsKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  
  s.source_files = 'JXUtilsKit/JXUtilsKit.h'
  s.public_header_files = 'JXUtilsKit/JXUtilsKit.h'
  
  s.subspec 'Tools' do |ss|
    ss.source_files = 'JXUtilsKit/Tools/*.{h,m}'
    ss.public_header_files = 'JXUtilsKit/Tools/*.h'
  end
  
  s.subspec 'Byte' do |ss|
    ss.source_files = 'JXUtilsKit/Byte/*.{h,m}'
    ss.public_header_files = 'JXUtilsKit/Byte/*.h'
  end
  
  s.subspec 'Marco' do |ss|
    ss.source_files = 'JXUtilsKit/Marco/*.{h,m}'
    ss.public_header_files = 'JXUtilsKit/Marco/*.h'
  end
  
  s.subspec 'ThreadSafe' do |ss|
    ss.source_files = 'JXUtilsKit/ThreadSafe/*.{h,m}'
    ss.public_header_files = 'JXUtilsKit/ThreadSafe/*.h'
  end

  s.frameworks = 'Foundation'
  
end
