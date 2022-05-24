//
//  DGMagnifyCommand.h
//  DataGraph
//
//  Created by David Adalsteinsson on 10/12/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"

#import "DGMagnifyCommandConstants.h"

@interface DGMagnifyCommand : DGCommand {

}

- (void)setAnchorType:(DGMagnifyCommandAnchor)type;
- (void)setAnchorString:(NSString *)str;

- (void)setXRangeString:(NSString *)str;
- (void)setXRange:(DGRange)r;
- (void)setYRangeString:(NSString *)str;
- (void)setYRange:(DGRange)r;
- (void)setWidth:(double)v;
- (void)setWidthString:(NSString *)str;
- (void)setHeight:(double)v;
- (void)setHeightString:(NSString *)str;
- (void)setConnectState:(BOOL)v;
- (DGFillSettings *)backgroundFill;
- (void)setDrawAxisLabels:(BOOL)v;

- (void)setLineColorType:(DGColorNumber)num;
- (void)setLineColor:(NSColor *)col;
- (void)setLineWidth:(CGFloat)width;

@end
