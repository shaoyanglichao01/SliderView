//
//  LCSliderView.m
//  LCSliderView
//
//  Created by lichao on 2017/8/10.
//  Copyright © 2017年 lichao. All rights reserved.
//

#import "LCSliderView.h"
#import <Foundation/NSBundle.h>

#define left_offset 20
#define right_offset 20
#define title_selected_distance 9
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface LCSliderView()

@property (nonatomic, strong) UIView *sliderbgView;
@property (nonatomic, strong) UIView *sliderView;
@property (nonatomic, strong) UIButton *leftSliderButton;
@property (nonatomic, strong) UIButton *rightSliderButton;
@property (nonatomic, assign) CGFloat oneSlotSize;
@property (nonatomic, assign) CGPoint leftDiffPoint;
@property (nonatomic, assign) CGPoint rightDiffPoint;

@end

@implementation LCSliderView

+ (NSBundle *)lc_slidrBundle {
  static NSBundle *sliderBundle = nil;
  if (!sliderBundle) {
    sliderBundle = [NSBundle bundleWithPath:[[NSBundle bundleForClass:[LCSliderView class]] pathForResource:@"sliderView" ofType:@"bundle"]];
  }
  return sliderBundle;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.selectColor = [UIColor colorWithRed:237/255.0 green:106/255.0 blue:59/255.0 alpha:1.0];
    self.normalColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1.0];
    [self addSubview:self.sliderbgView];
    [self.sliderbgView addSubview:self.sliderView];
    [self addSubview:self.leftSliderButton];
    [self addSubview:self.rightSliderButton];
    
  }
  return self;
}

- (void)updateContent {
  self.oneSlotSize = (self.frame.size.width-left_offset-right_offset-1)/(self.levelArray.count-1);
  for (int i = 0; i < self.levelArray.count; i++) {
    CGPoint center = [self getCenterPointForIndex:i IsLeft:YES];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 3, self.oneSlotSize, 10)];
    titleLabel.text = self.levelArray[i];
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = i < self.levelArray.count-1 ? self.normalColor : self.selectColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.tag = 50 + i;
    titleLabel.center = center;
    [self addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(center.x, center.y + 10, 1, 10)];
    lineView.backgroundColor = i < self.levelArray.count-1 ? self.normalColor : self.selectColor;
    lineView.tag = 100 + i;
    [self addSubview:lineView];
  }
}

#pragma mark - setter
- (void)setLevelArray:(NSArray *)levelArray {
  if (_levelArray != levelArray) {
    _levelArray = levelArray;
    [self updateContent];
  }
}

