/*
 *  DGCommandConstants.h
 *
 *  Created by David Adalsteinsson on 6/28/09.
 *  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
 *
 */

// Menu tags
typedef enum _DGSimpleLineStyle {
    DGEmptyLineStyle		= 1,
    DGSolidLineStyle		= 2,
    DGDottedLineStyle		= 3,
    DGFineDotsLineStyle		= 4,
    DGCoarseDashLineStyle	= 5,
    DGFineDashLineStyle		= 6,
    DGDashDotLineStyle		= 7,
    DGStandardLineStyle     = 100
} DGSimpleLineStyle;

typedef enum _DGSimplePointStyle {
    DGEmptyPointStyle			= 1,
    DGCirclePointStyle			= 2,
    DGFilledCirclePointStyle	= 3,
    DGTrianglePointStyle		= 4,
    DGFilledTrianglePointStyle	= 5,
    DGBoxPointStyle				= 6,
    DGFilledBoxPointStyle		= 7,
    DGDiamondPointStyle			= 8,
    DGFilledDiamondPointStyle	= 9,
    DGPlusPointStyle			= 10,
    DGCrossPointStyle			= 11
} DGSimplePointStyle;

typedef enum _DGPatternType {
    DGPatternStandardBackward			= 1,
    DGPatternStandardForward			= 2,
    DGPatternStandardForwardBackward	= 3,
    DGPatternStandardHorizontal			= 4,
    DGPatternStandardVertical			= 5,
    DGPatternStandardHorizontalVertical	= 6,
    DGPatternFineBackward				= 11,
    DGPatternFineForward				= 12,
    DGPatternFineForwardBackward		= 13,
    DGPatternFineHorizontal				= 14,
    DGPatternFineVertical				= 15,
    DGPatternFineHorizontalVertical		= 16,
    DGPatternVeryFineBackward			= 21,
    DGPatternVeryFineForward			= 22,
    DGPatternVeryFineForwardBackward	= 23,
    DGPatternVeryFineHorizontal			= 24,
    DGPatternVeryFineVertical			= 25,
    DGPatternVeryFineHorizontalVertical	= 26,
} DGPatternType;

typedef enum _DGColorNumber {
    DGColorNumberSpecified = 0, // Color picker
    DGColorNumberPen = 1,
    DGColorNumberPoint = 2,
    DGColorNumberLine1 = 11,
    DGColorNumberLine2 = 12,
    DGColorNumberLine3 = 13,
    DGColorNumberLine4 = 14,
    DGColorNumberLine5 = 15,
    DGColorNumberLine6 = 16,
    DGColorNumberError = 17,
    DGColorNumberFill1 = 18,
    DGColorNumberFill2 = 19,
    DGColorNumberFill3 = 20,
    DGColorNumberFill4 = 21,
    DGColorNumberFill5 = 22,
    DGColorNumberFill6 = 23,
} DGColorNumber;
