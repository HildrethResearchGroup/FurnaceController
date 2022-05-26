//
//  DGCommand.h
//
//  Created by David Adalsteinsson on 5/18/07.
//  Copyright 2007-2008 Visual Data Tools, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "DGStructures.h"

@class DGGraph;
@class DataDrawingCommand;
@class DPGearButton; // Derived from NSButton
@class DPAddTokenButton; // Derived from NSButton
@class DPColumnSelectorMenu; // Derived from NSPopUpButton

@class DGController;
@class DGDataColumn;
@class DGColorScheme;
@class DGAxisSelector;
@class DGActionList;
@class DGFillSettings;
@class DGLineStyleSettings;
@class DGMaskSettings;

#import "DGCommandConstants.h"
    
@interface DGCommand : NSObject
{
    DGController *controller;
    DGGraph *_graph;
    
    DataDrawingCommand *command;
    
    id delegate; // Not retained.
    
    // Thread support
    NSLock *accessLock;
    DGActionList *waitingForSync;
    DGActionList *waitingToBeApplied;
    DGActionList *readyToBeSubmitted;
}

- (id)delegate;
- (void)setDelegate:(id)obj;

- (DGController *)controller;
- (BOOL)isDisconnected; // Drawing command might have been removed.

// The name of this drawing command.
- (NSString *)type; // Plot, Scatter, Bars, Fit, Function, Histogram, Label, Graphic, Legend, Multiple Lines, Lines, Anchored Image

// All entries are referred to by their label. These labels are strings, which should be descriptive.
// To explore the command, you can get a list of labels.
- (NSArray *)entryNames;
// These labels will have a particular type, so only a few of the calls below will work for a specific input type.
- (NSArray *)columnSelectors;

// Copy settings from one command to another.  Does not have to be in the same controller, or the same type.
// If the type is different, only a portion of the settings might be changed (changed by name).
- (void)copySettingsFrom:(DGCommand *)controller;

// Hide/exclude "buttons"
- (BOOL)isExcluded;
- (BOOL)isHidden;
- (void)setExcluded:(BOOL)yOrN;
- (void)setHidden:(BOOL)yOrN;

// In which axis this command is drawn.
- (void)setXAxis:(int)xa yAxis:(int)ya;
- (int)whichXAxis;
- (int)whichYAxis;

- (DGRange)xRange;
- (DGRange)yRange;


// Column selectors  - DPColumnSelectorMenu is derived from NSPopUpMenu
- (BOOL)connectColumnMenu:(DPColumnSelectorMenu *)menu toEntry:(NSString *)name; // Only the first menu entry remains.  Indicates "No Selection"
- (DGDataColumn *)columnSelectedForEntry:(NSString *)name;
- (void)selectColumn:(DGDataColumn *)col forEntry:(NSString *)name;

// Extract named properties
- (NSArray *)propertyNames; // Mostly intended for quering the object during debugging.  Returns valid names for the next method
- (id)valueForProperty:(NSString *)name;

// Some commands have actions that can't be triggered with the above calls.
// These methods used to be available in every command objed, but only worked for a few command types.
// These have been moved into their own derived class, where there is a lot of space to grow.
//- (NSIndexSet *)rowsDisplayedInRect:(NSRect)rect; // Works for the scatter command
//- (BOOL)setGraphicFromFile:(NSString *)fileName; // Works only for the Graphic command
//- (BOOL)setGraphicFromBitmap:(NSBitmapImageRep *)bitmap; // Works only for the Graphic command
 
// Delegate 
- (BOOL)allowInteractiveChange:(DGCommand *)cmd; // If you don't want to allow it.


// ///////////////////////////////////////////////////////////////////
// Low level getters and setters.
// Every property has a key name, and you can set and get them
// using that key.  The recommended method is to use the methods
// in the derived class instead
// ///////////////////////////////////////////////////////////////////

