//
//  DGLineStyleSettings.h
//  DataGraph
//
//  Created by David Adalsteinsson on 10/5/09.
//  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DGCommandConstants.h"

@class DGCommand;
@class DPLineStyleInputController;

@interface DGLineStyleSettings : NSObject
{
    DGCommand *command;
    DPLineStyleInputController *line;
}

- (void)setColorType:(DGColorNumber)num;
- (void)setColor:(NSColor *)col;
- (void)setWidth:(CGFloat)width;
- (void)setPattern:(DGSimpleLineStyle)line;

- (DGColorNumber)colorType;
- (NSColor *)color;
- (CGFloat)width;
- (DGSimpleLineStyle)pattern;

@end
