//
//  DGPointsCommand.h
//  DataGraph
//
//  Created by David Adalsteinsson on 3/29/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGStructures.h"
#import "DGPointsCommandConstants.h"

@interface DGPointsCommand : DGCommand {

}

- (NSIndexSet *)rowsDisplayedInRect:(NSRect)rect; // Screen coordinates
- (NSIndexSet *)rowsInXRange:(DGRange)xR yRange:(DGRange)yR; // Underlying coordinates

// X & Y data
- (DGDataColumn *)xColumn;
- (void)setXColumn:(DGDataColumn *)xCol;
- (DGDataColumn *)yColumn;
- (void)setYColumn:(DGDataColumn *)yCol;
- (void)selectXColumn:(DGDataColumn *)xCol yColumn:(DGDataColumn *)yCol;

// Point size
- (DGDataColumn *)pointSizeColumn;
- (void)setPointSizeColumn:(DGDataColumn *)col;
- (void)setScaleMethod:(DGPointsCommandScale)type; // Diameter of area
- (void)setScaleString:(NSString *)str;

// Point color
- (DGDataColumn *)pointColorColumn;
- (void)setPointColorColumn:(DGDataColumn *)col;
- (void)setPointColorScheme:(DGColorScheme *)scheme;
- (void)setPointColorMethod:(DGPointsCommandColoring)type; // Line or fill

// Label
- (DGDataColumn *)labelColumn;
- (void)setLabelColumn:(DGDataColumn *)col;

// Legend
- (void)setLegend:(NSString *)str;

// Line style for the Point
- (void)setLineColor:(NSColor *)col;
- (void)setLineWidth:(double)width;

// Marker size
- (void)setMarkerType:(DGSimplePointStyle)point;
- (void)setMarkerFill:(NSColor *)col;
- (void)setMarkerSize:(double)sz;

// Composite
- (DGMaskSettings *)mask;

// Delegate methods
- (void)clickedInPoints:(DGPointsCommand *)cmd coordinate:(NSPoint)pt pointClosest:(NSPoint)closest row:(int)row;

@end
