//
//  AppDelegate.h
//  DTimer
//
//  Created by Namburi, Kalyan on 12/9/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainView.h"
#import "NSClickableTextField.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (retain) IBOutlet NSWindow *window;
@property (atomic, retain) MainView *mainView;
@property (weak) IBOutlet NSClickableTextField *minTF;
@property (weak) IBOutlet NSClickableTextField *secTF;


- (void)doubleClick:(id)sender;
- (void)changeSec:(id)sender;

@end
