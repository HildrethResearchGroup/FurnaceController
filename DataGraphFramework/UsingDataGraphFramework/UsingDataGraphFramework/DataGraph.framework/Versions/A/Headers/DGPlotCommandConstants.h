/*
 *  DGPlotCommandConstants.h
 *  DataGraph
 *
 *  Created by David Adalsteinsson on 7/8/09.
 *  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
 *
 */

typedef enum _DGPlotCommandFillStyle {
    DGPlotCommandFillY     = 1,
    DGPlotCommandFillYHigher = 2,
    DGPlotCommandFillYLower = 3,
    DGPlotCommandFillX     = 11,
    DGPlotCommandFillXHigher = 12,
    DGPlotCommandFillXLower = 13
} DGPlotCommandFillStyle;

typedef enum _DGPlotCommandConnections {
    DGPlotCommandStep     = 3,
    DGPlotCommandLine     = 1,
    DGPlotCommandSmooth   = 2
} DGPlotCommandConnections;

typedef enum _DGPlotCommandSmoothType {
    DGPlotCommandNaturalSpline      = 1,
    DGPlotCommandEstimateEndSlope   = 2
} DGPlotCommandSmoothType;

typedef enum _DGPlotCommandStepType {
    DGPlotCommandJumpAtNextValue    = 1, // Side->Up
    DGPlotCommandJumpAtFirstValue   = 2  // Up->Side
} DGPlotCommandStepType;

typedef enum _DGPlotCommandLegendLocation {
    DGPlotCommandLegendInLegendCommand = 1,
    DGPlotCommandLegendAtEnd           = 2
} DGPlotCommandLegendLocation;
