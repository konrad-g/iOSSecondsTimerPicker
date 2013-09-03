//
//  KGGTimePickerView.m
//  iOSSecondsTimerPicker
//
//  Created by Admin on 02.09.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import "KGGTimePickerView.h"
#import "KGGTimePickerConsts.h"
#import "KGGLabeledPickerView.h"
#import "math.h"

@implementation KGGTimePickerView

- (id)initWithParams
{
    self = [super init];
    if (self) {
        
        //init all params
        
    }
    return self;
}

+ (KGGTimePickerView *)makeViewAllowZero:(BOOL)canSetZero pickDays:(BOOL)pickDays maxDays:(int)maxDays initSumSeconds:(int)initSumSec{
    
    NSArray *bundle = [[NSBundle mainBundle] loadNibNamed:@"KGGTimePickerView" owner:self options:nil];
    //UIView *mainView = [subviewArray objectAtIndex:0];
    
    KGGTimePickerView *mainView;
    for (id object in bundle) {
        if ([object isKindOfClass:[KGGTimePickerView class]])
            mainView = (KGGTimePickerView *)object;
    }
    
    assert(mainView != nil);
    
    [mainView setCanSetZero:canSetZero];
    [mainView setPickDays:pickDays];
    [mainView setMaxDays:maxDays];
    
    //check if user passed zero value when is forbidden
    if(!canSetZero) {
        if(initSumSec == 0) {
            initSumSec = 1;
        }
    }
    
    int initDays = floor(initSumSec/86400);
    int initHours = floor((initSumSec - (initDays*86400))/3600);
    int initMins = floor((initSumSec - (initDays*86400) - (initHours * 3600))/60);
    int initSec = initSumSec - (initDays*86400) - (initHours * 3600) - (initMins*60);
    
    [mainView setDays:initDays];
    [mainView setMins:initMins];
    [mainView setHours:initHours];
    [mainView setSeconds:initSec];
    
    [mainView setInitDays:initDays];
    [mainView setInitMins:initMins];
    [mainView setInitHours:initHours];
    [mainView setInitSeconds:initSec];
    
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
    
    //register on orientation change listener
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotateFromInterfaceOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //register remote dismiss observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidePickerAnim) name:MSG_HIDE_PICKER object:nil];
    
    //[self addLabel:@"min" forComponent:1 forLongestString:@"min"];
    //[self selectRow:100000 inComponent:0 animated:NO];
}

-(NSInteger) sumSeconds {
    NSInteger result = [self seconds] + ([self mins]*60) + ([self hours]*3600) + ([self days]*86400);
    return result;
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([self pickDays]) {
      return 4;  
    } else {
        return 3;
    }
    
    
}


// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    //we simulate circular wheel effects
    return (([self numberOfRowsInComponent:component]*MAX_ROWS_RATIO) + (2*[self initPosInComponent:component]));
    
}
- (int) initPosInComponent: (NSInteger)component{
    switch (component) {
        case 0:
            if([self pickDays]) {
                return [self initDays];
            } else {
                return [self initHours];
            }
        case 1:
            if([self pickDays]) {
                return [self initHours];
            } else {
                return [self initMins];
            }
        case 2:
            if([self pickDays]) {
                return [self initMins];
            } else {
                return [self initSeconds];
            }
        case 3:
            return [self initSeconds];
            
    }
}

- (int) numberOfRowsInComponent: (NSInteger)component{
    switch (component) {
        case 0:
            if([self pickDays]) {
                return [self maxDays];
            } else {
                return MAX_HOURS;
            }
        case 1:
            if([self pickDays]) {
                return MAX_HOURS;
            } else {
                return MAX_MINS;
            }
        case 2:
            if([self pickDays]) {
                return MAX_MINS;
            } else {
                return MAX_SECS;
            }
        case 3:
            return MAX_SECS;
            
    }
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    int numberItems = [self numberOfRowsInComponent:component];
    return [NSString stringWithFormat:@"%d", row % numberItems];
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    int numberItems = [self numberOfRowsInComponent:component];
    NSInteger actualValue = row % numberItems;
    
    
    
    NSLog([NSString stringWithFormat:@"Row %i, component %i", actualValue, component]);
    
    if([self pickDays]) {
        switch (component) {
                //include days
            case 0:
                NSLog([NSString stringWithFormat:@"Days %i", actualValue]);
                [self setDays:actualValue];
                break;
            case 1:
                NSLog([NSString stringWithFormat:@"Hours %i", actualValue]);
                [self setHours:actualValue];
                break;
            case 2:
                NSLog([NSString stringWithFormat:@"Minutes %i", actualValue]);
                [self setMins:actualValue];
                break;
            case 3:
                NSLog([NSString stringWithFormat:@"Seconds %i", actualValue]);
                [self setSeconds:actualValue];
                break;
           
        }
    } else {
        switch (component) {
        //ommit days
            case 0:
                NSLog([NSString stringWithFormat:@"Hours %i", actualValue]);
                [self setHours:actualValue];
                break;
            case 1:
                NSLog([NSString stringWithFormat:@"Minutes %i", actualValue]);
                [self setMins:actualValue];
                break;
            case 2:
                NSLog([NSString stringWithFormat:@"Seconds %i", actualValue]);
                [self setSeconds:actualValue];
                break;
        }
    }
    
    BOOL isZero = NO;
    
    if(![self canSetZero]) {
        //prevent from seting zero value
        if([self sumSeconds] == 0) {
            [self setSeconds:1];
            isZero = YES;
        }
    } 
    
    if(isZero) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MSG_ZERO_PICKED  object:nil userInfo:nil];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MSG_TIME_PICKED  object:nil userInfo:nil];
    
    
}


