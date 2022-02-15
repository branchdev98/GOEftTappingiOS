//
//  Utils.h
//  DreamCapture
//
//  Created by Dandong3 Sam on 11. 10. 22..
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    MONDAY      = 0x1, 
    TUESDAY     = 0x2, 
    WEDNESDAY   = 0x4, 
    THURSDAY    = 0x8, 
    FRIDAY      = 0x10, 
    SATURDAY    = 0x20, 
    SUNDAY      = 0x40, 
    // WORKDAY     = 0x10000
} WEEK;

extern const int EVERYDAY;

@interface Utils : NSObject

extern NSString *kAlarms;
extern NSString *kAlarmInfo;

extern NSString *kWorkday;
extern NSString *kIniVol;
extern NSString *kIncrease;

+ (NSString *)getSavingPath;

@end
