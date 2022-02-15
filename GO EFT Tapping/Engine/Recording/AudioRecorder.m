//
//  AudioRecorder.m
//  GolfSwingAnalysis
//
//  Created by Top1 on 7/26/13.
//  Copyright (c) 2013 Zhemin Yin. All rights reserved.
//

#import "AudioRecorder.h"
#import <AudioToolbox/AudioServices.h>

@implementation AudioRecorder
@synthesize m_recorder, fileName;

+ (NSString *)defaultOutputPath: (NSString*) fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    return [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
}

- (void)startRecording
{
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    BOOL success;
    NSError *error;
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    success = [session setCategory:AVAudioSessionCategoryPlayAndRecord
                    withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker|AVAudioSessionCategoryOptionAllowBluetooth
                          error:&error];
    if (!success) {
        NSLog(@"AVAudioSession error overrideOutputAudioPort:%@",error);
    
    }
    
    // client dictionary
    NSDictionary *recordsettings = [NSDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                      [NSNumber numberWithFloat:11025.0], AVSampleRateKey,
                      [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                      [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                      nil];
    
    NSString *strRecordingFilePath = [AudioRecorder defaultOutputPath: fileName];
//    if ([[NSFileManager defaultManager] fileExistsAtPath:strRecordingFilePath])
//        [[NSFileManager defaultManager] removeItemAtPath:strRecordingFilePath error:nil];
    m_recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:strRecordingFilePath]
                                             settings:recordsettings
                                                error:nil];
    
    m_recorder.delegate = self.delegate;
    [m_recorder prepareToRecord];
    m_recorder.meteringEnabled = YES;
    [m_recorder record];
}

- (void)stopRecording
{
    [m_recorder stop];
    //[[AVAudioSession sharedInstance] setActive: NO error: nil];
}
@end
