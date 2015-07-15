//  Copyright 2014 Applause. All rights reserved.

#import "APLSetting.h"


typedef NS_ENUM(NSInteger, MQASettingsMode)
{
    MQASettingsModeQA,
    MQASettingsModeSilent
};

/**
* Anonymous login name - you can set it as defaultUser parameter.
*/
FOUNDATION_EXPORT NSString *const MQAAnonymousUser;

@interface MQASettings : NSObject <APLSetting>

@property(nonatomic) MQASettingsMode settingsMode;

@end
