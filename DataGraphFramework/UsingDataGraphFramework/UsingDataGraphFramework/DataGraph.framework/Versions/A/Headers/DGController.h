//  Created by David Adalsteinsson on 4/18/07.
//  Copyright 2007-2013 Visual Data Tools Inc. All rights reserved.
//

// Three modes of using this
// If you have a DataGraph license it will work fully
// If you don't have a DataGraph license, the string "Register DataGraph" will be written over all graphics
//    and you can not save/export files (just like the unlicensed version of DataGraph)
// If you have a "free" license key, export is disabled, but the text is not written. Instead a small DataGraph icon button is displayed.
//    You can however distribute this application.
// If you have a framework license key, everything is enabled, no text or icon is added and you can distribute your app.

#import <Cocoa/Cocoa.h>

@class DataGraphDocument;

@class DGColorScheme;
@class DGConstantNumberVariable;
@class DGConstantCurrentTimeVariable;
@class DGParameter;
@class DGStringParameter;
@class DGVariable;
@class DGCommand;
@class DGDataColumn;
@class DGStylesCommand;
@class DGAxisCommand;
@class DGXAxisCommand;
@class DGYAxisCommand;
@class DGCanvasCommand;
@class DGStockCommand;
@class DGRangeCommand;
@class DGTextCommand;
@class DGMagnifyCommand;
@class DGLegendCommand;
@class DGGraphicCommand;
@class DGFitCommand;
@class DGFunctionCommand;
@class DGPointsCommand;
@class DGPlotCommand;
@class DGPlotsCommand;
@class DGBarCommand;
@class DGHistogramCommand;
@class DGBarsCommand;
@class DGActionList;
@class DGStringDataColumn;
@class DGBinaryDataColumn;
@class DGDateDataColumn;
@class DGExpressionDataColumn;
@class DGStandardDataColumn;
@class DGDateDataColumn;
@class DGLabelCommand;
@class DGLinesCommand;
@class DGGraph;
@class DGDataColumnGroup;

// In the debugger, use "po object" to get more information about the controller, data column, parameter and drawing commands.

// These classes are not public, but have a simple base class.  They
// are created like this in the sample nib files, and you can easily define them in the interface builder.
@class DPDrawingView; // Derived from NSView
@class DPDataTableView; // Derived from NSTableView

@interface DGController : NSObject
{
    DataGraphDocument *data;

    IBOutlet DPDrawingView *drawingView;
    IBOutlet DPDataTableView *dataTable;

    NSUndoManager *localUndoManager;

    IBOutlet id delegate;
    
    NSLock *accessLock;
    
    // The axis command is split in half in the framework.
    DGXAxisCommand *xPortionOfAxis;
    DGYAxisCommand *yPortionOfAxis;
    NSMutableDictionary *commandsThatHaveBeenCreated;
    NSMutableDictionary *columnsThatHaveBeenCreated;
    NSMutableDictionary *variablesThatHaveBeenCreated;
    
    NSMutableDictionary *_graphsThatHaveBeenCreated;
    
    BOOL displayLoupe;
    BOOL displayTimingResults;
    BOOL isWaitingForSync;

    // Local queue
    DGActionList *waitingForSync;
    DGActionList *waitingToBeApplied;
    DGActionList *readyToBeSubmitted;
    
    BOOL currentlySettingState;
}

// ///////////////////////////////////////////////////////////////////
//                 Setup
// ///////////////////////////////////////////////////////////////////
// Registration information to use the framework without a DataGraph license.
// If you do not call this with a valid registration, you run in demo mode.
// You can request a free registration key that will allow you to use the framework
// in your free utility with some limitations.
// Send mail to david@visualdatatools.com to get more information.
+ (void)setFrameworkRegistrationString:(NSString *)email code:(NSString *)rCode; // Obsolete, please use the next one
+ (void)setFrameworkRegistrationEMail:(NSString *)email code:(NSString *)rCode;

// Intended for debugging purposes. Acts as if you don't have a local license for DataGraph.
+ (void)actAsIfNotRegistered;

