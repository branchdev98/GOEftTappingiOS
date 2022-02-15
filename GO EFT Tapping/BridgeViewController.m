//
//  BridgeViewController.m
//  GO EFT Tapping
//
//  Created by AnCheng on 8/15/16.
//  Copyright © 2016 Long Hei. All rights reserved.
//

#import "BridgeViewController.h"
#import "AudioPool.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Utils.h"

@interface BridgeViewController ()

@end

@implementation BridgeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    anaudio_recorder = [[AudioRecorder alloc] init];
    
    self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_F1" ofType:@"mp3"];
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) viewWillAppear:(BOOL)animated
{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    [super viewWillAppear:animated];

}

- (void)prepareAudio
{
    @autoreleasepool {
        
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                                               error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        if (!self.soundFile) return;
        
        [AudioPool playSound:[NSURL fileURLWithPath:self.soundFile] loop:0 delegate:self];
        NSLog(@"%@", self.soundFile);
                
    }
}

-(IBAction) onHome:(id) sender
{
    [AudioPool stopSound];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction) onRecord:(id)sender
{
    _recordBtn.hidden = YES;
    _recordbtnLbl.hidden = YES;
    _pauseBtn.hidden = YES;
    _recordLbl.hidden = NO;
    _stopBtn.hidden = NO;
    
    [AudioPool pauseSound];

    anaudio_recorder.fileName = @"bridge_recording.wav";
    [anaudio_recorder startRecording];
    
}

- (IBAction)onStop:(id)sender
{
    [anaudio_recorder stopRecording];
    
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)onPause:(id)sender
{
    _pauseBtn.selected = !_pauseBtn.selected;
    if (_pauseBtn.isSelected)
        [AudioPool pauseSound];
    else
        [AudioPool replaySound];
}

-(void) onPlayRecording
{
    NSString * symptom_recording  = [Utils getSavingPath];
    symptom_recording = [symptom_recording stringByAppendingPathComponent:@"symptom_recording.wav"];
    self.soundFile  = symptom_recording;
    
    //self.soundFile = symptom_recording;
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];
    
}

-(void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully:(BOOL)flag
{
    if ([self.soundFile rangeOfString:@"Audio_F1"].location != NSNotFound)
    {
        [self onPlayRecording];

    }
    else if ([self.soundFile rangeOfString:@"symptom_recording.wav"].location != NSNotFound)
    {
        self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_F2" ofType:@"mp3"];
        [self prepareAudio];

    }
}

@end
