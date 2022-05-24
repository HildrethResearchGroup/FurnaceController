//
//  DGRangeCommand.h
//  Stocks
//
//  Created by David Adalsteinsson on 3/8/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGStructures.h"
#import "DGRangeCommandConstants.h"

@interface DGRangeCommand : DGCommand {
    
}

// Switching the interval types
- (void)setXIntervalType:(DGRangeCommandIntervalType)type;
// Note, setting any of the entries below does not change the type, so you need to set it.
- (void)setXEverythingOverlapAxisNumbers:(BOOL)state; // DGRangeCommandEverything
- (void)setXIntervalString:(NSString *)str; // DGRangeCommandInterval
- (NSString *)xIntervalString;
- (DGRange)xInterval;
- (void)setXInterval:(DGRange)interval;
- (void)setXAlternatesString:(NSString *)str; // DGRangeCommandAlternates
- (void)setXDatesType:(DGRangeCommandDatesType)type; // DGRangeCommandDates
- (void)setXDatesOddEven:(DGRangeCommandDatesOddEven)type;
- (void)setXColumnsStart:(DGDataColumn *)col; //DGRangeCommandColumns
- (void)setXColumnsEnd:(DGDataColumn *)col;

- (void)setYIntervalType:(DGRangeCommandIntervalType)type;
- (void)setYEverythingOverlapAxisNumbers:(BOOL)state; // DGRangeCommandEverything
- (DGRange)yInterval;
- (void)setYInterval:(DGRange)interval;
- (void)setYIntervalString:(NSString *)str; // DGRangeCommandInteval
- (void)setYAlternatesString:(NSString *)str; // DGRangeCommandAlternates
- (void)setYDatesType:(DGRangeCommandDatesType)type; // DGRangeCommandDates
- (void)setYDatesOddEven:(DGRangeCommandDatesOddEven)type;
- (void)setYColumnsStart:(DGDataColumn *)col; //DGRangeCommandColumns
- (void)setYColumnsEnd:(DGDataColumn *)col;

// Adjust the fill color based on a column
- (void)setFillColorColumn:(DGDataColumn *)col;
- (void)setFillColorScheme:(DGColorScheme *)scheme;

// Higher level change object.
- (DGFillSettings *)fill;
- (DGLineStyleSettings *)line;

// Delegate methods
- (void)xIntervalChanged:(DGRangeCommand *)cmd;
- (void)yIntervalChanged:(DGRangeCommand *)cmd;

// Rendering option
- (void)setRoundToNearestPixelBdry:(BOOL)r;

@end
