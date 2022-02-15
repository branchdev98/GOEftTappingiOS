//
//  AudioPool.h
//  iTourTheCaribbean
//
//  Created by champion on 11. 8. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPool : NSObject<AVAudioPlayerDelegate>
{
    bool playing;
    bool interruptedOnPlayback;
    
}
+ (void)playSound:(NSURL *)url loop:(NSInteger)loop delegate:(id)delegate;
+ (void)pauseSound;
+ (void)stopSound;
+ (void)replaySound;
+ (NSTimeInterval)getDuration;
+ (NSTimeInterval)getCurrentTime;
+ (void)setCurrentTime:(NSTimeInterval)currTime;
+ (void)setVolume:(float)volume;
//+ (void) playSound:(NSString*) fileName extension: (NSString*) extension;
@end
