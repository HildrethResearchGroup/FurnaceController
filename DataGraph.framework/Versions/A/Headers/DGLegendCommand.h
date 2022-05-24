//
//  DGLegendCommand.h
//  DataGraph
//
//  Created by David Adalsteinsson on 10/12/09.
//  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
//

#import "DGCommand.h"

#import "DGLegendCommandConstants.h"

@interface DGLegendCommand : DGCommand {

}

- (void)setLocation:(DGLegendCommandLocation)where;
- (void)setNumberOfLegendColumns:(int)howMany;
- (void)setBorder:(DGSimpleLineStyle)type;
- (void)setLegendWidth:(CGFloat)w;

@end