// Delegate functions listed at the end.  Mostly for user interaction.
- (id)delegate;
- (void)setDelegate:(id)delegate;
// Undo/Redo
- (void)clearUndoActions;
- (NSUndoManager *)undoManager; // A delegate function, enables undo/redo.  Note that NSDocument implements this.


// ///////////////////////////////////////////////////////////////////
//                 Thread support
// ///////////////////////////////////////////////////////////////////
- (void)sync; // Flushes all of the requests that have been added.

- (id)addStreamingCallForTarget:(id)target;
// called as:
// [[drawController addStreamingCallForTarget:target] myOwnMethod:argument somethingElse:argument];
// This is very similar to what the undo manager uses.  The method will be called during a sync on the target,
//      [target myOwnMethods:argument somethingElse:argument]
// after the commands, columns and variables have been
// committed.  will be called.  This will be called on the main thread, not the calling thread,
// and happen after the next sync
// Could use this to safely put a string into a text field, for example
// [[drawController addStreamingCallForTarget:textField] setStringValue:theString];

- (id)fullySyncAndCallForTarget:(id)target;
// Used similarly as addStreamingCallForTarget, namely
//      output = [[drawController fullySyncAndCallForTarget:target] foo:argument];
// Calls the foo method on the main thread and returns the result back in the calling thread.
// This will do the following behind the scenes.
// Commit all pending changes (before the last sync call)
// Call the method you specify on the target you specify in main thread 
// Can for example do
// DGDataColumn *column = [[drawController fullySyncAndCallForTarget:drawController] columnWithName:@"x"];
// If the result is a NSObject, it will be retained and autoreleased.  But the return does not have to be an object, but can be an integer, double etc.
// This has some overhead, so if you need to do a number of calls, package them into a single method, and call that.

// ///////////////////////////////////////////////////////////////////
//                 Controller setup, reading/writing
// ///////////////////////////////////////////////////////////////////
// Create a new controller
+ (DGController *)createEmpty; // No data column (only the row number), no drawing command.
+ (DGController *)controllerWithContentsOfFile:(NSString *)path;
+ (DGController *)controllerWithFileInBundle:(NSString *)name; // Searches a few folders inside the bundle.
                                                               // if . = application wrapper
                                                               // ./Contents/DataGraph/
                                                               // ./Contents/Library/DataGraph/
                                                               // ./Contents/Resources/
                                                               // ./Contents/Resources/DataGraph/
+ (NSString *)resolveScriptNameInBundle:(NSString *)name;

// Overwrite the content with settings from another file.  Useful if the interface builder created the controller
- (BOOL)overwriteWithScriptFile:(NSString *)path;
- (BOOL)overwriteWithScriptFileInBundle:(NSString *)path; // Same search as for controllerWithFileInBundle
// What script file (if any) is being used.
- (NSString *)scriptName;
// Writing the current state into a script.
- (void)writeScript:(id)sender; // Brings up a dialog box, and saves the script.
- (BOOL)writeToURL:(NSURL *)absoluteURL error:(NSError **)outError;
- (BOOL)writeToPath:(NSString *)pathN;
// These methods are for I/O based on a single file instead of a wrapper.
- (NSDictionary *)propertyListForCommandsAndVariables; // Can be saved in a property list.  Does not serialize the data table.
- (void)restoreCommandsAndVariablesFromPropertyList:(NSDictionary *)propList;  // Will not modify data table

// Suppresses refresh until you call endingRestore
- (void)startingRestore;
- (void)endingRestore;

// ///////////////////////////////////////////////////////////////////
//                 Data table, manipulating data columns
// ///////////////////////////////////////////////////////////////////
// Data input UI.  DPDataTableView is derived from NSTableView.  Works around some limitations of NSTableView, but you can use NSTableView as well.
- (void)setDataTable:(DPDataTableView *)table;

// Get columns
- (NSArray *)dataColumns; // Data columns as a list of DGDataColumn objects
- (int)numberOfDataColumns;
- (DGDataColumn *)dataColumnAtIndex:(int)index;

