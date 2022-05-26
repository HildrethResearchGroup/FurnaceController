//
//  DGMaskSettings.h
//  DataGraph
//
//  Created by David Adalsteinsson on 10/13/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DGCommandConstants.h"
#import "DGMaskSettingsConstants.h"

@class DGCommand;
@class DPMaskInputController;
@class DGDataColumn;

// This has changed quite a bit, not just a single line

@interface DGMaskSettings : NSObject 
{
    DGCommand *command;
    DPMaskInputController *mask;
}

// Set one thing at a time.
- (void)setMaskColumn:(DGDataColumn *)col;
- (void)setMaskType:(DGMaskSettingsType)type;
- (void)setMaskValueString:(NSString *)str;
- (void)setMaskRangeString:(NSString *)str;

// Get content
- (DGDataColumn *)maskColumn;
- (DGMaskSettingsType)maskType;
- (NSString *)maskValueString;
- (NSString *)maskRangeString;

// Combined
- (void)setMaskColumn:(DGDataColumn *)col exactMatchValueString:(NSString *)str; // Switches the mask type to DGMaskSettingsEqual

@end
