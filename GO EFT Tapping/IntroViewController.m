//
//  IntroViewController.m
//  GO EFT Tapping
//
//  Created by Mountain on 11/8/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import "IntroViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPool.h"
@interface IntroViewController () <UIWebViewDelegate>

@end

@implementation IntroViewController

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
    
    [_webView setBackgroundColor:[UIColor whiteColor]];
    [_webView setOpaque:NO];
    _webView.delegate = self;
    //[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] isDirectory:NO]]];
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://a-golden-opportunity.com/go-eft-tapping-introduction/"]]];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"C_Played"];
    
    self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_C" ofType:@"mp3"];
    
    [self prepareAudio];
    self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
}

-(void) updateSlider{
    self.slider.value = [AudioPool getCurrentTime];
    int intvalue = self.slider.value;
    NSString * str = [NSString stringWithFormat:@"%d:%02d", intvalue/ 60, intvalue%60];
    
    [self.lblCurrentTime setText:str];
    
}

-(IBAction)sliderChanged:(UISlider *)sender{
//    [AudioPool pauseSound];
    [AudioPool setCurrentTime:self.slider.value];
}
-(void) viewWillDisappear:(BOOL)animated
{
     [UIApplication sharedApplication].idleTimerDisabled = NO;
    [super viewWillDisappear:animated];
     [AudioPool stopSound];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onHome: (id) sender
{
   
  //  [AudioPool stopSound];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (void)prepareAudio
{
    @autoreleasepool {
        
        if (!self.soundFile) return;
        
        [AudioPool playSound:[NSURL fileURLWithPath:self.soundFile] loop:0 delegate:self];
        NSLog(@"%@", self.soundFile);
       // url = nil;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"played_c"]){
            [self onPause:nil];
        }else{
            [self onPlay:nil];
        }
      
        self.slider.maximumValue = [AudioPool getDuration];

        int maxvalue = [AudioPool getDuration];
        NSString * str = [NSString stringWithFormat:@"%d:%02d", maxvalue / 60, maxvalue % 60];
        [self.lblDuration setText:str];
        
    }
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"played_c"];
}

-(void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully:(BOOL)flag
{
    if (flag){
     //   [self.sliderTimer invalidate];
        
            self.btnPlay.hidden = NO;
            self.btnPause.hidden = YES;
       
    }
}
-(IBAction)onPlay:(UIButton *)sender{
    @autoreleasepool {
        [AudioPool replaySound];
    }
    [UIApplication sharedApplication].idleTimerDisabled = YES;
   
    self.btnPlay.hidden = YES;
    self.btnPause.hidden = NO;
}
- (void)onStop:(UIButton*) sender{
    
    [AudioPool pauseSound];
}
-(IBAction)onPause:(UIButton *)sender{
    [AudioPool pauseSound];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
   
    self.btnPlay.hidden = NO;
    self.btnPause.hidden = YES;
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer*)player{
    
    
    self.btnPlay.hidden = NO;
    self.btnPause.hidden = YES;
    
    
}
-(void)audioPlayerEndInterruption:(AVAudioPlayer*)player{
    
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView* )webView shouldStartLoadWithRequest:(NSURLRequest* )request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL] options:@{} completionHandler:nil];
        return NO;
    }
    
    return YES;
}

@end