- (DGDataColumn *)columnWithName:(NSString *)name; // First column with that name
- (DGBinaryDataColumn *)binaryColumnWithName:(NSString *)name; // First binary column with that name
- (DGStringDataColumn *)stringColumnWithName:(NSString *)nm;
- (DGDateDataColumn *)dateColumnWithName:(NSString *)nm;
- (DGStandardDataColumn *)standardColumnWithName:(NSString *)nm;
- (DGExpressionDataColumn *)expressionColumnWithName:(NSString *)nm;
//- (DGStringDataColumn *)findStringColumnWithName:(NSString *)nm; // obsolete
//- (DGBinaryDataColumn *)findBinaryColumnWithName:(NSString *)nm;

// Create columns.
- (DGDataColumn *)addDataColumnWithName:(NSString *)name type:(NSString *)type;  // Type = Binary, Ascii, String, Expression, Date, String Expression
- (DGDataColumn *)addDataColumnByCopying:(DGDataColumn *)col; // col can belong to a different controller.
- (DGStringDataColumn *)addStringColumnWithName:(NSString *)name;
- (DGBinaryDataColumn *)addBinaryColumnWithName:(NSString *)name;
- (DGDateDataColumn *)addDateColumnWithName:(NSString *)name;
- (DGStandardDataColumn *)addStandardColumnWithName:(NSString *)name;
- (DGExpressionDataColumn *)addExpressionColumnWithName:(NSString *)nm expression:(NSString *)expr;

// - (DGDataColumnGroup *)groupColumnsStart:(DGDataColumn *)firstColumn endWith:(DGDataColumn *)lastColumn;

- (void)copyColumns:(NSArray *)columns;

// Modify table
- (void)moveDataColumn:(DGDataColumn *)col toIndex:(int)index;
- (void)removeDataColumn:(DGDataColumn *)col;
- (void)removeDataColumnsAtIndexes:(NSIndexSet *)indexes;

- (void)recomputeExpressionsNow; // Rather than wait for the runloop.

// ///////////////////////////////////////////////////////////////////
//                 Graphs
// ///////////////////////////////////////////////////////////////////
- (DGGraph *)currentGraph; // The graph that DataGraph views as the current focus

// ///////////////////////////////////////////////////////////////////
//                 Variables, i.e. numbers, strings, color schemes
// ///////////////////////////////////////////////////////////////////
- (int)howManyVariables;
- (DGVariable *)variableNumber:(int)index; // Either a parameter or color scheme.  Use the type method to check which it is.
- (DGVariable *)variableByName:(NSString *)name;
- (DGVariable *)addVariableByCopying:(DGVariable *)var;
- (void)removeVariable:(DGVariable *)var; // var is now empty.  Remove parameters and color schemes.
- (void)moveVariable:(DGVariable *)var toIndex:(int)index; // Reorder parameters and color schemes.
// Parameters are accessed through their names.  Invalid parameters can not be used.
- (NSArray *)parameterNames; // Only the valid parameters, others you need to get as variables by number.
- (DGParameter *)addParameterWithType:(NSString *)type name:(NSString *)name; // Creates a new one, type is Slider, Value, Date, String
- (DGParameter *)addParameterByCopying:(DGParameter *)var;
- (DGParameter *)parameterWithName:(NSString *)name;
- (DGParameter *)animationParameter;
- (DGStringParameter *)stringParameterWithName:(NSString *)name;
// Color schemes. Note, names can be repeated, so color schemes are referred to by number.
- (int)numberOfColorSchemes;
- (DGColorScheme *)colorSchemeNumber:(int)number;
- (DGColorScheme *)addColorSchemeWithName:(NSString *)name;
- (DGColorScheme *)addColorSchemeByCopying:(DGColorScheme *)cs;


// Adding a number variable
- (DGConstantNumberVariable *)addConstantNumberVariable:(NSString *)name withContent:(NSString *)str;
- (DGConstantCurrentTimeVariable *)addConstantCurrentTimeVariable:(NSString *)name;

// ///////////////////////////////////////////////////////////////////
//                 Settings: style, canvas, axes
// ///////////////////////////////////////////////////////////////////

