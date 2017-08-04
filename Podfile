xcodeproj 'CNLogo.xcodeproj'

# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

#pod 'Dollar'
#pod 'LiquidLoader', :git => 'https://github.com/yoavlt/LiquidLoader.git', :branch => 'swift-2.0'

#pod 'BetweenKit'
#pod 'RATreeView' #, "~> 2.1.0"

def complex_numbers
    pod 'CNLFoundationTools' #, :path => '~/src/CNLFoundationTools'
    pod 'CNLUIKitTools' #, :path => '~/src/CNLUIKitTools'
    pod 'CNLDataProvider' #, :path => '~/src/CNLDataProvider'
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
