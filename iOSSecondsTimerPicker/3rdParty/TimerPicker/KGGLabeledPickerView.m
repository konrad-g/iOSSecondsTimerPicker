//
//  KGGLabeledPickerView.m
//  iOSSecondsTimerPicker
//
//  Created by Konrad Gadzinowski on 03.09.2013.
//  Copyright (c) 2013 Konrad Gadzinowski. All rights reserved.
//

#import "KGGLabeledPickerView.h"
#import "KGGTimePickerConsts.h"
#import "math.h"
@implementation KGGLabeledPickerView


/** loading programmatically */
- (id)initWithFrame:(CGRect)aRect {
    if (self = [super initWithFrame:aRect]) {
        labels = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    return self;
}

/** loading from nib */
- (id)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        labels = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    
    return self;
}

- (void) addTimeLabels {
    if(self.numberOfComponents == 4 ) {
        //include days
        [self addLabel:@"Days" forComponent:0 forLongestString:@"Daysi"];
        [self addLabel:@"Hrs" forComponent:1 forLongestString:@"Hrs"];
        [self addLabel:@"Min" forComponent:2 forLongestString:@"Min"];
        [self addLabel:@"Sec" forComponent:3 forLongestString:@"Sec"];
    } else {
        [self addLabel:@"Hrs" forComponent:0 forLongestString:@"Hrs"];
        [self addLabel:@"Min" forComponent:1 forLongestString:@"Min"];
        [self addLabel:@"Sec" forComponent:2 forLongestString:@"Sec"];
    }
    
}

-(void) addZeroValueObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preventFromZero) name:MSG_ZERO_PICKED object:nil];
}

- (void) preventFromZero{
    //add appropriet margin if we also pick days
    BOOL pickDays = NO;
    if(self.numberOfComponents == 4) {
        pickDays = YES;
    }
    
    int posSec = 2;
    if(pickDays) {
        posSec = 3;
    }
    
    int posOne = [self selectedRowInComponent:posSec] + 1;
    [self selectRow:posOne inComponent:posSec animated:YES];
}

#pragma mark Labels

// Add labelText to our array but also add what will be the longest label we will use in updateLabel
// If you do not plan to update label then the longestString should be the same as the labelText
// This way we can initially size our label to the longest width and we get the same effect Apple uses

-(void)addLabel:(NSString *)labeltext forComponent:(NSUInteger)component forLongestString:(NSString *)longestString {
    [labels setObject:labeltext forKey:[NSNumber numberWithInt:component]];
    
    NSString *keyName = [NSString stringWithFormat:@"%@_%@", @"longestString", [NSNumber numberWithInt:component]];
    
    if(!longestString) {
        longestString = labeltext;
    }
    
    [labels setObject:longestString forKey:keyName];
}

//
- (void) updateLabel:(NSString *)labeltext forComponent:(NSUInteger)component {
    
    UILabel *theLabel = (UILabel*)[self viewWithTag:component + 1];
    
    // Update label if it doesnâ€™t match current label
    if (![theLabel.text isEqualToString:labeltext]) {
        
        NSString *keyName = [NSString stringWithFormat:@"%@_%@", @"longestString", [NSNumber numberWithInt:component]];
        NSString *longestString = [labels objectForKey:keyName];
        
        // Update label array with our new string value
        [self addLabel:labeltext forComponent:component forLongestString:longestString];
        
        // change label during fade out/in
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.75];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        theLabel.alpha = 0.00;
        theLabel.text = labeltext;
        theLabel.alpha = 1.00;
        [UIView commitAnimations];
    }
    
}

/**
 Adds the labels to the view, below the selection indicator glass-thingy.
 The labels are aligned to the right side of the wheel.
 The delegate is responsible for providing enough width for both the value and the label.
 */
