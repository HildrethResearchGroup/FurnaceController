//
//  DGBarsCommand.h
//  Bar Graphs
//
//  Created by David Adalsteinsson on 5/25/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGBarsCommandConstants.h"

@interface DGBarsCommand : DGCommand {
    
}

// Actions
- (void)setLabelColumn:(DGDataColumn *)column;
- (void)setColumns:(NSArray *)columnList; // Overwrites the current list of columns.

// Setting values
- (void)setBarType:(DGBarsCommandType)type;
- (DGBarsCommandType)barType;
- (void)setBarFill:(DGBarsCommandFill)type;
- (void)setPositionOffset:(double)offs;
- (void)setPositionOffsetString:(NSString *)str;
- (void)setBetweenBars:(double)offs;
- (void)setBetweenBarsString:(NSString *)str;

// The drawing command draws multiple bars.  The next few methods allow you to add/remove/change bars.
- (int)howManyBars;
- (void)selectColumn:(DGDataColumn *)col forBarNumber:(int)barNumber;
- (void)selectPositiveErrorColumn:(DGDataColumn *)xcol negativeErrorColumn:(DGDataColumn *)ycol forBarNumber:(int)barNumber; // nil means nothing, xcol==ycol means us the same
- (void)selectLabelColumn:(DGDataColumn *)col forBarNumber:(int)barNumber;
- (void)addBar; // Adds an empty bar to the end, change it using the above methods.
- (void)moveBarFrom:(int)oldPosition to:(int)newPosition;
- (void)removeBar:(int)barNumber;

// Delegate methods
- (void)clickedInBars:(DGBarsCommand *)cmd column:(DGDataColumn *)column bar:(int)bNumber row:(int)row;
- (void)barsCommand:(DGBarsCommand *)cmd typeChanged:(DGBarsCommandType)type;

- (DGMaskSettings *)mask;

@end

