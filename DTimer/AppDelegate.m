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
#import <QuartzCore/QuartzCore.h>

#import "ControlArrows.h"

NSInteger totalSeconds;
NSTimer *timer;

@interface AppDelegate()
@property (nonatomic) BOOL timerRunning;
@property (nonatomic,strong) NSStatusItem *statusItem;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // setup status bar
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setHighlightMode:NO];
    [self.statusItem setMenu:nil];
    [self.statusItem setAction:@selector(showWindow)];
    
    
    // setup timer
    totalSeconds = 10;
    [self updateTimer];
    [self setTimerRunning:NO];
    
    [self showWindow];
    


    self.secControlArrow.alphaValue = 0;
    self.minControlArrow.alphaValue = 0;
    

    // setup window events
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubleClick:) name:kNotification_doubleClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSec:) name:kNotification_changeSeconds object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMin:) name:kNotification_changeMinutes object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMinControlArrows:) name:kNotification_hoverMinutes object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleSecControlArrows:) name:kNotification_hoverSeconds object:nil];
}

#pragma mark - Window Utilities

- (void)shakeWindow
{
    // define some animation related constants
    static int numberOfShakes = 8;
    static float durationOfShake = 0.2f;
    static float vigourOfShake = 0.05f;
    
    CGRect frame = self.window.frame;
    
    // Perform animation computation
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animation];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, NSMinX(frame), NSMinY(frame));
    int index;
    for (index = 0; index < numberOfShakes; ++index)
    {
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) - frame.size.width * vigourOfShake, NSMinY(frame));
        CGPathAddLineToPoint(shakePath, NULL, NSMinX(frame) + frame.size.width * vigourOfShake, NSMinY(frame));
    }
    CGPathCloseSubpath(shakePath);
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = durationOfShake;

    // Invoke the animation
    self.window.animations = @{ @"frameOrigin" : shakeAnimation };
    [self.window.animator setFrameOrigin:self.window.frame.origin];
}

- (void)showWindow
{
    // Bring the app window to front
    // and make it first responder
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
    [self.window firstResponder];
}

#pragma mark - Timer Utility
- (void)setTimerRunning:(BOOL)timerRunning
{
    _timerRunning = timerRunning;
    if (_timerRunning) {
        if (timer) {
            return;
        }
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                 target:self
                                               selector:@selector(timerTick:)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

- (void)timerTick:(NSTimer *)aTimer
{
    if (totalSeconds>0) {
        totalSeconds --;
    }
    if (totalSeconds <= 0) {
        [self setTimerRunning:NO];
        [self showWindow];
        [self shakeWindow];
    }
    [self updateTimer];
}

#pragma mark - User Interface Actions

- (void)toggleMinControlArrows:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    BOOL isEnter = [userInfo[@"type"] isEqualToString:@"enter"];
    
    self.minControlArrow.alphaValue = isEnter;
}

- (void)toggleSecControlArrows:(id)sender
{
    NSDictionary *userInfo = [sender userInfo];
    BOOL isEnter = [userInfo[@"type"] isEqualToString:@"enter"];
    
    self.secControlArrow.alphaValue = isEnter;
}

- (void)doubleClick:(id)sender
{
    if (self.timerRunning) {
        [self setTimerRunning:NO];
    } else {
        [self setTimerRunning:YES];
    }
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
}

- (void)updateTimer //display
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
    
    [self.statusItem setTitle:[NSString stringWithFormat:@"%@:%@", self.minTF.stringValue, self.secTF.stringValue]];
}

@end
