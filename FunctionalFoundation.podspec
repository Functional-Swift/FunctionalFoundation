Pod::Spec.new do |s|
  s.name = 'FunctionalFoundation'
  s.version = '0.1.1'
  s.swift_version = '4.1'
  s.license = 'MIT'
  s.summary = 'Future, Command and Observable classes'
  s.homepage = 'https://github.com/Functional-Swift/FunctionalFoundation'
  s.authors = { 'Maxim Bazarov' => 'bazaroffma@gmail.com.org' }
  s.source = { :git => 'https://github.com/Functional-Swift/FunctionalFoundation.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

  s.source_files = 'Source/**/*.swift'
end
