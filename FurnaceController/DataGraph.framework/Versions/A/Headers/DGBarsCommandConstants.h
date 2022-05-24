/*
 *  DGBarsCommandConstants.h
 *
 *  Created by David Adalsteinsson on 6/28/09.
 *  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
 *
 */

typedef enum _DGBarsCommandType {
    DGBarsCommandXStandard = 1,
    DGBarsCommandXStacked  = 2,
    DGBarsCommandXArea     = 3,
    DGBarsCommandYStandard = 11,
    DGBarsCommandYStacked  = 12,
    DGBarsCommandYArea     = 13
} DGBarsCommandType;

typedef enum _DGBarsCommandFill {
    DGBarsCommandSolid       = 1,
    DGBarsCommandPattern     = 2,
    DGBarsCommandFinePattern = 3,
    DGBarsCommandGradient    = 10
} DGBarsCommandFill;

