//
//  KGGLabeledPickerView.h
//  iOSSecondsTimerPicker
//
//  Created by Admin on 03.09.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGGLabeledPickerView : UIPickerView

{
    NSMutableDictionary *labels;
}

/** Adds the label for the given component. */
-(void)addLabel:(NSString *)labeltext forComponent:(NSUInteger)component forLongestString:(NSString *)longestString;

@end
