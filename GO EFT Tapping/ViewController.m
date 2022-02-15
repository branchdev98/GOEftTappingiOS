//
//  ViewController.m
//  GO EFT Tapping
//
//  Created by Mountain on 11/6/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import "ViewController.h"
#import "IntroViewController.h"
#import "YourEFTViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "AudioPool.h"
#import "MYLocalizationSystem.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <TwitterCore/TwitterCore.h>
#import <Twitter/Twitter.h>
#import <TwitterKit/TWTRComposer.h>
#import <TwitterKit/TWTRComposerViewController.h>
#import <TwitterKit/TWTRTwitter.h>
#import <SwiftRater/SwiftRater-Swift.h>

#define AUDIO_FILE  @"Audio_B"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;

    _translateBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _translateBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_translateBtn setTitle: [NSString stringWithFormat:NSLocalizedString(@"TRANSLATE", nil)] forState: UIControlStateNormal];
    
	// Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;

     self.soundFile = [[NSBundle mainBundle] pathForResource:@"Audio_B" ofType:@"mp3"];
    [self prepareAudio];
     self.sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
  
    [AudioPool stopSound];

    [UIApplication sharedApplication].idleTimerDisabled = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [SwiftRater check];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction) onIntro: (id) sender
{
    
    [self performSegueWithIdentifier:@"introSegue" sender:nil];
    
}

-(IBAction) onYourEFT: (id) sender
{
   
    [self performSegueWithIdentifier:@"eftSegue" sender:nil];
}

-(IBAction) onBookEFT: (id) sender
{
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [[controller navigationItem].rightBarButtonItem setTintColor:[UIColor blueColor]];
    if ([MFMailComposeViewController canSendMail])
    {
        [controller setSubject:@""];
        [controller setSubject: @"I want to book an EFT session"];
        //NSArray * array = [[NSArray alloc] initWithObjects:@"info@EFT.Lifecoaching4U.net", nil];
        NSArray * array = [[NSArray alloc] initWithObjects:@"GOEFTTapping@EmotionalFreedomTechnique.biz", nil];
        
        [controller setToRecipients: array];
        controller.mailComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }

}

-(IBAction) onVisitUs: (id) sender
{
    //NSString *phoneURLString = @"http://www.EmotionalFreedomTechnique.biz";
    NSString *phoneURLString = @"http://a-golden-opportunity.com/";
    NSURL *phoneURL =[ NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
}

- (IBAction)onReminder:(id)sender
{
    NSString *phoneURLString = @"https://mailchi.mp/92e7b7290cc0/eft-tapping-reminders";
    NSURL *phoneURL =[ NSURL URLWithString:phoneURLString];
    [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:nil];
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
        
        //[self onPlaySound:nil];
        [self onPause:nil];
        
        self.slider.maximumValue = [AudioPool getDuration];
        
        int maxvalue = [AudioPool getDuration];
        NSString * str = [NSString stringWithFormat:@"%d:%02d", maxvalue / 60, maxvalue % 60];
        [self.lblDuration setText:str];
    }
}

-(IBAction)onPlaySound:(id)sender{
    
    @autoreleasepool {
        
        [AudioPool replaySound];
    }
    self.btnPlay.hidden = YES;
    self.btnPause.hidden = NO;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)onStop:(UIButton*) sender{
    
    [AudioPool pauseSound];
}
-(IBAction)onPause:(UIButton *)sender{
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [AudioPool pauseSound];
    self.btnPlay.hidden = NO;
    self.btnPause.hidden = YES;
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
	switch (result) {
		case MFMailComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MFMailComposeResultFailed:
            
			break;
		case MFMailComposeResultSent:
            
			break;
		default:
			break;
	}
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void) updateSlider{
    self.slider.value = [AudioPool getCurrentTime];
    int intvalue = self.slider.value;
    NSString * str = [NSString stringWithFormat:@"%d:%02d", intvalue/ 60, intvalue%60];
    
    [self.lblCurrentTime setText:str];
    
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer*)player{
    
          
    self.btnPlay.hidden = NO;
    self.btnPause.hidden = YES;
  
}

