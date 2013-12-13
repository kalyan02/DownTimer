//
//  AppDelegate.m
//  DTimer
//
//  Created by Namburi, Kalyan on 12/9/13.
//  Copyright (c) 2013 KC. All rights reserved.
//

#import "AppDelegate.h"
#import "MainView.h"
#import "Constants.h"

NSInteger totalSeconds;
BOOL isRunning;
NSTimer *timer;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [self.mainView.textSec setStringValue:@"ff"];
    
    isRunning = NO;
    
    timer = NSTimer timer

    totalSeconds = 10;
    [self updateTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubleClick:) name:kNotification_doubleClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSec:) name:kNotification_changeSeconds object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMin:) name:kNotification_changeMinutes object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editClick:) name:kNotification_singleClick object:nil];
    
}

- (void)doubleClick:(id)sender
{
    NSLog(@"ok double clicked");
}

- (void)changeSec:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    CGFloat deltaY = [userInfo[@"deltaY"] floatValue];

    if ( deltaY > 1.0 || deltaY < 1.0 ) {
        if ( totalSeconds + deltaY > 0 ) {
            totalSeconds += deltaY;
            [self updateTimer];
        } else
        if ( totalSeconds + deltaY < 0 ) {
            totalSeconds = 0;
            [self updateTimer];
        }
    }
    
    NSLog(@"ok scrolled by %f", deltaY);
}

- (void)changeMin:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    CGFloat deltaY = [userInfo[@"deltaY"] floatValue];
    
    if ( deltaY > 1.0 || deltaY < 1.0 ) {
        float plusSec = 60 * round(deltaY);
        if ( totalSeconds + plusSec > 0 ) {
            totalSeconds += plusSec;
            [self updateTimer];
        } else
            if ( totalSeconds + plusSec < 0 ) {
                totalSeconds = totalSeconds % 60;
                [self updateTimer];
            }
    }
    
    NSLog(@"ok scrolled by %f", deltaY);
}

- (IBAction)updateSec:(id)sender {
    NSLog(@"%@", sender);
}

- (void)updateTimer
{
    NSInteger sec = totalSeconds % 60;
    NSInteger min = totalSeconds / 60;
    
    if (min > 9) {
        self.minTF.integerValue = min;
    } else {
        self.minTF.stringValue = [NSString stringWithFormat:@"0%ld", min];
    }
    if (sec > 9) {
        self.secTF.integerValue = sec;
    } else {
        self.secTF.stringValue = [NSString stringWithFormat:@"0%ld", sec];
    }
}

@end
