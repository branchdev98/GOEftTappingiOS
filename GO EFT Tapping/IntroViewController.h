//
//  IntroViewController.h
//  GO EFT Tapping
//
//  Created by Mountain on 11/8/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface IntroViewController : UIViewController<AVAudioPlayerDelegate>

@property (strong, nonatomic) NSURL* soundURL;
@property (strong, nonatomic) NSString* soundFile;

@property (weak, nonatomic) IBOutlet UISlider * slider;
@property (strong, nonatomic) NSTimer * sliderTimer;

@property (weak, nonatomic) IBOutlet UILabel * lblCurrentTime;
@property (weak, nonatomic) IBOutlet UILabel * lblDuration;

@property (weak, nonatomic) IBOutlet UIButton * btnPlay;
@property (weak, nonatomic) IBOutlet UIButton * btnPause;
@property (weak, nonatomic) IBOutlet UIView    *subView2;
@property (nonatomic ,weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic ,weak) IBOutlet UIWebView *webView;

-(void) updateSlider;

@end
