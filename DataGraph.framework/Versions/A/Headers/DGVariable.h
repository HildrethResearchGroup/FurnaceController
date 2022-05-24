//
//  DGVariable.h
//  DataGraphFrameworkTest
//
//  Created by David Adalsteinsson on 8/9/07.
//  Copyright 2007-2008 Visual Data Tools Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class DGController;
@class DPVariable;
@class DGActionList;

@interface DGVariable : NSObject
{
    DGController *controller;
    DPVariable *variable;

    // Thread support
    NSLock *accessLock;
    DGActionList *waitingForSync;
    DGActionList *waitingToBeApplied;
    DGActionList *readyToBeSubmitted;
}

- (DGController *)controller;

- (BOOL)isDisconnected; // Variable might have been removed.

- (void)setName:(NSString *)nm;
- (NSString *)name;
- (NSString *)type; //Color Scheme, Slider, Value, Date, String

- (BOOL)hasConnectedUI;

@end