-(void) hidePickerAnim {
    [self hidePicker:YES];
}

- (void) showPicker:(BOOL) animated {
    
    
    
    //check if view is already animating and if isn't already shown
    if([self isAnimating] || ![self isHidden]) {
        return;
    }
    
    [self setHidden:NO];
    
    if(animated) {
        
        [self setHidePos];
        
        //setup animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIM_TIME_SEC];
        
        [self setIsAnimating:YES];
    }
    
    [self setShowPos];
    
    
    if(animated) {
        [UIView commitAnimations];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, ANIM_TIME_SEC * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self setIsAnimating:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_PICKER_SHOWED  object:nil userInfo:nil];
        });
            
    }
    
}

- (void)didRotateFromInterfaceOrientation {
    
    BOOL orientationChanged = NO;
    
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsLandscape(fromInterfaceOrientation)) {
        NSLog(@"Landscape");
        
        if([self isPortrait]) {
            orientationChanged = YES;
        }
        
        [self setIsPortrait:NO];
        
    } else {
        NSLog(@"Portrait");
        
        if(![self isPortrait]) {
            orientationChanged = YES;
        }
        
        [self setIsPortrait:YES];
    }
    
    if(orientationChanged) {
        [self hidePicker:NO];
    }
    
    
}

-(void) setShowPos {
    
    [[UIApplication sharedApplication] statusBarOrientation];
    
    //at first get screen size
    int screenWidth = self.superview.frame.size.width;
    int screenHeight = self.superview.frame.size.height;
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsLandscape(fromInterfaceOrientation)) {
        NSLog(@"Landscape");
        
        //switch dimensions
        int tmpScreenWidth = screenHeight;
        screenHeight = screenWidth;
        screenWidth = tmpScreenWidth;
    } else {
        NSLog(@"Portrait");
        
    }
    
    //hide timer below the screen
    float x = (screenWidth - width)/2;
    
    [self setFrame:CGRectMake(x, (screenHeight - height), width, height)];
    
}

-(void) setHidePos {
    
    [[UIApplication sharedApplication] statusBarOrientation];
    
    //at first get screen size
    int screenWidth = self.superview.frame.size.width;
    int screenHeight = self.superview.frame.size.height;
    
    int width = self.frame.size.width;
    int height = self.frame.size.height;
    
    
    UIInterfaceOrientation fromInterfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIDeviceOrientationIsLandscape(fromInterfaceOrientation)) {
        NSLog(@"Landscape");
        
        //switch dimensions
        int tmpScreenWidth = screenHeight;
        screenHeight = screenWidth;
        screenWidth = tmpScreenWidth;
    } else {
        NSLog(@"Portrait");
        
    }
    
    //hide timer below the screen
    float x = (screenWidth - width)/2;
    
    [self setFrame:CGRectMake(x, screenHeight, width, height)];
    
}

- (void) hidePicker:(BOOL) animated {
    
    //check if view is already animating and if isn't already shown
    if(animated) {
        if([self isAnimating] || [self isHidden]) {
            return;
        }
    }
    
    if(animated) {
        
        [self setShowPos];
        
        //setup animation
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:ANIM_TIME_SEC];
        
        [self setIsAnimating:YES];
        [self setHidden:NO];
    }
    
    [self setHidePos];
    
    
    if(animated) {
        [UIView commitAnimations];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, ANIM_TIME_SEC * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self setIsAnimating:NO];
            [self setHidden:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:MSG_PICKER_HIDED  object:nil userInfo:nil];
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
