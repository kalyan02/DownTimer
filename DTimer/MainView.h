//
//  MainView.h
//  DTimer
//
//  Created by Namburi, Kalyan on 12/9/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MainView : NSView
@property (weak) IBOutlet NSTextField *sec;
@property (weak) IBOutlet NSTextField *min;
@property (weak) IBOutlet NSTextFieldCell *textSec;
@property (weak) IBOutlet NSTextFieldCell *textMin;



@end
