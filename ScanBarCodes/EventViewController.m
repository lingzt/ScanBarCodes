//
//  EventViewController.m
//  ScanBarCodes
//
//  Created by ling toby on 7/27/16.
//  Copyright © 2016 Infragistics. All rights reserved.
//

#import "EventViewController.h"

@interface EventViewController ()

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"scannedResult is$$$$$$$$$$$$$$$$$$$$$$$$$$ %@ ",_scannedResult);
    // Do any additional setup after loading the view.
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

@end
