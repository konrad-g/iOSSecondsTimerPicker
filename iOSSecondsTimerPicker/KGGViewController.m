//
//  KGGViewController.m
//  iOSSecondsTimerPicker
//
//  Created by Admin on 30.08.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import "KGGViewController.h"
#import "KGGTimePickerView.h"

@interface KGGViewController ()

@end

@implementation KGGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self initTimePicker];
    [self initUi];
    
}

-(void) initTimePicker {
    
    
    KGGTimePickerView *timePicker = [KGGTimePickerView makeView];
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
    [super viewDidUnload];
}

- (void) initUi {
    [self.btnDate addTarget:self action:@selector(toggleDatePicker) forControlEvents:UIControlEventTouchUpInside];
}

- (void) toggleDatePicker {
    [self.timePicker togglePicker];
}

@end
