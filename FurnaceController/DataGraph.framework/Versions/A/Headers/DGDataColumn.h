//
//  DGDataColumn.h
//  DataGraph
//
//  Created by David Adalsteinsson on 5/18/07.
//  Copyright 2007-2008 Visual Data Tools, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DataGraphColumn; // Not accessible
@class DGController;
@class DPAddTokenButton;
@class DGActionList;

@interface DGDataColumn : NSObject
{
    DGController *controller;
    DataGraphColumn *column;
    
    // Thread support
    NSLock *accessLock;
    DGActionList *waitingForSync;
    DGActionList *waitingToBeApplied;
    DGActionList *readyToBeSubmitted;
}

- (DGController *)controller;

- (NSString *)type;
- (NSString *)name;
- (BOOL)isStringColumn;
- (BOOL)isNumberColumn;
- (void)setColumnName:(NSString *)nm;


// Sets this state as the undo state.  You can then change the array at will, and undo will be able to restore it.
- (void)recordUndoWithCurrentState;

// Set/Change data.
- (void)setString:(NSString *)str atIndex:(int)i;

- (void)setDataFromArray:(NSArray *)strings; // Does not record undo
- (void)setDataFromArray:(NSArray *)strings recordUndo:(BOOL)recUndo; // List of strings.

- (void)emptyTheColumn;
- (void)emptyTheColumnWithUndo:(BOOL)recUndo;
- (void)removeRowRange:(NSRange)rowRange; // Thread safe. Waits for sync if called outside the main thread.

// Get data
- (NSNumber *)valueAtRow:(int)row;
- (NSString *)stringForRow:(int)row;
- (NSInteger)numberOfRows;
- (BOOL)copyNumbersIntoPointer:(double *)val length:(int)len; // len<=numberOfRows.  Underlying numbers.
- (BOOL)copyMaskIntoPointer:(char *)val length:(int)len;
- (NSArray *)stringList; // Does not work for a binary column.

// Changing columns.  Obsolete, use methods below (as explained)
- (void)setStringExpression:(NSArray *)tokens; // Use [col setTokens:tokens forEntry:@"Tokens"]
- (NSArray *)stringExpression; // Use [col getTokensForEntry:@"Tokens"];

// All entries are referred to by their label, just like DGCommand objects. These labels are strings, which should be descriptive.
// To explore the command, you can get a list of labels.
- (NSArray *)entryNames;

// Connect an input element to a user interface object, such as text fields, etc.
- (BOOL)connectMenu:(NSPopUpButton *)menu toEntry:(NSString *)name; // Menu tags need to be set.  Look at the nib file inside DataGraph.
- (BOOL)connectField:(NSTextField *)field toEntry:(NSString *)name; // 
- (BOOL)connectButton:(NSButton *)button toEntry:(NSString *)name; // The "Show" check box.
- (BOOL)connectTokenField:(NSTokenField *)tfield tokenButton:(DPAddTokenButton *)tButton toEntry:(NSString *)name; // "Tokenized input" - DPAddTokenButton : NSButton

// Set values programmatically for a specific entry.
- (void)setNumber:(NSNumber *)num forEntry:(NSString *)name; // "Number Input"
- (void)setString:(NSString *)str forEntry:(NSString *)name;
- (void)setTokens:(NSArray *)tokens forEntry:(NSString *)name; // array of DGToken objects.  Only for token fields.
- (void)selectTag:(int)tag forEntry:(NSString *)name; // Menu tag, or segment tag.  Refer to nib file
- (void)selectButton:(BOOL)onOrOff forEntry:(NSString *)name; // "Check box"

// Get the current value.
- (NSNumber *)getNumberForEntry:(NSString *)name;
- (NSString *)getStringForEntry:(NSString *)name;
- (NSArray *)getTokensForEntry:(NSString *)name; // Array of DGToken objects
- (int)selectedTagForEntry:(NSString *)name;
- (BOOL)getButtonStateForEntry:(NSString *)name;

@end

// A standardized method to share columns between different controllers.  Add them to a set, and
// then change all of the columns at once by changing the set.  The set requires all of the columns to
// have the same type.
@interface DGDataColumnSet : NSObject
{
    NSMutableArray *columns;
}

