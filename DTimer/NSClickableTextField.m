//
//  NSClickableTextField.m
//  DTimer
//
//  Created by Namburi, Kalyan on 12/13/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "NSClickableTextField.h"

@implementation NSClickableTextField

//- (BOOL)acceptsFirstResponder
//{
//    return YES;
//}
//
//- (BOOL)becomeFirstResponder
//{
//    return YES;
//}
//
//- (BOOL)canBecomeKeyView
//{
//    return  YES;
//}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.notificationName) {
            self.notificationName = nil;
        }
        // Initialization code here.
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

- (void)scrollWheel:(NSEvent *)theEvent
{
    if (self.notificationName) {
        [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName
                                                            object:nil
                                                          userInfo:@{ @"deltaY" : @(theEvent.deltaY) }];
    }
}

//- (void)mouseDown:(NSEvent *)theEvent
//{
//    if (self.notificationName) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:self.notificationName object:nil];
//    }
//}

@end
