//
//  DGGraphicCommand.h
//  DataGraph
//
//  Created by David Adalsteinsson on 3/29/09.
//  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
//

#import "DGCommand.h"

@interface DGGraphicCommand : DGCommand {

}

- (BOOL)setGraphicFromFile:(NSString *)fileName;
- (BOOL)setGraphicFromBitmap:(NSBitmapImageRep *)bitmap;

@end
