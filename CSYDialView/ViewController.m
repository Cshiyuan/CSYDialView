//
//  ViewController.m
//  CSYDialView
//
//  Created by chenshyiuan on 2017/3/2.
//  Copyright © 2017年 chenshyiuan. All rights reserved.
//

#import "ViewController.h"
#import "CSYDialView.h"

@interface ViewController () <CSYDialViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    CSYDialView *dialView = [CSYDialView getDialViewFromXib];
    dialView.frame = CGRectMake(100, 300, 200, 200);
    dialView.delegate = self;
    
    [self.view addSubview:dialView];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma -mark CSYDialViewDelegate
- (void) clickGoButtonView:(NSString *)string
{
    NSLog(@"%@",string);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
