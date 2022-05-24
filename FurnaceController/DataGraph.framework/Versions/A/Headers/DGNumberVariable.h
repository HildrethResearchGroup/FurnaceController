#import "DGParameter.h"

// A number variable
@interface DGNumberVariable : DGParameter
{
    
}

@end

@interface DGConstantNumberVariable : DGNumberVariable
{
    
}

- (void)setDoubleValue:(double)v;

@end

@interface DGConstantCurrentTimeVariable : DGNumberVariable
{
    
}

@end