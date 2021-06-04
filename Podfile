platform :ios, '13.1'
project 'Athany.xcodeproj'
use_frameworks!

# ignore all warnings from all dependencies
inhibit_all_warnings!

def apps_shared_pods
    # UI
    #pod 'SnapKit'
    pod 'Onboard'
    pod 'Adhan'
    pod 'SwiftyBeaver'
    pod 'Firebase/Analytics'
    pod 'Firebase/Crashlytics'
end

target "Athany" do	
   source 'https://cdn.cocoapods.org/'
   apps_shared_pods
end

target "AthanyTests" do
   apps_shared_pods
end

target "AthanyUITests" do
   apps_shared_pods
end


post_install do |installer|
    installer.pod_target_subprojects.each do |subproject|
        subproject.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['ENABLE_BITCODE'] = 'NO'
            end
        end
    end
end
# Comment the following if you do not want the SDK to emit signpost events for instrumentation. Signposts are  enabled for non release version of the app.
# post_install do |installer_representation|
#       installer_representation.pods_project.targets.each do |target|
#           target.build_configurations.each do |config|
#               config.build_settings['ENABLE_BITCODE'] = 'NO'
#               if config.name == 'Debug'
#                   config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)', 'DEBUG=1','SIGNPOST_ENABLED=1']
#                   config.build_settings['OTHER_SWIFT_FLAGS'] = ['$(inherited)', '-DDEBUG','-DSIGNPOST_ENABLED']
#               end
#           end
#       end
# end

