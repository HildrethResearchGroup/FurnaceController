//
//  DGBoxCommand.h
//
//  Copyright 2009-2013 Visual Data Tools, Inc. All rights reserved.
//

#import "DGCommand.h"

@interface DGBoxCommand : DGCommand {

}

- (DGFillSettings *)fill;
- (DGLineStyleSettings *)line;
- (DGMaskSettings *)mask;

@end
