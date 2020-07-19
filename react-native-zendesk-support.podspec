require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-zendesk-support"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.description  = <<-DESC
                  react-native-zendesk-support
                   DESC
  s.homepage     = "https://github.com/tughril/react-native-zendesk-support"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authors      = {}
  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/tughril/react-native-zendesk-support.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "ZendeskSupportSDK"
  s.dependency "ZendeskSupportProvidersSDK"

end

