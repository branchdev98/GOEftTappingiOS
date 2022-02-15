//
//  Utils.m
//  DreamCapture
//
//  Created by Dandong3 Sam on 11. 10. 22..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"

const int EVERYDAY = (MONDAY | TUESDAY | WEDNESDAY | THURSDAY | FRIDAY | SATURDAY | SUNDAY);

@implementation Utils

NSString *kAlarms    = @"AlarmsKey";
NSString *kAlarmInfo = @"AlarmInfoKey";

NSString *kWorkday  = @"WorkdayKey";
NSString *kIniVol   = @"InitialVolKey";
NSString *kIncrease = @"IncreaseKey";

+ (NSString *)getSavingPath
{
    NSString *savingPath = nil;
    
#if TARGET_IPHONE_SIMULATOR
    
    savingPath = [[[NSString stringWithUTF8String:__FILE__] stringByDeletingLastPathComponent] stringByDeletingLastPathComponent];
#else
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    savingPath = [paths objectAtIndex:0];
    
#endif
    
    if (savingPath == nil) {
        savingPath = @"";
    }
    
    return savingPath;
}

@end