- (DGStylesCommand *)styleSettings; // Style sheet
- (DGCanvasCommand *)canvasSettings; // Canvas

// Axes
- (int)howManyXAxes; // 1 means only main axis.
- (int)howManyYAxes;
- (DGXAxisCommand *)xAxisNumber:(int)num; // 0 is the axisSettings object
- (DGYAxisCommand *)yAxisNumber:(int)num; // 0 is the axisSettings object
// Add/remove/move axis
- (DGXAxisCommand *)addXAxis; // Adds it to the end.
- (DGYAxisCommand *)addYAxis;
- (void)moveAxis:(DGAxisCommand *)axis toIndex:(int)index;  // Move x/y axis position.  Can not move the main axis.
- (void)removeAxis:(DGAxisCommand *)axis; // Can not remove the main axis.
- (void)removeXAxisAtIndex:(int)index; // Can not remove index==0, since that is the main axis.
- (void)removeYAxisAtIndex:(int)index; // Can not remove index==0


// ///////////////////////////////////////////////////////////////////
//                 Drawing commands
// ///////////////////////////////////////////////////////////////////

// Drawing commands. For more information, do
//    po [controller drawingCommand:3]
// to get information about the fourth drawing command.
- (int)howManyDrawingCommands;
- (DGCommand *)drawingCommand:(int)cNumber;
- (NSInteger)indexOfCommand:(DGCommand *)cmd;
- (DGCommand *)findCommandWithType:(NSString *)type skipOver:(int)howMany;
// Add/Remove/Move drawing commands
- (DGCommand *)addDrawingCommandWithType:(NSString *)type; // Adds it to the end.  Plot,Fit,Range,Box,Stock,Bars,Color Legend,Function,Points,Histogram,Label,Legend,Multiple Lines,Lines,Graphic,Text Block,Extra Axis
- (DGCommand *)addDrawingCommandByCopying:(DGCommand *)cmd; // cmd can belong to a different controller.
- (void)moveDrawingCommand:(DGCommand *)cmd toIndex:(int)index;
- (void)removeDrawingCommand:(DGCommand *)cmd;
- (void)removeDrawingCommandAtIndex:(int)index;
- (void)removeDrawingCommandsAtIndexes:(NSIndexSet *)indexes;

// Extract drawing commands by type.
- (DGBarCommand *)barCommand:(int)cmdNumber;
- (DGBarsCommand *)barsCommand:(int)cmdNumber;
- (DGGraphicCommand *)graphicCommand:(int)cmdNumber;
- (DGFitCommand *)fitCommand:(int)cmdNumber;
- (DGFunctionCommand *)functionCommand:(int)cmdNumber;
- (DGHistogramCommand *)histogramCommand:(int)cmdNumber;
- (DGLabelCommand *)labelCommand:(int)cmdNumber;
- (DGLinesCommand *)linesCommand:(int)cmdNumber;
- (DGPlotCommand *)plotCommand:(int)cmdNumber;
- (DGPlotsCommand *)plotsCommand:(int)cmdNumber;
- (DGPointsCommand *)pointsCommand:(int)cmdNumber;
- (DGRangeCommand *)rangeCommand:(int)cmdNumber;
- (DGStockCommand *)stockCommand:(int)cmdNumber;
- (DGTextCommand *)textCommand:(int)cmdNumber;
- (DGMagnifyCommand *)magnifyCommand:(int)cmdNumber;

// Create drawing commands. Adds them to the end.
- (DGBarCommand *)createBarCommand;
- (DGBarsCommand *)createBarsCommand;
- (DGGraphicCommand *)createGraphicCommand;
- (DGFitCommand *)createFitCommand;
- (DGFunctionCommand *)createFunctionCommand;
- (DGHistogramCommand *)createHistogramCommand;
- (DGLinesCommand *)createLinesCommand;
- (DGLabelCommand *)createLabelCommand;
- (DGPlotCommand *)createPlotCommand;
- (DGPlotsCommand *)createPlotsCommand;
- (DGPointsCommand *)createPointsCommand;
- (DGRangeCommand *)createRangeCommand;
- (DGStockCommand *)createStockCommand;
- (DGTextCommand *)createTextCommand;
- (DGMagnifyCommand *)createMagnifyCommand;
- (DGLegendCommand *)createLegendCommand;