// Connect an input element to a user interface object, such as color wells, text fields, etc.
- (void)connectAxisSelector:(DGAxisSelector *)selector; // Derived from NSView
- (BOOL)connectColorWell:(NSColorWell *)well toEntry:(NSString *)name; // "Color Tile"
- (BOOL)connectMenu:(NSPopUpButton *)menu toEntry:(NSString *)name; // Menu tags need to be set.  Look at the nib file inside DataGraph.
- (BOOL)connectField:(NSTextField *)field toEntry:(NSString *)name; // Works for "Number input", "Point input", "Text field", "Function", "Range", "Number List"
- (BOOL)connectButton:(NSButton *)button toEntry:(NSString *)name; // "Check box"
- (BOOL)connectTokenField:(NSTokenField *)tfield tokenButton:(DPAddTokenButton *)tButton toEntry:(NSString *)name; // "Tokenized input" - DPAddTokenButton : NSButton
- (BOOL)connectImageView:(NSImageView *)iView imageMenu:(DPGearButton *)button toEntry:(NSString *)name; // "Image" - DPGearButton : NSButton
- (BOOL)connectPatternMenu:(NSPopUpButton *)menu foreground:(NSColorWell *)forg background:(NSColorWell *)backg lineWidth:(NSTextField *)width toEntry:(NSString *)name;
// New for 2.0
// The color for the line style changed.  Now using the new color selector.  The next entry will only work for color!=nil if you use the specified color.  If you use the pen color, don't connect it, it will be ignored.
- (BOOL)connectLineStyleMenu:(NSPopUpButton *)menu color:(NSColorWell *)color width:(NSTextField *)width toEntry:(NSString *)name; // If one of the entries is non-nil it only adds/changes.  If all are nil, everything is disconnected.
// Fill style - upon request 
// Mask functionality - upon request

// Set values programmatically for a specific entry.
- (void)setColorType:(DGColorNumber)num forEntry:(NSString *)name; // "Color Tile" or "Line Style"
- (void)setColor:(NSColor *)color forEntry:(NSString *)name; // "Color Tile" or "Line Style".  If this is a color tile, sets the style to "Specified". For a line style it only works if the color is "Specified"
- (void)setNumber:(NSNumber *)num forEntry:(NSString *)name; // "Number Input"
- (BOOL)setString:(NSString *)str forEntry:(NSString *)name; // For a token field, can use the convention
- (BOOL)setString:(NSString *)str forEntry:(NSString *)name recordUndo:(BOOL)rec; // For a token field, can use the convention
// <Parameter>ParameterName</Parameter>
// <Label>LabelName</Label>
// in the string.  This will be split into tokens.  Or use the setTokens: method
// The ParameterName and LabelName are the same names as you see in DataGraph
- (BOOL)setTokens:(NSArray *)tokens forEntry:(NSString *)name; // array of DGToken objects.  Only for token fields.
- (void)selectTag:(int)tag forEntry:(NSString *)name; // Menu tag, or segment tag.  Refer to nib file
- (BOOL)selectLineStyle:(DGSimpleLineStyle)tag forEntry:(NSString *)name;
- (void)selectPointStyle:(DGSimplePointStyle)tag forEntry:(NSString *)name;
- (BOOL)selectButton:(BOOL)onOrOff forEntry:(NSString *)name; // "Check box"
- (BOOL)setPatternType:(DGPatternType)type foreground:(NSColor *)fg background:(NSColor *)bg width:(NSString *)lineW forEntry:(NSString *)name;
- (BOOL)setColorScheme:(DGColorScheme *)scheme forEntry:(NSString *)name;
- (BOOL)setFont:(NSFont *)theFont forEntry:(NSString *)name;

// Get the current value.
- (NSColor *)getColorForEntry:(NSString *)name;
- (NSNumber *)getNumberForEntry:(NSString *)name;
- (NSString *)getStringForEntry:(NSString *)name;
- (NSArray *)getTokensForEntry:(NSString *)name; // Array of DGToken objects
- (int)selectedTagForEntry:(NSString *)name;
- (DGSimpleLineStyle)selectedLineStyleForEntry:(NSString *)name;
- (DGSimplePointStyle)selectedPointStyleForEntry:(NSString *)name;
- (BOOL)getButtonStateForEntry:(NSString *)name;
- (DGColorScheme *)getColorSchemeForEntry:(NSString *)name;
- (NSFont *)getFontForEntry:(NSString *)name;




@end

