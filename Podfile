project 'CNLogo.xcodeproj'

# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

#pod 'Dollar'
#pod 'LiquidLoader', :git => 'https://github.com/yoavlt/LiquidLoader.git', :branch => 'swift-2.0'

#pod 'BetweenKit'
#pod 'RATreeView' #, "~> 2.1.0"

def complex_numbers
    #pod 'CNLFoundationTools' #, :path => '~/src/CNLFoundationTools'
    pod 'CNLFoundationTools' , :git => 'https://github.com/megavolt605/CNLFoundationTools', :branch => 'swift4'
    #pod 'CNLUIKitTools' #, :path => '~/src/CNLUIKitTools'
    pod 'CNLUIKitTools', :git => 'https://github.com/megavolt605/CNLUIKitTools', :branch => 'swift4'
    #pod 'CNLDataProvider' #, :path => '~/src/CNLDataProvider'
    pod 'CNLDataProvider', :git => 'https://github.com/megavolt605/CNLDataProvider', :branch => 'swift4'
end

target 'CNLogo' do

    complex_numbers
    
    target 'CNLogoTests' do
        inherit! :search_paths
    end

end

target 'CNLogoCore' do
    complex_numbers
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end
