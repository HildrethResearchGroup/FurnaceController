//
//  DGColorScheme.h
//  DataGraphFrameworkTest
//
//  Created by David Adalsteinsson on 8/9/07.
//  Copyright 2007-2008 Visual Data Tools Inc. All rights reserved.
//

// Reflects the color scheme variable in the variable drawer in DataGraph.
// The color ramp contains one or more lines of color matches.
// Each color match is either based on value, range or the string representation.

#import "DGVariable.h"

@class DPColorScheme;
@class DPAddTokenButton;

typedef enum _DGColorSchemeMatchType {
    DGColorSchemeMatchValue		= 1,       // v = specified
    DGColorSchemeMatchRangeOO		= 2,   // a <v <b
    DGColorSchemeMatchRangeCO		= 3,   // a<=v <b
    DGColorSchemeMatchRangeOC		= 4,   // a <v<=b
    DGColorSchemeMatchRangeCC		= 5,   // a<=v<=b
    DGColorSchemeMatchString		= 6,   // The string representation of matches a wild-char type string.
} DGColorSchemeMatchType;

@interface DGColorScheme : DGVariable
{
}

// Managing lines, creating, removing, reordering.
- (int)numberOfLines;
- (void)appendLineWithType:(DGColorSchemeMatchType)type value:(NSString *)content color:(NSColor *)c title:(NSString *)t;
- (void)moveLineFrom:(int)from to:(int)to;
- (void)removeLine:(int)ln;

// Connect GUI elements
- (void)connectMatchType:(NSPopUpButton *)menu forEntry:(int)entryNumber;
- (void)connectValueField:(NSTextField *)field forEntry:(int)entryNumber;
- (void)connectRangeField:(NSTextField *)field forEntry:(int)entryNumber;
- (void)connectMatchField:(NSTextField *)field forEntry:(int)entryNumber;
- (void)connectColorWell:(NSColorWell *)color forEntry:(int)entryNumber;
- (void)connectTitleField:(NSTokenField *)field tokenButton:(DPAddTokenButton *)tButton forEntry:(int)entryNumber;

// Set values
- (void)setMatchType:(DGColorSchemeMatchType)type forEntry:(int)entryNumber;
- (void)setValueString:(NSString *)str forEntry:(int)entryNumber;
- (void)setRangeString:(NSString *)str forEntry:(int)entryNumber;
- (void)setMatchString:(NSString *)str forEntry:(int)entryNumber;
- (void)setColor:(NSColor *)c forEntry:(int)entryNumber;
- (void)setTitleString:(NSString *)str forEntry:(int)entryNumber;

// Get values
- (DGColorSchemeMatchType)matchTypeForEntry:(int)entryNumber;
- (NSString *)valueStringForEntry:(int)entryNumber;
- (NSString *)rangeStringForEntry:(int)entryNumber;
- (NSString *)matchStringForEntry:(int)entryNumber;
- (NSColor *)colorForEntry:(int)entryNumber;
- (NSString *)titleStringForEntry:(int)entryNumber;

@end
