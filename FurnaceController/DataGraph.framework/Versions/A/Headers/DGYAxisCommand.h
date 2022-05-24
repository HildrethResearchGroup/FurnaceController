//
//  DGYAxisCommand.h
//  Stocks
//
//  Created by David Adalsteinsson on 3/8/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGAxisCommand.h"


@interface DGYAxisCommand : DGAxisCommand {

}

// Delegate methods.  Called if allowInteractiveChange: is not implemented or returns YES.
- (BOOL)allowInteractiveChangeInYCroppingRangeEdge:(DGYAxisCommand *)cmd;
- (BOOL)allowInteractiveChangeInYCroppingRangeCenter:(DGYAxisCommand *)cmd;

- (void)setWidthForNumbers:(DGAxisSpaceForY)type;

@end