// ///////////////////////////////////////////////////////////////////
//                 Drawing window
// ///////////////////////////////////////////////////////////////////
// Where the output will be displayed.  DPDrawingView is derived from NSView.
- (void)setDrawingView:(DPDrawingView *)v;
- (DPDrawingView *)drawingView;
- (void)redrawNow; // Rather than at the next screen refresh.
- (void)setHideBackground:(BOOL)yOrN;

// Convert from pixel to physical coordinates.
- (NSPoint)windowLocationInDrawingView:(NSPoint)locationInWindow; // To account for scaling/centering when you specify the size of the canvas.
- (double)convertXPoint:(double)xInPoints forAxis:(int)axisNumber;
- (double)convertYPoint:(double)yInPoints forAxis:(int)axisNumber;
- (double)convertToNiceXPoint:(double)xInPoints forAxis:(int)axisNumber; // Picks a point that is close by in terms of pixel location
- (double)convertToNiceYPoint:(double)yInPoints forAxis:(int)axisNumber; // but has a simpler numerical representation, like 3.14

// Testing where the mouse is
- (BOOL)point:(NSPoint)p liesInsideXAxis:(int)axisNumber;
- (BOOL)point:(NSPoint)p liesInsideYAxis:(int)axisNumber;



// ///////////////////////////////////////////////////////////////////
//                 Graphical output
// ///////////////////////////////////////////////////////////////////
// Output to clipboard
- (void)copyGraphic:(id)sender;
- (void)copyPDFOnly:(id)sender;
- (void)copyTIFFOnly:(id)sender;
- (void)copyOpaqueTIFFOnly:(id)sender;
// Output to use somewhere else
- (NSData *)epsData;
- (NSEPSImageRep *)eps;
- (NSData *)pdfData;
- (NSPDFImageRep *)pdf;
- (NSBitmapImageRep *)bitmapWithAlpha:(BOOL)alpha;
- (id)dtgGraphic; // Native format, can be used for graphic.
- (NSImage *)image;
- (NSImage *)imageWithSize:(NSSize)sz; // Do not use the size in the controller.

// Output to file
- (BOOL)writePDF:(NSString *)path;
- (BOOL)writeEPS:(NSString *)path;
- (BOOL)writeDTG:(NSString *)path;
- (BOOL)writeJPEG:(NSString *)path quality:(float)q;
- (BOOL)writeJPEG:(NSString *)path resolution:(double)dpi quality:(float)q;
- (BOOL)writePNG:(NSString *)path includeAlpha:(BOOL)alpha;
- (BOOL)writePNG:(NSString *)path resolution:(double)dpi includeAlpha:(BOOL)alpha;
- (BOOL)writeTIFF:(NSString *)path includeAlpha:(BOOL)alpha;
- (BOOL)writeTIFF:(NSString *)path resolution:(double)dpi includeAlpha:(BOOL)alpha;



// ///////////////////////////////////////////////////////////////////
//                 Animation on the screen
// ///////////////////////////////////////////////////////////////////
// Animation support.
- (BOOL)currentlyAnimating;
- (void)startAnimation:(id)sender;
- (void)stopAnimation:(id)sender;
- (void)connectAnimationDurationField:(NSTextField *)field;
- (void)setAnimationDurationString:(NSString *)str;
// Delegate functions
- (void)animationStarted:(DGController *)controller;
- (void)animationStopped:(DGController *)controller;



