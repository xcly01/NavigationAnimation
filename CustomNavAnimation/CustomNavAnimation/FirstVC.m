//
//  RootVC.m
//  CustomNavAnimation
//
//  Created by liyang on 16/3/23.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "FirstVC.h"
#import "ViewController.h"

@interface FirstVC ()

@end

@implementation FirstVC

- (IBAction)popVC:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
