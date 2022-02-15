//
//  ViewController.h
//  GO EFT Tapping
//
//  Created by Mountain on 11/6/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h> 
#import <AVFoundation/AVFoundation.h>
@interface ViewController : UIViewController <MFMailComposeViewControllerDelegate, AVAudioPlayerDelegate>
{
    bool playing;
    bool interruptedOnPlayback;
}
@property (weak, nonatomic) IBOutlet UISlider * slider;
@property (strong, nonatomic) NSTimer * sliderTimer;

@property (weak, nonatomic) IBOutlet UILabel * lblCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel * lblDuration;

@property (weak, nonatomic) IBOutlet UIButton * btnPlay;
@property (weak, nonatomic) IBOutlet UIButton * btnPause;

@property (nonatomic ,weak) IBOutlet UIButton *translateBtn;
@property (weak, nonatomic) IBOutlet UIView    *subView2;

@property (strong, nonatomic) NSString* soundFile;
@property (strong, nonatomic) NSURL* soundURL;
-(IBAction) onIntro: (id) sender;


-(IBAction) onYourEFT: (id) sender;


-(IBAction) onBookEFT: (id) sender;


-(IBAction) onVisitUs: (id) sender;

- (IBAction)onTranslateEnglish:(id)sender;
- (IBAction)onTranslateArabic:(id)sender;

- (IBAction)onFB:(id)sender;
- (IBAction)onShare:(id)sender;

@end
