//
//  YourEFTViewController.h
//  GO EFT Tapping
//
//  Created by Mountain on 11/8/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AudioRecorder.h"

@interface YourEFTViewController : UIViewController
{
    bool recording;
    //AVAudioRecorder* audio_recorder;
    
    // an
    AudioRecorder *anaudio_recorder;

}

@property (nonatomic, weak) IBOutlet UIButton * btnCheck;
@property (nonatomic, weak) IBOutlet UIButton * btnCheck_ON;
@property (nonatomic, weak) IBOutlet UIButton * btnSymptom;
@property (nonatomic, weak) IBOutlet UIButton * btnIntensity;
@property (nonatomic, weak) IBOutlet UIButton * btnGo;
@property (nonatomic, weak) IBOutlet UIButton * btnHome;

@property (nonatomic, weak) IBOutlet UIButton * btnStop;

@property (nonatomic, weak) IBOutlet UILabel * lblSymptom;
@property (nonatomic, weak) IBOutlet UILabel * lblIntensity;


@property (nonatomic, strong) NSString * soundFile;
@property (nonatomic, strong) NSString * recordPath;


@property (nonatomic, weak) IBOutlet UIButton * btnRecord;
@property (nonatomic ,weak) IBOutlet UIImageView  *image;
   
@property (strong, nonatomic) AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) IBOutlet UILabel * lblStatus;

// an

//@property (strong, nonatomic) IBOutlet UILabel *lblRecording;

@end