- (void)setLeftSelectIndex:(NSInteger)leftSelectIndex {
  _leftSelectIndex = leftSelectIndex;
  [self animateTitlesToIndex:leftSelectIndex IsLeft:YES];
  [self animateHandlerToIndex:leftSelectIndex IsLeft:YES];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)setRightSelectIndex:(NSInteger)rightSelectIndex {
  _rightSelectIndex = rightSelectIndex;
  [self animateTitlesToIndex:rightSelectIndex IsLeft:NO];
  [self animateHandlerToIndex:rightSelectIndex IsLeft:NO];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

#pragma mark - fileFunc
- (CGPoint)getCenterPointForIndex:(NSInteger)index IsLeft:(BOOL)isLeft {
  if (isLeft) {
    return CGPointMake((index/(float)(self.levelArray.count-1)) * (self.frame.size.width-right_offset-left_offset) + left_offset, 5);
  } else {
    return CGPointMake((index/(float)(self.levelArray.count-1)) * (self.frame.size.width-right_offset-left_offset) + left_offset, 5);
  }
}

- (CGPoint)fixFinalPoint:(CGPoint)pnt IsLeft:(BOOL)isLeft{
  if (isLeft) {
    if (pnt.x < left_offset-(self.leftSliderButton.frame.size.width/2.f)) {
      pnt.x = left_offset-(self.leftSliderButton.frame.size.width/2.f);
    } else if (pnt.x+(self.leftSliderButton.frame.size.width/2.f) > self.frame.size.width-right_offset){
      pnt.x = self.frame.size.width-right_offset- (self.leftSliderButton.frame.size.width/2.f);
      
    }
  } else {
    if (pnt.x < [self getCenterPointForIndex:self.leftSelectIndex+1 IsLeft:YES].x-self.leftSliderButton.frame.size.width/2.f) {
      pnt.x = [self getCenterPointForIndex:self.leftSelectIndex+1 IsLeft:YES].x-self.leftSliderButton.frame.size.width/2.f;
    } else if (pnt.x+(self.leftSliderButton.frame.size.width/2.f) > self.frame.size.width-right_offset){
      pnt.x = self.frame.size.width-right_offset- (self.leftSliderButton.frame.size.width/2.f);
    }
  }
  
  return pnt;
}

- (int)getSelectedTitleInPoint:(CGPoint)pnt IsLeft:(BOOL)isLeft{
  if (isLeft) {
    return round((pnt.x-left_offset)/self.oneSlotSize);
  } else {
    return round((pnt.x-left_offset)/self.oneSlotSize);
  }
}

- (void)animateHandlerToIndex:(NSInteger)index IsLeft:(BOOL)isLeft{
  if (isLeft) {
    CGPoint toPoint = [self getCenterPointForIndex:index IsLeft:isLeft];
    toPoint = CGPointMake(toPoint.x-(self.leftSliderButton.frame.size.width/2.f), self.leftSliderButton.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint IsLeft:isLeft];
    
    [UIView beginAnimations:nil context:nil];
    [self.leftSliderButton setFrame:CGRectMake(toPoint.x, toPoint.y, self.leftSliderButton.frame.size.width, self.leftSliderButton.frame.size.height)];
    self.sliderView.frame = CGRectMake(self.leftSliderButton.frame.origin.x+self.leftSliderButton.frame.size.width/2, 0, self.rightSliderButton.frame.origin.x+self.rightSliderButton.frame.size.width/2-(self.leftSliderButton.frame.origin.x+self.leftSliderButton.frame.size.width/2), 8);
    [UIView commitAnimations];
  } else {
    CGPoint toPoint = [self getCenterPointForIndex:index IsLeft:isLeft];
    toPoint = CGPointMake(toPoint.x-(self.rightSliderButton.frame.size.width/2.f), self.rightSliderButton.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint IsLeft:isLeft];
    
    [UIView beginAnimations:nil context:nil];
    [self.rightSliderButton setFrame:CGRectMake(toPoint.x, toPoint.y, self.rightSliderButton.frame.size.width, self.rightSliderButton.frame.size.height)];
    self.sliderView.frame = CGRectMake(self.leftSliderButton.frame.origin.x+self.leftSliderButton.frame.size.width/2, 0, self.rightSliderButton.frame.origin.x+self.rightSliderButton.frame.size.width/2-(self.leftSliderButton.frame.origin.x+self.leftSliderButton.frame.size.width/2), 8);
    [UIView commitAnimations];
  }
  
}

- (void)animateTitlesToIndex:(NSInteger)index IsLeft:(BOOL)isLeft{
  for (int i = 0; i < self.levelArray.count; i++) {
    UILabel *label = (UILabel *)[self viewWithTag:i+50];
    UIView *lineView = (UIView *)[self viewWithTag:i+100];
    if (isLeft) {
      label.textColor = i==index || i==self.rightSelectIndex ? self.selectColor : self.normalColor;
      lineView.backgroundColor = i==index || i==self.rightSelectIndex ? self.selectColor : self.normalColor;
    } else {
      label.textColor = i==index || i==self.leftSelectIndex ? self.selectColor : self.normalColor;
      lineView.backgroundColor = i==index || i==self.leftSelectIndex ? self.selectColor : self.normalColor;
    }
  }
}

#pragma mark -actions
- (void)sliderTouchDown: (UIButton *)btn withEvent:(UIEvent *)ev{
  CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
  if (btn == self.leftSliderButton) {
    self.leftDiffPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
  } else {
    self.rightDiffPoint = CGPointMake(currPoint.x - btn.frame.origin.x, currPoint.y - btn.frame.origin.y);
  }
  [self sendActionsForControlEvents:UIControlEventTouchDown];
}

- (void)sliderTouchUp:(UIButton*)btn{
  if (btn == self.leftSliderButton) {
    self.leftSelectIndex = [self getSelectedTitleInPoint:btn.center IsLeft:YES];
    [self animateHandlerToIndex:self.leftSelectIndex IsLeft:YES];
  } else {
    self.rightSelectIndex = [self getSelectedTitleInPoint:btn.center IsLeft:NO];
    [self animateHandlerToIndex:self.rightSelectIndex IsLeft:NO];
  }
  if ([_delegate respondsToSelector:@selector(sliderViewSelectFinished:RightIndex:)]) {
    [_delegate sliderViewSelectFinished:self.leftSelectIndex RightIndex:self.rightSelectIndex];
  }
  [self sendActionsForControlEvents:UIControlEventTouchUpInside];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)sliderTouchMove:(UIButton *)btn withEvent:(UIEvent *)ev {
  CGPoint currPoint = [[[ev allTouches] anyObject] locationInView:self];
  
  if (btn == self.leftSliderButton) {
    CGPoint toPoint = CGPointMake(currPoint.x-self.leftDiffPoint.x, self.leftSliderButton.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint IsLeft:YES];
    CGPoint lastPoint = [self getCenterPointForIndex:self.rightSelectIndex-1 IsLeft:YES];
    lastPoint = CGPointMake(lastPoint.x-(self.leftSliderButton.frame.size.width/2.f), self.leftSliderButton.frame.origin.y);
    if (toPoint.x >= lastPoint.x) {
      toPoint = CGPointMake(lastPoint.x, toPoint.y);
    }
    [self.leftSliderButton setFrame:CGRectMake(toPoint.x, toPoint.y, self.leftSliderButton.frame.size.width, self.leftSliderButton.frame.size.height)];
    int selected = [self getSelectedTitleInPoint:btn.center IsLeft:YES];
    [self animateTitlesToIndex:selected IsLeft:YES];
  } else {
    CGPoint toPoint = CGPointMake(currPoint.x-self.rightDiffPoint.x, self.rightSliderButton.frame.origin.y);
    toPoint = [self fixFinalPoint:toPoint IsLeft:NO];
    CGPoint lastPoint = [self getCenterPointForIndex:self.leftSelectIndex IsLeft:NO];
    lastPoint = CGPointMake(lastPoint.x+(self.rightSliderButton.frame.size.width/2.f), self.rightSliderButton.frame.origin.y);
    if (toPoint.x <= lastPoint.x) {
      toPoint = CGPointMake(lastPoint.x, toPoint.y);
    }
    [self.rightSliderButton setFrame:CGRectMake(toPoint.x, toPoint.y, self.rightSliderButton.frame.size.width, self.rightSliderButton.frame.size.height)];
    int selected = [self getSelectedTitleInPoint:btn.center IsLeft:NO];
    [self animateTitlesToIndex:selected IsLeft:NO];
  }
  self.sliderView.frame = CGRectMake(self.leftSliderButton.frame.origin.x+self.leftSliderButton.frame.size.width/2, 0, self.rightSliderButton.frame.origin.x+self.rightSliderButton.frame.size.width/2-(self.leftSliderButton.frame.origin.x+self.leftSliderButton.frame.size.width/2), 8);
  [self sendActionsForControlEvents:UIControlEventTouchDragInside];
}

#pragma mark - accessor
- (UIView *)sliderView {
  if (!_sliderView) {
    _sliderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-12, 8)];
    _sliderView.backgroundColor = self.selectColor;
  }
  return _sliderView;
}

