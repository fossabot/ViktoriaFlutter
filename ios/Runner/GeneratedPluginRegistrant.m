//
//  Generated file. Do not edit.
//

#import "GeneratedPluginRegistrant.h"
#import <fluttertoast/FluttertoastPlugin.h>
#import <intro_slider/IntroSliderPlugin.h>
#import <onesignal/OneSignalPlugin.h>
#import <shared_preferences/SharedPreferencesPlugin.h>
#import <url_launcher/UrlLauncherPlugin.h>

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [FluttertoastPlugin registerWithRegistrar:[registry registrarForPlugin:@"FluttertoastPlugin"]];
  [IntroSliderPlugin registerWithRegistrar:[registry registrarForPlugin:@"IntroSliderPlugin"]];
  [OneSignalPlugin registerWithRegistrar:[registry registrarForPlugin:@"OneSignalPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [FLTUrlLauncherPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTUrlLauncherPlugin"]];
}

@end
