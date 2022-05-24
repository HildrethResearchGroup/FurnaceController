//
//  DGFillSettings.h
//  DataGraph
//
//  Created by David Adalsteinsson on 9/3/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DGCommandConstants.h"

@class DGCommand;
@class DPFillStyleInputController;

@interface DGFillSettings : NSObject
{
    DGCommand *command;
    DPFillStyleInputController *fill;
}

// Set the color settings
- (void)setSolidColor:(NSColor *)col; // Color is specified
- (void)setSolidColorType:(DGColorNumber)num; // One of the style colors

- (void)setPatternBackground:(NSColor *)bcol lineColor:(NSColor *)lcol lineWidth:(double)lw patternType:(DGPatternType)type;

- (void)setGradientFirstColor:(NSColor *)fcol secondColor:(NSColor *)scol;
- (void)setGradientFirstColor:(NSColor *)fcol secondColor:(NSColor *)scol colorPosition:(double)f thirdColor:(NSColor *)tcol;

- (void)setTextureBackground:(NSColor *)bcol foreground:(NSColor *)fcol weight:(double)w grain:(double)g;

@end
