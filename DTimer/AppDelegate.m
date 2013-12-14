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

NSInteger totalSeconds;
NSTimer *timer;

@interface AppDelegate()
@property (nonatomic) BOOL timerRunning;
@property (nonatomic,strong) NSStatusItem *statusItem;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [self.statusItem setHighlightMode:NO];
    [self.statusItem setMenu:nil];
    [self.statusItem setAction:@selector(showWindow)];
    
    
    [self showWindow];
    [self setTimerRunning:NO];
    [self updateTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doubleClick:) name:kNotification_doubleClick object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSec:) name:kNotification_changeSeconds object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMin:) name:kNotification_changeMinutes object:nil];    
}

#pragma mark - Window Utilities

static int numberOfShakes = 8;
static float durationOfShake = 0.2f;
static float vigourOfShake = 0.05f;
- (CAKeyframeAnimation *)shakeAnimation:(NSRect)frame
{
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
    return shakeAnimation;
}

- (void)showWindow
{
    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:nil];
}

- (void)shakeWindow
{
    self.window.animations = @{ @"frameOrigin" : [self shakeAnimation:self.window.frame] };
    [self.window.animator setFrameOrigin:self.window.frame.origin];
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
    
    [self.statusItem setTitle:[NSString stringWithFormat:@"%@:%@", self.minTF.stringValue, self.secTF.stringValue]];
}

@end
