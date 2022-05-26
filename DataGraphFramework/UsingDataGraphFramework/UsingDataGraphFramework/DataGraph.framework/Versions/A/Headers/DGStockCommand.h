//
//  DGStockCommand.h
//  Stocks
//
//  Created by David Adalsteinsson on 3/7/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"


@interface DGStockCommand : DGCommand {
}

- (DGDataColumn *)dateColumn;
- (NSInteger)rowClosestTo:(double)time;

@end
