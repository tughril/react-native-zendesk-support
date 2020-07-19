require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name           = 'react-native-zendesk-support'
  s.version        = package['version']
  s.summary        = package['description']
  s.description    = package['description']
  s.license        = package['license']
  s.author         = package['author']
  s.homepage       = package['homepage']
  s.source         = { git: 'https://github.com/tughril/react-native-zendesk-support', tag: s.version }

  s.requires_arc   = true
  s.platforms    = { :ios => "10.0" }

  s.preserve_paths = 'LICENSE', 'README.md', 'package.json', 'index.js'
  s.source_files = "ios/**/*.{h,c,m,swift}"
  s.requires_arc = true

  s.dependency "React"
  s.dependency "ZendeskSupportSDK"
  s.dependency "ZendeskSupportProvidersSDK"

end

