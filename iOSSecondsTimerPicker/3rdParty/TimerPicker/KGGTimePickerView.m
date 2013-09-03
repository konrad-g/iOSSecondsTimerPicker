//
//  KGGTimePickerView.m
//  iOSSecondsTimerPicker
//
//  Created by Admin on 02.09.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import "KGGTimePickerView.h"
#import "KGGTimePickerConsts.h"

@implementation KGGTimePickerView

- (id)initWithParams
{
    self = [super init];
    if (self) {
        
        //init all params
        
    }
    return self;
}

+ (KGGTimePickerView *)makeView {
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"KGGTimePickerView" owner:self options:nil];
    //UIView *mainView = [subviewArray objectAtIndex:0];
    
    KGGTimePickerView *mainView;
    for (id object in bundle) {
        if ([object isKindOfClass:[KGGTimePickerView class]])
            mainView = (KGGTimePickerView *)object;
    }
    
    assert(mainView != nil);
    return mainView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       //init all params
        
    }
    return self;
}

- (void)didMoveToSuperview {
    [self initPicker];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
      //init all params
        
    }
    return self;
    
}

- (void) initPicker {
    
    [self hidePicker:NO];
    
}

- (void) showPicker:(BOOL) animated {
    
    //check if view is already animating and if isn't already shown
    if([self isAnimating] || ![self isHidden]) {
        return;
    }
    
    [self setHidden:NO];
    
    if(animated) {
        //setup animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIM_TIME_SEC];
        
        [self setIsAnimating:YES];
    }
    
    //at first get screen size
    int screenWidth = self.superview.frame.size.width;
    int screenHeight = self.superview.frame.size.height;
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    //hide timer below the screen
    float x = (screenWidth - width)/2;
    
    [self setFrame:CGRectMake(x, (screenHeight - height), width, height)];
    
    
    if(animated) {
        [UIView commitAnimations];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, ANIM_TIME_SEC * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self setIsAnimating:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_SHOW_PICKER  object:nil userInfo:nil];
        });
            
    }
    
}

- (void) hidePicker:(BOOL) animated {
    
    if(animated) {
        //setup animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIM_TIME_SEC];
        
        [self setIsAnimating:YES];
        [self setHidden:NO];
    }
    
    //at first get screen size
    int screenWidth = self.superview.frame.size.width;
    int screenHeight = self.superview.frame.size.height;
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    //show timer above the screen bottom line
    float x = (screenWidth - width)/2;
    
    [self setFrame:CGRectMake(x, screenHeight, width, height)];
    
    
    if(animated) {
        [UIView commitAnimations];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, ANIM_TIME_SEC * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self setIsAnimating:NO];
            [self setHidden:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_HIDE_PICKER  object:nil userInfo:nil];
        });
        
    } else {
        [self setHidden:YES];
    }
}

- (void) togglePicker {
    if([self isAnimating]) {
        return;
    }
    
    if([self isHidden]) {
        [self showPicker:YES];
    } else {
        [self hidePicker:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
