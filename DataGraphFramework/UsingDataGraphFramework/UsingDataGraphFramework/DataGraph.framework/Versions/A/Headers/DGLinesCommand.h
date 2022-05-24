//
//  DGLinesCommand.h
//
//  Created by David Adalsteinsson on 10/6/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"

#import "DGLinesCommandConstants.h"

@interface DGLinesCommand : DGCommand {

}

- (void)setLineType:(DGLinesCommandType)type;

- (void)setValueColumn:(DGDataColumn *)col;
- (void)setValueListString:(NSString *)str;
- (void)setLowerColumn:(DGDataColumn *)col; // nil means specified value
- (void)setLowerValueString:(NSString *)str;
- (void)setUpperColumn:(DGDataColumn *)col;
- (void)setUpperValueString:(NSString *)str;
- (void)setLabelColumn:(DGDataColumn *)col;
- (void)setLabelPosition:(DGLinesCommandLabelPosition)pos;
- (void)setLabelOffsetString:(NSString *)str;

- (DGLineStyleSettings *)line;
- (DGMaskSettings *)mask;

@end
