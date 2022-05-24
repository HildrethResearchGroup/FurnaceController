//
//  DGHistogramCommand.h
//  Crop Region
//
//  Created by David Adalsteinsson on 6/27/09.
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"
#import "DGHistogramCommandConstants.h"

@interface DGHistogramCommand : DGCommand {

}

- (void)selectColumn:(DGDataColumn *)col;
- (void)setHistgramDirection:(DGHistogramCommandDirection)dir;
- (void)setHistogramType:(DGHistogramCommandType)type;

// Used when histogram type == DGHistogramCommandSmooth
- (void)setSmoothGaussianType:(DGHistogramCommandGaussianType)type;
- (void)setSmoothGaussianTypeSliderValue:(double)val; // DGHistogramCommandGaussianSlider valid range is [0.01,0.1], fraction of width
- (void)setSmoothGaussianWidthString:(NSString *)str; // DGHistogramCommandGaussianWidth // Can use the variable width, for example 0.1*width
- (void)setSmoothGaussianWidthValue:(double)val; // DGHistogramCommandGaussianWidth // Can use the variable width, for example 0.1*width

- (DGFillSettings *)fill;
- (DGLineStyleSettings *)line;
- (DGMaskSettings *)mask;

@end
