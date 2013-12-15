//
//  AppDelegate.h
//  DTimer
//
//  Created by Namburi, Kalyan on 12/9/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MainView.h"
#import "MainWindow.h"
#import "NSClickableTextField.h"
#import "ControlArrows.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSMenu *mainMenu;
@property (retain) IBOutlet MainWindow *window;
@property (atomic, retain) MainView *mainView;
@property (weak) IBOutlet NSClickableTextField *minTF;
@property (weak) IBOutlet NSClickableTextField *secTF;

@property (weak) IBOutlet ControlArrows *secControlArrow;
@property (weak) IBOutlet ControlArrows *minControlArrow;

- (void)doubleClick:(id)sender;
- (void)changeSec:(id)sender;

@end
