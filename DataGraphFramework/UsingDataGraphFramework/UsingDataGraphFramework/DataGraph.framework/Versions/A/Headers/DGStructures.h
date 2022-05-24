//
//  DGStructures.h

//  Created by David Adalsteinsson on 3/8/09.
//  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
//

typedef struct _DGRange {
    double minV,maxV;
} DGRange;

static __inline__ DGRange DGMakeRange(double x,double y) {
    DGRange r;
    r.minV = (x<y ? x : y);
    r.maxV = (x<y ? y : x);
    return r;
}

