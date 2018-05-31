Pod::Spec.new do |s|
  s.name         = "FPayEditView"
  s.version      = "0.0.6"
  s.summary      = "A view for pay "
  s.description  = "A view for pay show with cocoapod support."
  s.homepage     = "https://github.com/lxj916904395/FPayEditView"
  s.license= { :type => "MIT", :file => "LICENSE" }
  s.author       = { "lxj916904395" => "916904395@qq.com" }
  s.source       = { :git => "https://github.com/lxj916904395/FPayEditView.git", :tag => s.version.to_s }
  s.source_files = 'FPayEditView/*.{h,m}'
  s.ios.deployment_target = '6.0'
  s.frameworks   = 'UIKit'
  s.requires_arc = true
  s.public_header_files = 'FPayEditView/*.h'
  s.resources = "FPayEditView/*.png"

end