-(void)audioPlayerEndInterruption:(AVAudioPlayer*)player{
    
}

-(IBAction)sliderChanged:(UISlider *)sender{
    //    [AudioPool pauseSound];
    [AudioPool setCurrentTime:self.slider.value];
}

-(void) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully:(BOOL)flag {
    
    if (flag == YES){
             //  [self.sliderTimer invalidate];
        self.btnPlay.hidden = NO;
        self.btnPause.hidden = YES;
    }
}

- (IBAction)onTranslateEnglish:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert"
                                  message:@"Application will exit , Please reopen application."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             
                             [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"en", nil] forKey:@"AppleLanguages"];
                             [[NSUserDefaults standardUserDefaults] synchronize];
                             
                             exit(0);

                         }];
    [alert addAction:ok]; // add action to uialertcontroller
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)onTranslateArabic:(id)sender
{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Alert"
                                  message:@"Application will exit , Please reopen application."
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [[NSUserDefaults standardUserDefaults] setObject:[NSArray arrayWithObjects:@"ar", nil] forKey:@"AppleLanguages"];
                             [[NSUserDefaults standardUserDefaults] synchronize];                             
                             exit(0);
                             
                             
                         }];
    [alert addAction:ok]; // add action to uialertcontroller
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)onFB:(id)sender
{
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/go-eft-tapping/id582597439?mt=8"];
    content.hashtag = [FBSDKHashtag hashtagWithString:@"#Stress"];
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
    dialog.shareContent = content;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fbauth2://"]]){
        dialog.mode = FBSDKShareDialogModeNative;
    }
    else {
        dialog.mode = FBSDKShareDialogModeBrowser; //or FBSDKShareDialogModeAutomatic
    }
    [dialog show];
}

- (IBAction)onShare:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        NSString *status =@"I just used this app for stress reduction, GO EFT Tapping. Perhaps it might be good for you too? \n https://itunes.apple.com/us/app/go-eft-tapping/id582597439?mt=8 \n\n #stress #GOEFTTapping";
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[status] applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop ,UIActivityTypePostToFacebook];
        UIButton *button = (UIButton *)sender;
        activityVC.popoverPresentationController.sourceView = self.view;
        activityVC.popoverPresentationController.sourceRect = button.frame;
        [self presentViewController:activityVC animated:YES completion:nil];

    }else{
        NSString *status =@"https://itunes.apple.com/us/app/go-eft-tapping/id582597439?mt=8 \n\n #stress #GOEFTTapping";
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[status] applicationActivities:nil];
        activityVC.excludedActivityTypes = @[UIActivityTypeAirDrop ,UIActivityTypePostToFacebook];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    
    // twitter sharing
    /*
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    [composer setText:@"https://itunes.apple.com/us/app/go-eft-tapping/id582597439?mt=8 I just used this app for stress reduction, GO EFT Tapping. Perhaps it might be good for you too? #stress #GOEFTTapping"];
    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else {
            NSLog(@"Sending Tweet!");
        }
    }];
    
    if ([[Twitter sharedInstance].sessionStore hasLoggedInUsers]) {
        TWTRComposerViewController *composer = [[TWTRComposerViewController alloc] initWithInitialText:@"https://itunes.apple.com/us/app/go-eft-tapping/id582597439?mt=8 I just used this app for stress reduction, GO EFT Tapping. Perhaps it might be good for you too? #stress #GOEFTTapping" image:nil videoURL:nil];
        [self presentViewController:composer animated:YES completion:nil];
    } else {
        [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
            if (session) {
                TWTRComposerViewController *composer = [TWTRComposerViewController emptyComposer];
                [self presentViewController:composer animated:YES completion:nil];
            } else {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"No Twitter Accounts Available" message:@"You must log in before presenting a composer." preferredStyle:UIAlertControllerStyleAlert];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    }*/
}

@end
