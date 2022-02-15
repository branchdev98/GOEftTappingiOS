//
//  PlayViewController.h
//  GO EFT Tapping
//
//  Created by Mountain on 11/9/12.
//  Copyright (c) 2012 Long Hei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController
{
    int play_file_index;
    bool recording_play;
       bool R;
    bool paused;
    
    bool isBridge;
    
}

@property (nonatomic, weak) IBOutlet UIButton * btnPlay;
@property (nonatomic, weak) IBOutlet UIButton * btnPause;
@property (nonatomic, weak) IBOutlet UIButton * btnNext;

@property (nonatomic, weak) IBOutlet UIButton * btnPurchase;
@property (nonatomic, weak) IBOutlet UIButton * btnBridge;
@property (nonatomic, weak) IBOutlet UIButton * btnRestore;

@property (nonatomic, strong) NSDictionary * soundData;
@property (nonatomic, strong) NSString  * soundFile;

@property (nonatomic ,weak) IBOutlet UIImageView  *imageView;
@property (nonatomic ,weak) IBOutlet UIImageView *backgroundImageView;

- (IBAction)onBridege:(id)sender;
- (IBAction)onPurchase:(id)sender;
- (IBAction)onRestore:(id)sender;

@end
