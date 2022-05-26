//
//  DGToken.h
//  DataGraphFrameworkTest
//
//  Created by David Adalsteinsson on 1/27/08.
//  Copyright 2008-2013 Visual Data Tools, Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// A support class for token inputs in drawing commands.  This allows you to
// programmatically get and set strings that use parameters, and labels.

@class DGCommand;

@interface DGToken : NSObject
{
    NSString *string;
    int drawingCommandNumber;
    NSString *labelName;
    NSString *parameterName;
    NSString *columnName;
    
    // Formatting
    int howManyDigits;
    NSString *dateFormatString;
}

- (id)initWithString:(NSString *)str;
- (id)initWithParameter:(NSString *)str;
- (id)initWithColumn:(NSString *)str;
- (id)initWithCommand:(DGCommand *)cmd label:(NSString *)label;

+ (DGToken *)tokenWithString:(NSString *)str;
+ (DGToken *)tokenWithParameter:(NSString *)str;
+ (DGToken *)tokenWithColumn:(NSString *)str;
+ (DGToken *)tokenWithCommand:(DGCommand *)cmd label:(NSString *)label;

@end

