/*
 *  DGCanvasCommandConstants.h
 *  DataGraph
 *
 *  Created by David Adalsteinsson on 7/8/09.
 *  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
 *
 */

typedef enum _DGCanvasCommandMagnification {
    DGCanvasCommandScale25 = 25,
    DGCanvasCommandScale50 = 50,
    DGCanvasCommandScale75 = 75,
    DGCanvasCommandScale100 = 100,
    DGCanvasCommandScale150 = 150,
    DGCanvasCommandScale200 = 200,
    DGCanvasCommandScale300 = 300,
    DGCanvasCommandScale400 = 400,
    DGCanvasCommandScale600 = 600,
    DGCanvasCommandScale800 = 800
} DGCanvasCommandMagnification;

typedef enum _DGCanvasCommandStacking {
    DGCanvasCommandStackXStackY = 1,
    DGCanvasCommandJoinXStackY = 2,
    DGCanvasCommandStackXJoinY = 3,
    DGCanvasCommandJoinXJoinY = 4
} DGCanvasCommandStacking;

typedef enum _DGCanvasCommandSpaceForX {
    DGCanvasCommandXNarrow     = 1,
    DGCanvasCommandXMedium     = 2,
    DGCanvasCommandXHigh       = 3,
    DGCanvasCommandXExtraHigh  = 4,
    DGCanvasCommandXDoubleHigh = 5
} DGCanvasCommandSpaceForX;

typedef enum _DGCanvasCommandSpaceForY {
    DGCanvasCommandYNarrow     = 1,
    DGCanvasCommandYMedium     = 2,
    DGCanvasCommandYWide       = 3,
    DGCanvasCommandWExtraWide  = 4
} DGCanvasCommandSpaceForY;

