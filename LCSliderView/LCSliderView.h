//
//  LCSliderView.h
//  LCSliderView
//
//  Created by lichao on 2017/8/10.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LCSliderViewDelegate <NSObject>

- (void)sliderViewSelectFinished:(NSInteger)leftIndex RightIndex:(NSInteger)rightIndex;

@end
@interface LCSliderView : UIControl

@property (nonatomic, strong) NSArray *levelArray;
@property (nonatomic, assign) NSInteger leftSelectIndex;
@property (nonatomic, assign) NSInteger rightSelectIndex;
@property (nonatomic, strong) UIColor *selectColor;
@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, weak) id<LCSliderViewDelegate> delegate;
@end
