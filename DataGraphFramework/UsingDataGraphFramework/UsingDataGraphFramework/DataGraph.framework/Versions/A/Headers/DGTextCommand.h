//
//  DGTextCommand.h
//  Stocks
//
//  Created by David Adalsteinsson on 3/8/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGAxisCommand.h"


@interface DGTextCommand : DGAxisCommand {

}

- (BOOL)setTextLines:(NSArray *)listOfTokens; // NSArray of NSArray of DGToken objects.

@end
