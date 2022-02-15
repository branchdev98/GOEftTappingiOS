//
//  PlayViewController.m
//  GO EFT Tapping
//
//  Created by Mountain on 11/9/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import "PlayViewController.h"
#import "AudioPool.h"
#import <AudioToolbox/AudioToolbox.h>
#import "Utils.h"
@interface PlayViewController ()

@end

@implementation PlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    if ([UIScreen mainScreen].bounds.size.height == 480) {
                
        NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
        //NSLog(@"countryCode %@" ,language);
        
        if ([language isEqualToString:@"ar"])
        {
            _backgroundImageView.image = [UIImage imageNamed:@"Page E Background_960_arabic"];

        }
        else
        {
            _backgroundImageView.image = [UIImage imageNamed:@"Page E Background_960"];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([[IAPManager sharedIAPManager] hasPurchased:@"com.sarabern.bridge"]) {
        
        _btnBridge.hidden = NO;
        _btnPurchase.hidden = YES;
        _btnRestore.hidden = YES;

    }
    
    play_file_index = 0;
    if (isBridge)
    {
        play_file_index = 2;
        _btnNext.alpha = 0.4;
        _btnNext.userInteractionEnabled = NO;
        
        paused= NO;
    }
    
    [self onPlay: nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onPlay: (id) sender
{
    self.btnPause.hidden = NO;
    self.btnPlay.hidden = YES;
   
    if (paused == YES)
    {
        
        [AudioPool replaySound];
      
        paused= NO;
        return;
    }
    paused= NO;
    self.btnPause.hidden = NO;
    self.btnPlay.hidden = YES;

    NSString * string =[ NSString stringWithFormat:@"Audio_E%d", play_file_index+1 ];
    
    if (isBridge)
    {
        string =[ NSString stringWithFormat:@"Audio_F%d", play_file_index+1 ]; // audio F files
        
    }
    
    self.soundFile = [[NSBundle mainBundle] pathForResource:string ofType:@"mp3"];
    
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];

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

-(void) onPlayRecordingIntensity
{
    NSString * symptom_recording  = [Utils getSavingPath];
    
    symptom_recording = [symptom_recording stringByAppendingPathComponent:@"intensity_recording.wav"];
    
    self.soundFile  = symptom_recording;
    //self.soundFile = symptom_recording;
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];
    
}

-(void) onPlayRecordingPreferedEmotion
{
    NSString * emotion_recording  = [Utils getSavingPath];
    emotion_recording = [emotion_recording stringByAppendingPathComponent:@"bridge_recording.wav"];
    
    self.soundFile  = emotion_recording;
    //self.soundFile = symptom_recording;
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];
    
}

-(IBAction) onPause: (id) sender
{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.btnPause.hidden = YES;
    self.btnPlay.hidden = NO;
     [AudioPool pauseSound];
    paused = YES;
}

-(IBAction) onStop: (id) sender
{
    paused = NO;
     [UIApplication sharedApplication].idleTimerDisabled = NO;
    self.btnPause.hidden = YES;
    self.btnPlay.hidden = NO;
     [AudioPool pauseSound];
    R= NO;
    play_file_index = 0;
    if (isBridge)
    {
        play_file_index = 2;
    }
    
}

-(IBAction) onHome:(id) sender
{   [AudioPool stopSound];
    [self.navigationController popToRootViewControllerAnimated:YES];
 
    
}

-(IBAction)onPlaySound:(id)sender{
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    @autoreleasepool {
        
        [AudioPool replaySound];
    }
    
}

- (void)playSound:(NSString *)name withCompletion:(void (^)(void))completion {
   /*
    NSArray *sound = [self.soundData valueForKey:name];
    if (!sound) return;
    
 //   NSTimeInterval offset = [[sound objectAtIndex:0] floatValue];
    NSTimeInterval duration = [[sound objectAtIndex:1] floatValue];
    
//    audioPlayer.currentTime = offset;
    [AudioPool playSound:[NSURL fileURLWithPath:self.soundFile] loop:0 delegate:self];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_current_queue(), ^{
        [AudioPool pauseSound];
        completion();
    });*/
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
      //  NSLog(@"%@", self.soundFile);
                
        [self onPlaySound:nil];
        
    }
}

-(IBAction) onR:(id) sender
{
    
    play_file_index = 14;
    R= YES;
//    NSString * string =[ NSString stringWithFormat:@"Audio_E%d", play_file_index+1 ];
//    
//    self.soundFile = [[NSBundle mainBundle] pathForResource:string ofType:@"mp3"];
//    [NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
//    
//    
//    self.btnPause.hidden = NO;
//    self.btnPlay.hidden = YES;
    
    [self onPlay:nil];
}

-(void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully:(BOOL)flag {
    
 
    if (flag == YES){
        
        if (recording_play == NO)
        {
            if (isBridge)
            {
                if (play_file_index == 1)
                {
                    play_file_index++;
                    [self onPlay:nil];
                    recording_play = !recording_play;
                    
                }
                else if (play_file_index > 16)
                {
                    self.btnPause.hidden = YES;
                    self.btnPlay.hidden = NO;
                }
                else if (play_file_index == 16)
                {
                    [self onPlayRecordingPreferedEmotion];

                }
                else
                {
                    if (play_file_index % 2 == 0)
                        [self onPlayRecording];
                    else
                        [self onPlayRecordingPreferedEmotion];
                    
                }
            }
            else
            {
                if (R== NO)
                {
                    if (play_file_index == 12)
                    {
                        [self onPlayRecordingIntensity];
                        
                    }
                    if (play_file_index < 12)
                    {
                        [self onPlayRecording];
                    }
                    if (play_file_index> 12)
                    {
                        self.btnPause.hidden = YES;
                        self.btnPlay.hidden = NO;
                    }
                }
                else
                {
                    if (play_file_index == 21)
                    {
                        [self onPlayRecordingIntensity];
                        R= NO;
                        
                    }
                    if (play_file_index < 21)
                    {
                        [self onPlayRecording];
                    }
                    
                }
            }

        }
        else
        {
            play_file_index++;
            [self onPlay:nil];
        }
        
        recording_play = !recording_play;
        
    }
}

- (IBAction)onBridege:(id)sender
{
    isBridge = YES;

    [AudioPool stopSound];
    [self performSegueWithIdentifier:@"bridgeSegue" sender:nil];

}

- (IBAction)onPurchase:(id)sender
{
    [self onPause:nil];
    
    [self performSegueWithIdentifier:@"purchaseaskSegue" sender:nil];
    
}

- (IBAction)onRestore:(id)sender
{
    [self onPause:nil];

    [[IAPManager sharedIAPManager] restorePurchasesWithCompletion:^(void){
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
        
            self.btnBridge.hidden = NO;
            self.btnPurchase.hidden = YES;
            self.btnRestore.hidden = YES;
        });
    } error:^(NSError *error){
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Alert"
                                      message:@"In-app purchase restore failed."
                                      preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction
                             actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                             }];
        [alert addAction:ok]; // add action to uialertcontroller
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
}

@end
