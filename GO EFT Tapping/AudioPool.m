//
//  AudioPool.m
//  iTourTheCaribbean
//
//  Created by champion on 11. 8. 17..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AudioPool.h"


@implementation AudioPool


static AVAudioPlayer *shared = nil;

+ (void)playSound:(NSURL *)url loop:(NSInteger)loop delegate:(id)delegate
{

	[AudioPool stopSound];
	
	if (url == nil)
		return;
	
	NSError *error = nil;
	shared = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	if (shared == nil) {
		NSLog(@"Audio play fail : %@", [error description]);
		return;
	}
	
	shared.delegate = delegate;
    shared.numberOfLoops = loop;
	[shared prepareToPlay];
	[shared play];
   
}

/*
+ (void) playSound:(NSString*) fileName extension: (NSString*) extension
{
    NSString * path = [[ NSBundle mainBundle ] pathForResource:fileName ofType:extension] ;
    shared = [AVAudioPlayer alloc];
    AVAudioPlayer * audioPlayer = [AVAudioPlayer alloc];

    NSError * error = nil ;
    NSData * data = [ NSData dataWithContentsOfFile:path] ;
    if ( !data )
    {
        if ( error ) { @throw error ; }
    }
    if (data)
    {
               
        if ([audioPlayer initWithData:data error:NULL]){
            
        }
        else
            
        {
            audioPlayer = nil;
        }
    }
 
    shared = data ? [[AVAudioPlayer alloc] initWithData:data error:&error ] : nil ;
    if ( !shared )
    {
        if ( error ) { @throw error ; }
    }
 
    if ( audioPlayer )
    {
        [audioPlayer play];
       
    }
}*/
+ (void)pauseSound {
	if (shared && shared.playing) {
		[shared pause];
	}
}

+ (void)stopSound {
	if (shared) {
		[shared stop];
        shared.delegate = nil;
		shared = nil;
	}
}

+ (void)replaySound {
	if (shared && ! shared.playing) {
        
		[shared play];
	}
}

+ (NSTimeInterval)getDuration {
	return (shared) ? shared.duration : 0;
}

+ (NSTimeInterval)getCurrentTime {
	return (shared) ? shared.currentTime : 0;
}

+ (void)setCurrentTime:(NSTimeInterval)currTime {
    if (shared) {
        shared.currentTime = currTime;
    }
}

+ (void)setVolume:(float)volume
{
    if (shared) {
        shared.volume = volume;
    }
}
@end
