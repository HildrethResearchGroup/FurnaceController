//
//  DGPlotsCommand.h
//
//  Created by David Adalsteinsson on 7/8/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGStructures.h"
#import "DGPlotCommandConstants.h"
#import "DGPlotsCommandConstants.h"

@interface DGPlotsCommand : DGCommand {
    
}

- (void)setLineColor:(NSColor *)col;
- (void)setLineWidth:(CGFloat)width;
- (void)setXOffset:(double)off;
- (void)setYOffset:(double)off;

- (void)setLocationColumn:(DGDataColumn *)col valueColumns:(NSArray *)columnList; // Overwrites the current list of columns.


// This will very likely change, since I have to add themes.
- (void)setLineStyle:(DGPlotsCommandLineType)type;
- (void)setPointStyle:(DGPlotsCommandPointType)type;

// If the point is always the same
- (void)setMarkerFillType:(DGColorNumber)num;
- (void)setMarkerFill:(NSColor *)col;
- (void)setMarkerSize:(double)sz;
- (void)setMarkerType:(DGSimplePointStyle)point;

- (DGMaskSettings *)mask;

// How the points are connected
- (void)setConnections:(DGPlotCommandConnections)num;
- (void)setSmoothType:(DGPlotCommandSmoothType)num; // Only used if connections==DGPlotCommandSmooth
- (void)setStepType:(DGPlotCommandStepType)num; // Only used if connections==DGPlotCommandStep

@end
