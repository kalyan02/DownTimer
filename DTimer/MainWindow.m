//
//  MainWindow.m
//  DTimer
//
//  Created by Kalyan on 14/12/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "MainWindow.h"
#import "Constants.h"

@implementation MainWindow

- (void)keyUp:(NSEvent *)theEvent
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_doubleClick object:nil];
}

- (BOOL)canBecomeKeyWindow
{
    return YES;
}

@end
