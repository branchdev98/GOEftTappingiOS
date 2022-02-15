//
//  BridgeViewController.h
//  GO EFT Tapping
//
//  Created by AnCheng on 8/15/16.
//  Copyright © 2016 Long Hei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioRecorder.h"

@interface BridgeViewController : UIViewController
{
    AudioRecorder *anaudio_recorder;

}

@property (strong, nonatomic) NSString* soundFile;

@property (nonatomic ,weak) IBOutlet UIButton *recordBtn;
@property (nonatomic ,weak) IBOutlet UIButton *stopBtn;
@property (nonatomic ,weak) IBOutlet UIButton *pauseBtn;

@property (nonatomic ,weak) IBOutlet UILabel *recordLbl;
@property (nonatomic ,weak) IBOutlet UILabel *recordbtnLbl;

@end
