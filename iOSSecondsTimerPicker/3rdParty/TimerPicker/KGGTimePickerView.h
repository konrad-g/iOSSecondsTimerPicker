//
//  KGGTimePickerView.h
//  iOSSecondsTimerPicker
//
//  Created by Admin on 02.09.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGLabeledPickerView.h"

@interface KGGTimePickerView : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

- (id) initWithParams;
+ (KGGTimePickerView*) makeViewAllowZero:(BOOL)canSetZero pickDays:(BOOL)pickDays maxDays:(int)maxDays initSumSeconds:(int)initSumSec;
- (void) showPicker:(BOOL) animated;
- (void) hidePicker:(BOOL) animated;
- (void) togglePicker;
- (NSInteger) sumSeconds;

@property BOOL isAnimating;
@property BOOL canSetZero;
@property BOOL pickDays;
@property BOOL isPortrait;
@property int maxDays;

@property int days;
@property int hours;
@property int mins;
@property int seconds;

@property int initDays;
@property int initHours;
@property int initMins;
@property int initSeconds;

@end
