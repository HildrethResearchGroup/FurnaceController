//
//  DGScalarFieldCommmand.h
//  DataGraph
//
//  Created by David Adalsteinsson on 8/26/15.
//  Copyright (c) 2015 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"

#import "DGScalarFieldCommandConstants.h"

@interface DGScalarFieldCommand : DGCommand
{
}

- (void)setValueColumn:(DGDataColumn *)col;

// Set the type of the scalar field
- (void)setLayout:(DGScalarFieldCommandLayout)type;

// If you have a flattened layout, set the columns
- (void)setFlattenedXColumn:(DGDataColumn *)xCol yColumn:(DGDataColumn *)yCol;

// If you specify the x and y coordinates by using columns
- (void)setSpecifiedXColumn:(DGDataColumn *)xCol yColumn:(DGDataColumn *)yCol;

// If you specify a grid, set the grid definition
- (void)setGridOrigin:(NSString *)str stepSizes:(NSString *)str;

- (DGMaskSettings *)mask;

@end
