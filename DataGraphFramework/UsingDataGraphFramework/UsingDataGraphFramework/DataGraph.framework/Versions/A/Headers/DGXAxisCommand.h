//
//  DGXAxisCommand.h
//  Stocks
//
//  Created by David Adalsteinsson on 3/8/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGAxisCommand.h"

@interface DGXAxisCommand : DGAxisCommand {

}

// Delegate methods
- (BOOL)allowInteractiveChangeInXCroppingRangeEdge:(DGXAxisCommand *)cmd; // Change only the min or max
- (BOOL)allowInteractiveChangeInXCroppingRangeCenter:(DGXAxisCommand *)cmd; // Change min and max and keep width.

- (void)setHeightForNumbers:(DGAxisSpaceForX)type;

@end
