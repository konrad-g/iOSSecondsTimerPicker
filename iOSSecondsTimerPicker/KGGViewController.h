//
//  KGGViewController.h
//  iOSSecondsTimerPicker
//
//  Created by Admin on 30.08.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGGTimePickerView.h"

@interface KGGViewController : UIViewController


@property KGGTimePickerView* timePicker;
@property (weak, nonatomic) IBOutlet UIButton *btnDate;
@property (weak, nonatomic) IBOutlet UILabel *labelTime;

@end
