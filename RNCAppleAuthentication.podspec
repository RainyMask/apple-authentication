
Pod::Spec.new do |s|
  s.name         = "RNCAppleAuthentication"
  s.version      = "1.0.0"
  s.summary      = "RNCAppleAuthentication"
  s.description  = <<-DESC
                  RNCAppleAuthentication
                   DESC
  s.homepage     = "https://github.com/RainyMask/apple-authentication"
  s.license      = "MIT"
  s.author       = { "author" => "author@domain.cn" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/RainyMask/apple-authentication.git", :tag => "master" }
  s.source_files = "ios/**/*.{h,m}"
  s.requires_arc = true


  s.dependency "React"

end

  