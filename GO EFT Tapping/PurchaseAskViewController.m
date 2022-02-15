//
//  PurchaseAskViewController.m
//  GO EFT Tapping
//
//  Created by AnCheng on 2018/5/12.
//  Copyright © 2018 Long Hei. All rights reserved.
//

#import "PurchaseAskViewController.h"

@interface PurchaseAskViewController ()

@end

@implementation PurchaseAskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self showPurchase];
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

- (void)showPurchase{
    

    [[IAPManager sharedIAPManager] purchaseProductForId:@"com.sarabern.bridge"
                                             completion:^(SKPaymentTransaction *transaction) {
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 });
                                             } error:^(NSError *err) {
                                                 NSLog(@"An error occured while purchasing: %@", err.localizedDescription);
                                                 // show an error alert to the user.
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     
                                                     UIAlertController * alert=   [UIAlertController
                                                                                   alertControllerWithTitle:@"Alert"
                                                                                   message:@"In-app purchase failed."
                                                                                   preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction* ok = [UIAlertAction
                                                                          actionWithTitle:@"OK"
                                                                          style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)
                                                                          {
                                                                              [self.navigationController popViewControllerAnimated:YES];
                                                                              
                                                                          }];
                                                     [alert addAction:ok]; // add action to uialertcontroller
                                                     [self presentViewController:alert animated:YES completion:nil];
                                                     
                                                 });
                                             }];
}

@end
