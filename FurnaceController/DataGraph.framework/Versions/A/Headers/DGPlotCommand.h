//
//  DGPlotCommand.h
//  Real Time tracker
//
//  Created by David Adalsteinsson on 5/2/09.
//  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGStructures.h"
#import "DGPlotCommandConstants.h"

@interface DGPlotCommand : DGCommand {

}

- (void)selectXColumn:(DGDataColumn *)xCol yColumn:(DGDataColumn *)yCol;
- (DGDataColumn *)xColumn;
- (void)setXColumn:(DGDataColumn *)xCol;
- (DGDataColumn *)yColumn;
- (void)setYColumn:(DGDataColumn *)yCol;

- (DGLineStyleSettings *)line;

- (void)setLineColorType:(DGColorNumber)num;
- (void)setLineColor:(NSColor *)col;
- (void)setLineWidth:(CGFloat)width;
- (void)setLinePattern:(DGSimpleLineStyle)line;

- (void)setMarkerFillType:(DGColorNumber)num;
- (void)setMarkerFill:(NSColor *)col;
- (void)setMarkerSize:(double)sz;
- (void)setMarkerType:(DGSimplePointStyle)point;

// How the points are connected
- (void)setConnections:(DGPlotCommandConnections)num;
- (void)setSmoothType:(DGPlotCommandSmoothType)num; // Only used if connections==DGPlotCommandSmooth
- (void)setStepType:(DGPlotCommandStepType)num; // Only used if connections==DGPlotCommandStep

// Fill
- (DGFillSettings *)fill; // Change the return object
- (void)setFillStyle:(DGPlotCommandFillStyle)num;
- (void)selectXFillColumn:(DGDataColumn *)col;
- (void)selectYFillColumn:(DGDataColumn *)col;

// Legend
- (void)setLegend:(NSString *)str;
- (void)setLegendLocation:(DGPlotCommandLegendLocation)loc;

// Label
- (DGDataColumn *)labelColumn;
- (void)setLabelColumn:(DGDataColumn *)lCol;

// Crop
- (void)setCropXValues:(NSString *)cropWith;

// Delegate function
- (void)clickedInPlot:(DGPlotCommand *)cmd rowIndicies:(NSIndexSet *)indices;
// - (void)clickedInPlot:(DGPlotCommand *)cmd lineSegmentFrom:(int)from to:(int)to; Not yet implemented.

@end

