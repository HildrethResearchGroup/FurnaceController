//
//  DGFunctionCommand.h
//  DataGraph
//
//  Created by David Adalsteinsson on 10/12/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"

#import "DGFitCommandConstants.h"

@interface DGFunctionCommand : DGCommand {

}

- (void)setFunctionString:(NSString *)str;
- (void)setRange:(DGRange)r;
- (void)setRangeString:(NSString *)str;
- (void)setFillFromFunctionString:(NSString *)str;
- (void)setIncludeInYString:(NSString *)str;
- (void)setCropYString:(NSString *)str;
- (void)setCropY:(DGRange)r;

- (DGLineStyleSettings *)line;
- (DGFillSettings *)fill;

@end