- (void)didMoveToWindow {
    
    //add labels if none added yet
    if([labels count] == 0) {
        [self addTimeLabels];
        [self addZeroValueObserver];
    }

    // exit if view is removed from the window or there are no labels.
    if (!self.window || [labels count] == 0)
        return;
    
    UIFont *labelfont = [UIFont boldSystemFontOfSize:16];
    
    // find the width of all the wheels combined
    CGFloat widthofwheels = 0;
    for (int i=0; i<self.numberOfComponents; i++) {
        widthofwheels += [self rowSizeForComponent:i].width;
    }
    
    // find the left side of the first wheel.
    // seems like a misnomer, but that will soon be corrected.
    CGFloat rightsideofwheel = (self.frame.size.width - widthofwheels) / 2;
    
    // cycle through all wheels
    for (int component=0; component<self.numberOfComponents; component++) {
        
        //set initial position in the middle of a range
        int initRow = floor([self numberOfRowsInComponent:component]/2) + ([self numberOfRowsInComponent:component]%2);
        [self selectRow:initRow inComponent:component animated:NO];
        
        // find the right side of the wheel
        rightsideofwheel += [self rowSizeForComponent:component].width;
        
        // get the text for the label.
        // move on to the next if there is no label for this wheel.
        NSString *text = [labels objectForKey:[NSNumber numberWithInt:component]];
        if (text) {
            
            // set up the frame for the label using our longestString length
            NSString *keyName = [NSString stringWithFormat:@"%@_%@", [NSString stringWithString:@"longestString"], [NSNumber numberWithInt:component]];
            NSString *longestString = [labels objectForKey:keyName];
            CGRect frame;
            frame.size = [longestString sizeWithFont:labelfont];
            
            //add appropriet margin if we also pick days
            BOOL pickDays = NO;
            if(self.numberOfComponents == 4) {
                pickDays = YES;
            }
            
            int margin = 0;
            if(pickDays) {
                margin = 15;
            }
            
            // center it vertically
            frame.origin.y = (self.frame.size.height / 2) - (frame.size.height / 2) - 0.5 + margin;
            
            // align it to the right side of the wheel, with a margin.
            // use a smaller margin for the rightmost wheel.
            frame.origin.x = rightsideofwheel - frame.size.width -
            (component == self.numberOfComponents - 1 ? 5 : 7) + (component * 4);
            
            // set up the label. If label already exists, just get a reference to it
            BOOL addlabelView = NO;
            UILabel *label = (UILabel*)[self viewWithTag:component + 1];
            if(!label) {
                label = [[UILabel alloc] initWithFrame:frame];
                addlabelView = YES;
            }
            
            label.text = text;
            label.font = labelfont;
            label.backgroundColor = [UIColor clearColor];
            label.shadowColor = [UIColor whiteColor];
            label.shadowOffset = CGSizeMake(0,1);
            
            // Tag cannot be 0 so just increment component number to esnure we get a positive
            // NB update/remove Label methods are aware of this incrementation!
            label.tag = component + 1;
            
            if(addlabelView) {
                /*
                 and now for the tricky bit: adding the label to the view.
                 kind of a hack to be honest, might stop working if Apple decides to
                 change the inner workings of the UIPickerView.
                 */
                if (self.showsSelectionIndicator) {
                    // if this is the last wheel, add label as the third view from the top
                    if (component==self.numberOfComponents-1) {
                        [self insertSubview:label atIndex:[self.subviews count]-3];
                    // otherwise add label as the 5th, 10th, 15th etc view from the top
                    }else{
                        [self insertSubview:label aboveSubview:[self.subviews objectAtIndex:5*(component+1)+(1*component)]];
                    }
                } else {
                    // there is no selection indicator, so just add it to the top
                    [self addSubview:label];
                }
                
            }
            
            if ([self.delegate respondsToSelector:@selector(pickerView:didSelectRow:inComponent:)])
                [self.delegate pickerView:self didSelectRow:[self selectedRowInComponent:component] inComponent:component];
            
            
            
        }
        
    }
    
}

@end
