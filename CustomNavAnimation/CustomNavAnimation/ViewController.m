//
//  ViewController.m
//  CustomNavAnimation
//
//  Created by liyang on 16/3/23.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"
#import "FirstVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)pushVC:(id)sender
{
    [self.navigationController pushViewController:[FirstVC new] animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
