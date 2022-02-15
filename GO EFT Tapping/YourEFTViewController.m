//
//  YourEFTViewController.m
//  GO EFT Tapping
//
//  Created by Mountain on 11/8/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import "YourEFTViewController.h"
#import "PlayViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPool.h"
#import "Utils.h"
#import "AudioRecorder.h"
#import <AudioToolbox/AudioServices.h>

#define SYMPTOM_FILENAME    @"symptom_recording.wav"
#define INTENSITY_FILENAME    @"intensity_recording.wav"

@interface YourEFTViewController ()

@end

@implementation YourEFTViewController

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
    
    anaudio_recorder = [[AudioRecorder alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    NSLog(@"countryCode %@" ,language);
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@_checked" ,language]]){
        self.btnCheck_ON.hidden = NO;
        self.btnCheck.hidden = YES;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [AudioPool stopSound];
    
}

-(IBAction)onEFTCheck: (id) sender
{
    self.btnCheck_ON.hidden = NO;
    self.btnCheck.hidden = YES;
    
    self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_D1" ofType:@"mp3"];
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];

    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@_checked" ,language]];
}

-(IBAction)onSymptom: (id) sender
{
    
  // recording = YES;
    self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_D2" ofType:@"mp3"];
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];

    [self.btnRecord setTitle:NSLocalizedString(@"Record XXX" , nil) forState:UIControlStateNormal];
    self.btnRecord.alpha = 1.0f;

}

- (IBAction) onRecord: (id) sender
{
    self.btnRecord.alpha = 0.0f;
    
    [AudioPool stopSound];
    NSString * recordName;
    if ([self.soundFile isEqualToString: [[NSBundle mainBundle] pathForResource:@"Audio_D2" ofType:@"mp3"]] == YES)
    {
        recordName =SYMPTOM_FILENAME;
    }
    else
    {
        recordName =INTENSITY_FILENAME;
    }
  
    self.lblStatus.alpha = 1.0f;
    self.btnStop.alpha = 1.0f;
    // self.lblSymptom.alpha = 0.0f;
    self.btnCheck.enabled = NO;
    self.btnCheck_ON.enabled = NO;
    self.btnGo.enabled = NO;
    self.btnIntensity.enabled = NO;
    self.btnSymptom.enabled = NO;
    self.btnHome.enabled = NO;
    
    if ([recordName isEqualToString:SYMPTOM_FILENAME] == YES) //this is symptom recording, so I will show status message
    {
        self.lblStatus.text = [NSString stringWithFormat:NSLocalizedString(@"Recording XXX...", nil)];
        self.lblSymptom.text = [NSString stringWithFormat:NSLocalizedString(@"My feeling or symptom is..." , nil)]; //set button text to recording state;
    }
    else if ([recordName isEqualToString:INTENSITY_FILENAME] == YES)    // this is SUD recording
    {
        self.lblStatus.text = [NSString stringWithFormat:NSLocalizedString(@"Recording intensity..." , nil)];
//        self.lblIntensity.text = [NSString stringWithFormat:NSLocalizedString(@"The intensity is (0->10)..." , nil)]; //set button text to recording state;
    }

    [anaudio_recorder stopRecording];
    anaudio_recorder.fileName = recordName;
    [anaudio_recorder startRecording];
}

-(IBAction)onIntensity: (id) sender
{
   // recording = YES;
    self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_D3" ofType:@"mp3"];
    //[NSThread detachNewThreadSelector:@selector(prepareAudio) toTarget:self withObject:nil];
    [self prepareAudio];
    //[self.btnRecord setTitle:@"RECORD SUD" forState:UIControlStateNormal];
    
    [self.btnRecord setTitle:NSLocalizedString(@"Record intensity" ,nil) forState:UIControlStateNormal];
    self.btnRecord.alpha = 1.0f;

}

-(IBAction)onEFTCheckOff: (id) sender
{
    self.btnCheck_ON.hidden = YES;
    self.btnCheck.hidden = NO;
    [AudioPool stopSound];
    
}
-(IBAction) onHome:(id) sender
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(IBAction)onTapping:(id) sender
{
    if (self.btnCheck_ON.hidden == YES || [self.lblSymptom.text isEqualToString:NSLocalizedString(@"My feeling or symptom is recorded" ,nil)] == NO || [self.lblIntensity.text isEqualToString:NSLocalizedString(@"The intensity is recorded" ,nil)] == NO)
    {
        self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_D4" ofType:@"mp3"];
        [self prepareAudio];
        return;
    }
   
    [self performSegueWithIdentifier:@"playSegue" sender:nil];
}

