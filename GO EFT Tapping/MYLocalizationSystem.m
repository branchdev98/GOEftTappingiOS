//
//  MYLocalizationSystem.m
//  GO EFT Tapping
//
//  Created by AnCheng on 8/24/16.
//  Copyright © 2016 Long Hei. All rights reserved.
//

#import "MYLocalizationSystem.h"

@implementation MYLocalizationSystem

static MYLocalizationSystem * _sharedManager = nil;

+ (id)sharedManager
{
    if (_sharedManager == nil)
    {
        @synchronized(self)
        {
            _sharedManager = [[MYLocalizationSystem alloc] init];
        }
    }
    
    
    return _sharedManager;
}

- (void)setLanguage:(NSString *)lang
{
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    if (!path)
    {
        _bundle = [NSBundle mainBundle];
        NSLog(@"Warning: No lproj for %@, system default set instead !", lang);
        return;
    }
    
    _bundle = [NSBundle bundleWithPath:path];
}

@end