- (UIView *)sliderbgView {
  if (!_sliderbgView) {
    _sliderbgView = [[UIView alloc] initWithFrame:CGRectMake(6, 45, self.bounds.size.width-12, 8)];
    _sliderbgView.backgroundColor = [UIColor grayColor];
    _sliderbgView.layer.cornerRadius = 4.0;
    _sliderbgView.layer.masksToBounds = YES;
    [_sliderbgView setClipsToBounds:YES];
  }
  return _sliderbgView;
}

- (UIButton *)leftSliderButton {
  if (!_leftSliderButton) {
    NSString *path = [[LCSliderView lc_slidrBundle] pathForResource:@"hotelslider@2x" ofType:@"png" inDirectory:@"images"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    _leftSliderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftSliderButton setFrame:CGRectMake(left_offset, 8, 45, 45)];
    [_leftSliderButton setCenter:CGPointMake(_leftSliderButton.center.x-(_leftSliderButton.frame.size.width/2.f), 49)];
    [_leftSliderButton setImage:image forState:UIControlStateNormal];
    [_leftSliderButton setImage:image forState:UIControlStateHighlighted];
    [_leftSliderButton setImageEdgeInsets:UIEdgeInsetsMake(2.5, 7, 2.5, 7)];
    [_leftSliderButton addTarget:self action:@selector(sliderTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [_leftSliderButton addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_leftSliderButton addTarget:self action:@selector(sliderTouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
  }
  return _leftSliderButton;
}

- (UIButton *)rightSliderButton {
  if (!_rightSliderButton) {
    NSString *path = [[LCSliderView lc_slidrBundle] pathForResource:@"hotelslider@2x" ofType:@"png" inDirectory:@"images"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    _rightSliderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightSliderButton setFrame:CGRectMake(self.frame.size.width - left_offset, 8, 45, 45)];
    [_rightSliderButton setCenter:CGPointMake(_rightSliderButton.center.x-(_rightSliderButton.frame.size.width/2.f), 49)];
    [_rightSliderButton setImage:image forState:UIControlStateNormal];
    [_rightSliderButton setImage:image forState:UIControlStateHighlighted];
    [_rightSliderButton setImageEdgeInsets:UIEdgeInsetsMake(2.5, 7, 2.5, 7)];
    [_rightSliderButton addTarget:self action:@selector(sliderTouchDown:withEvent:) forControlEvents:UIControlEventTouchDown];
    [_rightSliderButton addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    [_rightSliderButton addTarget:self action:@selector(sliderTouchMove:withEvent:) forControlEvents: UIControlEventTouchDragOutside | UIControlEventTouchDragInside];
  }
  return _rightSliderButton;
}

@end
