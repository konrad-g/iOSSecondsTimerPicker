//
//  KGGViewController.m
//  iOSSecondsTimerPicker
//
//  Created by Konrad Gadzinowski on 30.08.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import "KGGViewController.h"
#import "KGGTimePickerView.h"
#import "KGGTimePickerConsts.h"

@interface KGGViewController ()

@end

@implementation KGGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initTimePicker];
    [self initUi];
    [self updateTime];
}

-(void) initTimePicker {
    
    //SET ALL PICKER PROPERTIES IN CONSTRUCTOR BELOW
    KGGTimePickerView *timePicker = [KGGTimePickerView makeViewAllowZero:NO pickDays:YES maxDays:1000 initSumSeconds:30];
    
    [self.view addSubview:timePicker];
    [self setTimePicker:timePicker];
    //[timePicker hidePicker:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setBtnDate:nil];
    [self setLabelTime:nil];
    [super viewDidUnload];
}

- (void) initUi {
    [self.btnDate addTarget:self action:@selector(toggleDatePicker) forControlEvents:UIControlEventTouchUpInside];

    //dismiss picker on focus lost
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideInputs)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:gestureRecognizer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTime) name:MSG_TIME_PICKED object:nil];
}

- (void) updateTime {
    self.labelTime.text = [NSString stringWithFormat:@"%idays + %ih + %imin. + %isec. = %isec.", [self.timePicker days], [self.timePicker hours], [self.timePicker mins], [self.timePicker seconds], [self.timePicker sumSeconds] ];
}

- (void) hideInputs {
    
    //hide time picker after some delay
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MSG_HIDE_PICKER  object:nil userInfo:nil];
    });
    
}

- (void) toggleDatePicker {
    [self.timePicker togglePicker];
}

@end
