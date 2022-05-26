//
//  DGFitCommand.h
//
//  Created by David Adalsteinsson on 10/12/09.
//  Copyright 2009-2013, Visual Data Tools Inc. All rights reserved.
//

#import "DGCommand.h"

#import "DGFitCommandConstants.h"

@interface DGFitCommand : DGCommand {
    
}

- (void)selectXColumn:(DGDataColumn *)xCol yColumn:(DGDataColumn *)yCol;
- (DGDataColumn *)xColumn;
- (void)setXColumn:(DGDataColumn *)xCol;
- (DGDataColumn *)yColumn;
- (void)setYColumn:(DGDataColumn *)yCol;

- (DGFitCommandFunctionType)functionType;
- (void)setFunctionType:(DGFitCommandFunctionType)type;

// Settings for functions
- (void)setArbitraryExpression:(NSString *)expression; // DGFitCommandArbitrary
- (void)setInitialGuess:(NSString *)str forParameter:(NSString *)parName;
- (void)setOptimize:(BOOL)yOrN forParameter:(NSString *)parName;

// Getting the result
- (NSArray *)parameterList;
- (NSNumber *)valueForParameter:(NSString *)str;

- (DGLineStyleSettings *)line;
- (DGLineStyleSettings *)guessLine;
- (DGMaskSettings *)mask;

@end
