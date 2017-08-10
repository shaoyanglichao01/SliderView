//
//  ViewController.m
//  LCSliderViewExample
//
//  Created by lichao on 2017/8/10.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import "ViewController.h"
#import "LCSliderView.h"

@interface ViewController ()<LCSliderViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  NSArray *array = @[@"0", @"100", @"200", @"300", @"400", @"500", @"不限"];
  LCSliderView *sliderView = [[LCSliderView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100)];
  sliderView.delegate = self;
  sliderView.levelArray = array;
  sliderView.leftSelectIndex = 0;
  sliderView.rightSelectIndex = array.count-1;
  [self.view addSubview:sliderView];
}

- (void)sliderViewSelectFinished:(NSInteger)leftIndex RightIndex:(NSInteger)rightIndex {
  NSLog(@"leftIndex:%d,rightIndex:%d",leftIndex,rightIndex);
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


@end
