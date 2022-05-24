/*
 *  DGAxisCommandConstants.h
 *
 *  Created by David Adalsteinsson on 6/28/09.
 *  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
 *
 */

typedef enum _DGAxisTypeOptions {
    DGAxisTypeLinear		= 1,
    DGAxisTypeReverse		= 3,
    DGAxisTypeLogarithmic	= 2,
    DGAxisTypeReverseLogarithmic = 4
} DGAxisTypeOptions;

typedef enum _DGAxisTickMarkOptions {
    DGTickMarksAutomatic	= 1,
    DGTickMarksUniform		= 2,
    DGTickMarksSpecified	= 3,
    DGTickMarksLabels		= 4,
    DGTickMarksCategories	= 5,
    DGTickMarksAngles       = 6
} DGAxisTickMarkOptions;

typedef enum _DGAxisPaddingOptions {
    DGAxisPaddingNone		= 1,
    DGAxisPaddingSnapTo0	= 2,
    DGAxisPaddingNiceValue	= 3,
    DGAxisPadding5Percent	= 10,
    DGAxisPadding10Percent	= 11
} DGAxisPaddingOptions;



// Only for the x axis
typedef enum _DGAxisSpaceForX {
    DGAxisXNarrow     = 1,
    DGAxisXMedium     = 2,
    DGAxisXHigh       = 3,
    DGAxisXExtraHigh  = 4,
    DGAxisXDoubleHigh = 5
} DGAxisSpaceForX;


// Only for the y axis
typedef enum _DGAxisSpaceForY {
    DGAxisYNarrow     = 1,
    DGAxisYMedium     = 2,
    DGAxisYWide       = 3,
    DGAxisYExtraWide  = 4
} DGAxisSpaceForY;

