#xcodeproj 'CNLogo.xcodeproj'

# Uncomment this line to define a global platform for your project
platform :ios, '9.0'

use_frameworks!
inhibit_all_warnings!

#pod 'Dollar'
#pod 'LiquidLoader', :git => 'https://github.com/yoavlt/LiquidLoader.git', :branch => 'swift-2.0'

#pod 'BetweenKit'
#pod 'RATreeView' #, "~> 2.1.0"

def cnlft
    pod 'CNLFoundationTools' #, :path => '~/src/CNLFoundationTools'
end

def cnluit
    pod 'CNLUIKitTools', :path => '~/src/CNLUIKitTools'
end

def cnldp
    pod 'CNLDataProvider', :path => '~/src/CNLDataProvider'
end

target 'CNLogo' do

    cnlft
    cnluit
    cnldp
    
    target 'CNLogoTests' do
        inherit! :search_paths
    end

end


target 'CNLogoCore' do
    cnlft
    cnluit
    cnldp
end
