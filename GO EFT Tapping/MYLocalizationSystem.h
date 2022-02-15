//
//  MYLocalizationSystem.h
//  GO EFT Tapping
//
//  Created by AnCheng on 8/24/16.
//  Copyright © 2016 Long Hei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MYLocalizationSystem : NSObject

@property (nonatomic, strong, readonly) NSBundle *bundle;

+ (id)sharedManager;
- (void)setLanguage:(NSString *)lang;

@end
