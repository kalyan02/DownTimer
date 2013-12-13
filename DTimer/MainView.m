//
//  MainView.m
//  DTimer
//
//  Created by Namburi, Kalyan on 12/9/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "MainView.h"
#import "Constants.h"

@implementation MainView

NSPoint initialMousePos;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    NSLog(@"--%ld", (long)theEvent.clickCount );
    if ( (long)theEvent.clickCount > 1) {
        //[NSWorkspace sharedWorkspace] notificationCenter
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotification_doubleClick object:nil];
        NSLog(@"--%ld", (long)theEvent.clickCount );
    }
}

- (void)mouseDown:(NSEvent *)theEvent
{
    NSRect windowFrame = self.window.frame;
    initialMousePos = [NSEvent mouseLocation];
    initialMousePos.x -= windowFrame.origin.x;
    initialMousePos.y -= windowFrame.origin.y;
}

- (void)mouseDragged:(NSEvent *)theEvent
{
    NSPoint currentLocation = [NSEvent mouseLocation];
    NSPoint newOrigin;
    
    NSRect screenFrame = [[NSScreen mainScreen] frame];
    NSRect windowFrame = [self frame];
    newOrigin.x = currentLocation.x - initialMousePos.x;
    newOrigin.y = currentLocation.y - initialMousePos.y;

   
    if ((newOrigin.y + windowFrame.size.height) > screenFrame.origin.y+screenFrame.size.height - 22) {
        newOrigin.y=screenFrame.origin.y + (screenFrame.size.height-windowFrame.size.height) - 22;
    }
    
    [self.window setFrameOrigin:newOrigin];
    
}

- (void)drawRect:(NSRect)dirtyRect
{
	[super drawRect:dirtyRect];
	
    // Drawing code here.
}

@end
