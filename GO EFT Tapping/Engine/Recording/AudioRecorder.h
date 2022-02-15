//
//  AudioRecorder.h
//  GolfSwingAnalysis
//
//  Created by Top1 on 7/26/13.
//  Copyright (c) 2013 Zhemin Yin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioRecorder : NSObject
{
    NSString * fileName;
}

@property(nonatomic, retain) id<AVAudioRecorderDelegate> delegate;
@property(nonatomic, retain) AVAudioRecorder * m_recorder;
@property(nonatomic, retain) NSString* fileName;

+ (NSString *)defaultOutputPath: (NSString*) fileName;

- (void)startRecording;
- (void)stopRecording;

@end