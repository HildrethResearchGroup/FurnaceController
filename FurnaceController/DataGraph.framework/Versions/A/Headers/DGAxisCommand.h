//
//  DGAxisCommand.h
//  DataGraphFrameworkTest
//
//  Created by David Adalsteinsson on 9/24/07.
//  Copyright 2007-2008 Visual Data Tools Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGStructures.h"

// This class is based on the DGCommand class.  All this class does is to simplify setting
// a few entries for the main axis and additional X/Y axes.  For getters, and to connect UI elements
// use methods for the base class.


// Define menu tags.
#include "DGAxisCommandConstants.h"

@interface DGAxisCommand : DGCommand
{
}

- (void)setAxisTitle:(NSString *)str;
- (NSString *)axisTitle;
- (DGAxisTypeOptions)axisType;
- (void)setAxisType:(DGAxisTypeOptions)option;
- (void)setDrawLabels:(BOOL)yOrN;
- (void)setInclude:(NSString *)str;
- (void)setPadding:(DGAxisPaddingOptions)option;
- (void)setCrop:(NSString *)str;
- (NSString *)cropString;
- (void)setTickMarks:(DGAxisTickMarkOptions)option;
// Settings for the option types
- (void)setStride:(NSString *)str; // option==DGTickMarksUniform
- (void)setSpecifyValues:(NSString *)str; // option==DGTickMarksSpecified
- (void)setLocations:(DGDataColumn *)locations labels:(DGDataColumn *)labels; // option==DGTickMarksLabels
- (void)setCategories:(DGDataColumn *)column; // option==DGTickMarksCategories

- (int)numberOfThisAxis;
- (DGRange)commandRange; // The range of the commands currently in this axis.
- (DGRange)cropRange;
- (void)setCropRange:(DGRange)cropRange;


// Delegate methods
- (void)croppingRangeChanged:(DGAxisCommand *)cmd; // The cropping range changed
- (void)axisTypeChanged:(DGAxisCommand *)cmd;

@end