-(IBAction)onPlaySound:(id)sender{
    
    @autoreleasepool {
        
        [AudioPool replaySound];
    }
    
}

- (void)prepareAudio
{
    @autoreleasepool {
        

        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback
                                         withOptions:AVAudioSessionCategoryOptionAllowBluetooth
                                               error:nil];
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        if (!self.soundFile) return;
     
        [AudioPool playSound:[NSURL fileURLWithPath:self.soundFile] loop:0 delegate:self];
        NSLog(@"%@", self.soundFile);
                
        [self onPlaySound:nil];
        
    }
}

-(IBAction)onPlay:(UIButton *)sender{
    @autoreleasepool {
        
    }
    
}
- (IBAction)onStop:(UIButton*) sender{
    
    [AudioPool stopSound];
}
-(void)onPause:(UIButton *)sender{
    [AudioPool pauseSound];
}


-(IBAction)onStopRecording:(id)sender{

    self.lblStatus.alpha = 0.0f;
    self.btnStop.alpha = 0.0f;
    self.btnCheck.enabled = YES;
    self.btnCheck_ON.enabled = YES;
    self.btnGo.enabled = YES;
    self.btnIntensity.enabled = YES;
    self.btnSymptom.enabled = YES;
    self.btnHome.enabled = YES;
    
    [anaudio_recorder stopRecording];
    if ([self.soundFile isEqualToString: [[NSBundle mainBundle] pathForResource:@"Audio_D2" ofType:@"mp3"]] == YES)
    {
        //[self.lblSymptom setText:@"My feeling or symptom is recorded"];
        [self.lblSymptom setText:NSLocalizedString(@"My feeling or symptom is recorded" ,nil)];

    }
    if ([self.soundFile isEqualToString: [[NSBundle mainBundle] pathForResource:@"Audio_D3" ofType:@"mp3"]] == YES)
    {
        //[self.lblIntensity setText:@"The intensity is recorded"];
        [self.lblIntensity setText:NSLocalizedString(@"The intensity is recorded" ,nil)];

    }

}

-(void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully:(BOOL)flag {
    
    if (flag == YES && recording == YES){
        
        recording = NO;
        NSString * recordName;
        if ([self.soundFile isEqualToString: [[NSBundle mainBundle] pathForResource:@"Audio_D2" ofType:@"mp3"]] == YES)
        {
            recordName =@"symptom_recording.wav";
        }
        else
        {
            recordName =@"intensity_recording.wav";
        }
        self.recordPath = [Utils getSavingPath];
        self.recordPath = [self.recordPath stringByAppendingPathComponent:recordName];
        
        
        NSDictionary *recordSettings;
        recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                          [NSNumber numberWithFloat:11025.0], AVSampleRateKey,
                          [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                          [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                          [NSNumber numberWithBool:YES], AVLinearPCMIsBigEndianKey,
                          [NSNumber numberWithBool:NO], AVLinearPCMIsFloatKey,
                          nil];
        NSError *error = nil;
        
        
        self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recordPath] settings:recordSettings error:&error];
        
        if (error) {
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Warning"
                                          message:[error localizedDescription]
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction * action)
                                 {
                                 }];
            [alert addAction:ok]; // add action to uialertcontroller
            [self presentViewController:alert animated:YES completion:nil];
            
        } else {
            if ([self.audioRecorder prepareToRecord]) {
                
                if ([recordName isEqualToString:@"symptom_recording.wav"] == YES)
                self.btnStop.hidden = NO;
                
                if ([recordName isEqualToString:@"intensity_recording.wav"] == YES)
                    self.btnStop.hidden = NO;
                
                [self.audioRecorder record];
                
            } else {

                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Warning"
                                              message:@"Can't record."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleCancel
                                     handler:^(UIAlertAction * action)
                                     {
                                     }];
                [alert addAction:ok]; // add action to uialertcontroller
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
}

@end
