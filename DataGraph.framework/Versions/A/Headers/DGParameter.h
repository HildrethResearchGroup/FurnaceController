//
//  DGParameter.h
//  DataGraph
//
//  Created by David Adalsteinsson on 5/18/07.
//  Copyright 2007-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGVariable.h"

@class DPParameterController; // Not accessible

@interface DGParameter : DGVariable
{
}

// Connecting GUI elements to parameters.  This will allow the user to set the values interactively.
- (BOOL)connectSlider:(NSSlider *)slider;
- (BOOL)connectStringField:(NSTextField *)field;
- (BOOL)connectValueField:(NSTextField *)field;
- (BOOL)connectRangeField:(NSTextField *)field;
// - (BOOL)connectDatePicker:(NSDatePicker *)picker;

// Setting parameter values, allows the code to set values programmatically.
- (void)setNumberValue:(NSNumber *)number; // For Slider, Value, Date
- (void)setDoubleValue:(double)v;
- (void)setValue:(NSString *)str; // For Slider, Value
- (void)setRange:(NSString *)str; // For Slider
- (void)setString:(NSString *)str;
// - (BOOL)setDate:(NSDate *)date;

// Getting parameter values
- (NSNumber *)getNumberForParameter:(NSString *)name;
- (NSString *)getRangeForParameter:(NSString *)name; // For Slider
                                                     //- (NSDate *)getDateForParameter:(NSString *)name;
                                                     //- (NSString *)getStringForParameter:(NSString *)name;
                                                     //- (NSString *)getValueForParameter:(NSString *)name;

// Delegate functions

@end