// ///////////////////////////////////////////////////////////////////
//                 Animation, saved into a QuickTime movie
// ///////////////////////////////////////////////////////////////////
- (void)createMovie:(id)sender; // Brings up a dialog, asks the user for name and compression settings.
// QuickTime output.  Basic one uses the animation parameter
- (BOOL)writeLosslessQuickTime:(NSString *)path fps:(float)fps;
- (BOOL)writeJPEGQuickTime:(NSString *)path quality:(NSString *)quality fps:(float)fps; // quality = maximum, high, normal, low
// Callbacks, sent to the delegate
- (void)drawingController:(DGController *)controller numberOfFrames:(int *)howManyFrames timePerFrame:(double *)timeInSeconds; // Tell how many frames should be used
- (BOOL)drawingController:(DGController *)controller startingMovieFrame:(int)frame outOf:(int)howMany; // Called before each frame is computed.  Return NO if movie should stop.
- (void)drawingController:(DGController *)controller finishedMovie:(NSString *)path; // Called when the movie is finished.



// *********************************************************************************************
// NOTE: Hard hat area.  If you start counting on this, please notify david@visualdatatools.com
// *********************************************************************************************

// Controlling what user can do interactively.  Big blocks here, and finer grained is inside command delegates if this is not implemented or returns YES.
- (BOOL)dataGraphAllowContextMenu:(DGController *)controller; // If NO, blocks the context menu completely.  Called at the start of a context menu click.
- (BOOL)dataGraphAllowAxisChanges:(DGController *)controller; // If NO, blocks interactive cropping and cropping floaters.
- (BOOL)dataGraphAllowCommandChanges:(DGController *)controller; // Drag legends, labels etc.

- (BOOL)dataGraph:(DGController *)controller interceptMouseDown:(NSEvent *)event; // Return YES if the controller should ignore it.
- (void)dataGraph:(DGController *)controller drawOverlayForRect:(NSRect)rect; // Called inside the drawRect: method for the graphic view.

// Context menu delegate calls
- (void)dataGraph:(DGController *)controller modifyContextMenu:(NSMenu *)menu; // Can modify the menu

// Callback so that it is easier to break on error messages.
+ (void)setErrorCallbackDelegate:(id)errorDelegate; // All error messages funneled to this delegate
- (void)DGerrorCallback:(NSString *)errorString; // The message sent to the delegate

// Loupe tool is set for each controller.
- (BOOL)displayLoupe;
- (void)setDisplayLoupe:(BOOL)yOrN;

// Display timing for profiling purposes.  NSLog() calls
- (BOOL)displayTimingResults;
- (void)setDisplayTimingResults:(BOOL)yOrN;

// The following commands should move to delegate calls for other objects.

// Parameters
- (void)parameterChanged:(DGParameter *)par; // One of the parameters changed.  Called before a redraw, so you can take appropriate action if something should depend on this.

// Hit testing (under development) - optional
// clickInfo dictionary has the following keys
// ScreenCoordinate = NSStringFromPoint(coordinate)
// XAxis = 0,1,2,...
// YAxis = 0,1,2,...
// XLocation = location in actual coordinates
// YLocation
- (BOOL)catchUserClickInDrawingContent:(DGCommand *)cmd clickInfo:(NSDictionary *)dict; // Return YES if you handle this (will not continue), and NO if it should be ignored.
- (BOOL)catchUserClickInBackgroundWithClickInfo:(NSDictionary *)dict; // Same as the 

// The next two will move to delegate functions, since finer grained control should be on an axis by axis basis.
- (BOOL)dataGraph:(DGController *)controller allowInteractiveCropInXAxis:(int)axisNumber;
- (BOOL)dataGraph:(DGController *)controller allowInteractiveCropInYAxis:(int)axisNumber;

// Controlling what the user can change.  This is being phased out.
// Instead there is a global "can I change any commands" - - (BOOL)dataGraphAllowCommandChanges:(DGController *)controller
// and then I will add delegate callbacks to each variable if you want to know if something changed.
// See for example the delegate methods for the range command.  Doing this rather than a catch-all method
- (BOOL)dataGraph:(DGController *)controller allowChangeInCommand:(DGCommand *)cmd; // cmd==nil means add a command (i.e. add a label)
- (BOOL)dataGraph:(DGController *)controller allowChangeInCommand:(DGCommand *)cmd fullInformation:(NSDictionary *)info; // gives more details what is changing.
- (BOOL)dataGraph:(DGController *)controller allowChangeInVariable:(DGVariable *)variable;


@end

