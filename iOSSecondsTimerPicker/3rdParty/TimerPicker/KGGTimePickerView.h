//
//  KGGTimePickerView.h
//  iOSSecondsTimerPicker
//
//  Created by Admin on 02.09.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGTimePickerView : UIView

- (id) initWithParams;
+ (KGGTimePickerView*) makeView;
- (void) showPicker:(BOOL) animated;
- (void) hidePicker:(BOOL) animated;
- (void) togglePicker;

@property BOOL isAnimating;

@end
