//
//  DGGraph.h
//  DataGraph
//
//  Created by David Adalsteinsson on 8/30/15.
//  Copyright (c) 2015 Visual Data Tools, Inc. All rights reserved.
//

#include "DGController.h"

// Represents a graph, parent is DGController and you can extract commands

@class DataDocumentDrawing;
@class DGStylesCommand;
@class DGCanvasCommand;
@class DPDrawingView;

@class DGScalarFieldCommand;

@interface DGGraph : NSObject
{
    DGController *_controller;
    DataDocumentDrawing *_graph;

    // The axis command is split in half in the framework.
    DGXAxisCommand *xPortionOfAxis;
    DGYAxisCommand *yPortionOfAxis;
    NSMutableDictionary *commandsThatHaveBeenCreated;
}

- (void)setDrawingView:(DPDrawingView *)v;

- (DGStylesCommand *)styleSettings; // Style sheet
- (DGCanvasCommand *)canvasSettings; // Canvas

// Create drawing commands. Adds them to the end.
- (DGScalarFieldCommand *)createScalarFieldCommand;

@end