+ (DGDataColumnSet *)createColumnSet;

- (void)addColumn:(DGDataColumn *)col; // Does not change the column.
- (NSArray *)allColumns;

// Set all column names to be the same
- (void)setColumnName:(NSString *)nm;

// Setters, sent to all of the columns
- (void)setDoubleValue:(double)val atIndex:(int)i; // Only works for binary
- (void)setDoubleValue:(double)val atIndexSet:(NSIndexSet *)indexes;
- (void)setString:(NSString *)str atIndex:(int)i;

// Works for all columns, but the entries will need to be parsed.
- (void)setDataFromArray:(NSArray *)strings recordUndo:(BOOL)recUndo; // List of strings.

// The next methods only work for a binary column
- (void)setDataFromPointer:(const double *)val length:(ssize_t)len recordUndo:(BOOL)recUndo;  // Works only for a binary column.
- (void)setDataFromPointer:(const double *)val length:(ssize_t)len; // recUndo = NO


@end

// ************************************************************************************************************************

@interface DGStandardDataColumn : DGDataColumn {
    
}

@end

// ************************************************************************************************************************

@interface DGStringDataColumn : DGDataColumn {
    
}

- (NSArray *)strings;
- (void)setStrings:(NSArray *)setStrings;

@end

// ************************************************************************************************************************

@interface DGDateDataColumn : DGDataColumn {
    
}

// Modify the format
- (void)setFullDate:(NSString *)format timeFormat:(NSString *)tFormat; // Text label from the menu

@end

// ************************************************************************************************************************

@interface DGExpressionDataColumn : DGDataColumn {
    
}

- (NSString *)expressionString;
- (void)setExpressionString:(NSString *)str;

- (void)setNumberOfRowsString:(NSString *)str;

- (NSString *)errorString; // nil if the expression is OK.  Same error as is displayed in DataGraph.

@end

// ************************************************************************************************************************

typedef enum _DGBinaryColumnDateFormat {
    DGBinaryColumnSeconds = 1,
    DGBinaryColumnYMD = 2,
    DGBinaryColumnYM = 3,
    DGBinaryColumnMD = 4,
    DGBinaryColumnDM = 5,
    
    DGBinaryColumnYMDhm = 6,
    DGBinaryColumnYMDhms = 7,
    DGBinaryColumnMDhms = 8,
    DGBinaryColumnDMhms = 9,
    DGBinaryColumnICU = 40
} DGBinaryColumnDateFormat;

@interface DGBinaryDataColumn : DGDataColumn {
    
}

// Thread safety:
// Only doubleValueInRow is not thread safe, since that would require all of the changes to be flushed.

- (void)appendValue:(double)val; // No undo.
- (void)appendValuesFromPointer:(double *)val length:(int)len; // No undo.

// Default is that the column is numerical, can set it to be a date column.
- (void)setDateColumn:(BOOL)yOrN;
- (BOOL)isDateColumn;

// Formatter
- (void)setDateFormatOption:(DGBinaryColumnDateFormat)t; // Need to call setDateColumn:YES
- (void)setICUFormat:(NSString *)str; // Will also need to call setDateColumn:YES.  This call will set the date format to DGBinaryColumnICU

- (double)doubleValueInRow:(int)i;
- (void)setDoubleValue:(double)val atIndex:(int)i;
- (void)setDoubleValue:(double)val atIndexSet:(NSIndexSet *)indexes;
- (void)setDataFromPointer:(const double *)val length:(ssize_t)len; // recUndo = NO
- (void)setDataFromPointer:(const double *)val length:(ssize_t)len recordUndo:(BOOL)recUndo;
- (void)setDataFromPointer:(const double *)val maskFromPointer:(const char *)mVal length:(ssize_t)len recordUndo:(BOOL)recUndo;

- (void)copyFromBinaryColumn:(DGBinaryDataColumn *)col;

- (void)removeAllEntries;

@end

@interface DGDataColumnGroup : DGDataColumn {
    
}

@end
