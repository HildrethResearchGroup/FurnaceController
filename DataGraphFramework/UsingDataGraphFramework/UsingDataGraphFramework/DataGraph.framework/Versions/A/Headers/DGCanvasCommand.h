//
//  DGCanvasCommand.h
//  DataGraphFrameworkTest
//
//  Created by David Adalsteinsson on 1/25/08.
//  Copyright 2008-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGCanvasCommandConstants.h"

// This class is based on the DGCommand class.  All this class does is to simplify setting
// a few entries for the canvas.  For getters, and to connect UI elements use methods for the base class.

@interface DGCanvasCommand : DGCommand
{
}

- (NSString *)title;
- (void)setTitle:(NSString *)title;

- (NSString *)sizeString;
- (void)setSizeString:(NSString *)str;
- (void)setAutomaticSize;
- (void)setMagnification:(DGCanvasCommandMagnification)type; // Only if size is specified

- (void)setStacking:(DGCanvasCommandStacking)type;
- (void)setShouldExportBackground:(BOOL)state; // When copying or creating an output file.

- (void)setSpaceForX:(DGCanvasCommandSpaceForX)type;
- (void)setSpaceForY:(DGCanvasCommandSpaceForY)type;

- (void)setMarginBelow:(NSString *)str;
- (void)setMarginAbove:(NSString *)str;
- (void)setMarginRight:(NSString *)str;
- (void)setMarginLeft:(NSString *)str;

@end
