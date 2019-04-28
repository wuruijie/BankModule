Pod::Spec.new do |s|
s.name         = "BankModule"
s.version      = "1.0.0"
s.summary      = "Simple one line code."
s.homepage     = "https://github.com/wuruijie/BankModule"
s.license      = "MIT"
s.author       = { "JerryWu" => "wuruijieresever@aliyun.com" }
s.platform     = :ios, "8.0"
s.source       = { :git => "https://github.com/wuruijie/BankModule.git", :tag => s.version }
s.source_files  = "XHBank", "XHBank/*.{h,m}"
s.framework  = "UIKit"
s.requires_arc = true
s.dependency 'AFNetworking'
end
