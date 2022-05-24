//
//  Use this file to import your target's public headers that you would like to expose to Swift.
//

// Make sure the Framework is installed in the Folder after the .proj file
// Make sure the path to the Bridging Header is correct
    // Project → Build Settings → Swift Compiler - General → Objective-C Bridging Header:  <Internal Path: e.g. TestApp/TestApp-Bridging-Header.h>
// Bridging header attached to the Project, not the Target
// https://stackoverflow.com/questions/27496055/getting-file-not-found-in-bridging-header-when-importing-objective-c-framework
// 
// Remember to switch Architecture to x86_64 on both the Project and the Target
// Sign to run locally
// Embed DataGraph Framework

// https://developer.apple.com/documentation/swift/imported_c_and_objective-c_apis/importing_objective-c_into_swift
// Under Build Settings, in Packaging, make sure the Defines Module setting for the framework target is set to Yes.

// Turn OFF library validation
// Targets → Signing and Capabilities → Hardened Runtime → Check "ON" Disable Library Validation


 //#import "DPDrawingView.h"
 #import "DataGraph.framework/Headers/DGAxisCommand.h"
 #import "DataGraph.framework/Headers/DGAxisCommandConstants.h"
 #import "DataGraph.framework/Headers/DGBarCommand.h"
 #import "DataGraph.framework/Headers/DGBarCommandConstants.h"
 #import "DataGraph.framework/Headers/DGBarsCommand.h"
 #import "DataGraph.framework/Headers/DGBarsCommandConstants.h"
 #import "DataGraph.framework/Headers/DGBoxCommand.h"
 #import "DataGraph.framework/Headers/DGBoxCommandConstants.h"
 #import "DataGraph.framework/Headers/DGCanvasCommand.h"
 #import "DataGraph.framework/Headers/DGCanvasCommandConstants.h"
 #import "DataGraph.framework/Headers/DGColorScheme.h"
 #import "DataGraph.framework/Headers/DGColorsCommand.h"
 #import "DataGraph.framework/Headers/DGColorsCommandConstants.h"
 #import "DataGraph.framework/Headers/DGCommand.h"
 #import "DataGraph.framework/Headers/DGCommandConstants.h"
 #import "DataGraph.framework/Headers/DGController.h"
 #import "DataGraph.framework/Headers/DGDataColumn.h"
 #import "DataGraph.framework/Headers/DGExtraAxisCommand.h"
 #import "DataGraph.framework/Headers/DGExtraAxisCommandConstants.h"
 #import "DataGraph.framework/Headers/DGFillSettings.h"
 #import "DataGraph.framework/Headers/DGFitCommand.h"
 #import "DataGraph.framework/Headers/DGFitCommandConstants.h"
 #import "DataGraph.framework/Headers/DGFunctionCommand.h"
 #import "DataGraph.framework/Headers/DGFunctionCommandConstants.h"
 #import "DataGraph.framework/Headers/DGGraph.h"
 #import "DataGraph.framework/Headers/DGGraphicCommand.h"
 #import "DataGraph.framework/Headers/DGGraphicCommandConstants.h"
 #import "DataGraph.framework/Headers/DGHistogramCommand.h"
 #import "DataGraph.framework/Headers/DGHistogramCommandConstants.h"
 #import "DataGraph.framework/Headers/DGLabelCommand.h"
 #import "DataGraph.framework/Headers/DGLabelCommandConstants.h"
 #import "DataGraph.framework/Headers/DGLegendCommand.h"
 #import "DataGraph.framework/Headers/DGLegendCommandConstants.h"
 #import "DataGraph.framework/Headers/DGLineStyleSettings.h"
 #import "DataGraph.framework/Headers/DGLinesCommand.h"
 #import "DataGraph.framework/Headers/DGLinesCommandConstants.h"
 #import "DataGraph.framework/Headers/DGMagnifyCommand.h"
 #import "DataGraph.framework/Headers/DGMagnifyCommandConstants.h"
 #import "DataGraph.framework/Headers/DGMaskSettings.h"
 #import "DataGraph.framework/Headers/DGMaskSettingsConstants.h"
 #import "DataGraph.framework/Headers/DGNumberVariable.h"
 #import "DataGraph.framework/Headers/DGParameter.h"
 #import "DataGraph.framework/Headers/DGPlotCommand.h"
 #import "DataGraph.framework/Headers/DGPlotCommandConstants.h"
 #import "DataGraph.framework/Headers/DGPlotsCommand.h"
 #import "DataGraph.framework/Headers/DGPlotsCommandConstants.h"
 #import "DataGraph.framework/Headers/DGPointsCommand.h"
 #import "DataGraph.framework/Headers/DGPointsCommandConstants.h"
 #import "DataGraph.framework/Headers/DGRangeCommand.h"
 #import "DataGraph.framework/Headers/DGRangeCommandConstants.h"
 #import "DataGraph.framework/Headers/DGScalarFieldCommand.h"
 #import "DataGraph.framework/Headers/DGScalarFieldCommandConstants.h"
 #import "DataGraph.framework/Headers/DGStockCommand.h"
 #import "DataGraph.framework/Headers/DGStockCommandConstants.h"
 #import "DataGraph.framework/Headers/DGStringParameter.h"
 #import "DataGraph.framework/Headers/DGStructures.h"
 #import "DataGraph.framework/Headers/DGStylesCommand.h"
 #import "DataGraph.framework/Headers/DGStylesCommandConstants.h"
 #import "DataGraph.framework/Headers/DGTextCommand.h"
 #import "DataGraph.framework/Headers/DGTextCommandConstants.h"
 #import "DataGraph.framework/Headers/DGToken.h"
 #import "DataGraph.framework/Headers/DGVariable.h"
 #import "DataGraph.framework/Headers/DGXAxisCommand.h"
 #import "DataGraph.framework/Headers/DGYAxisCommand.h"
 #import "DataGraph.framework/Headers/DataGraph.h"

 @interface DPDrawingView : NSView

 @end

 
