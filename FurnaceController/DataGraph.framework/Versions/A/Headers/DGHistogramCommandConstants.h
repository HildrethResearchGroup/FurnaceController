/*
 *  DGHistogramCommandConstants.h
 *  DataGraph
 *
 *  Created by David Adalsteinsson on 7/8/09.
 *  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
 *
 */

typedef enum _DGHistogramCommandDirection {
    DGHistogramCommandXDirection = 1,
    DGHistogramCommandYDirection = 2
} DGHistogramCommandDirection;

typedef enum _DGHistogramCommandType {
    DGHistogramCommandCenters = 1,
    DGHistogramCommandStairs = 2,
    DGHistogramCommandBars = 3,
    DGHistogramCommandSpacedBars = 4,
    DGHistogramCommandLeft = 5,
    DGHistogramCommandBelo = 5,
    DGHistogramCommandRight = 6,
    DGHistogramCommandAbove = 6,
    DGHistogramCommandSmooth = 10
} DGHistogramCommandType;

typedef enum _DGHistogramCommandGaussianType {
    DGHistogramCommandGaussianSlider = 1,
    DGHistogramCommandGaussianWidth = 2
} DGHistogramCommandGaussianType;

