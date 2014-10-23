//
//  UCMainView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 09/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCMainView.h"

@implementation UCMainView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    [[NSColor colorWithCalibratedWhite:0.9 alpha:1.0] setFill];
    NSRectFill(dirtyRect);
}

@end
