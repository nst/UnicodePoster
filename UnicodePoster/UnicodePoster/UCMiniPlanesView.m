//
//  UCMiniPlanesView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 12/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCMiniPlanesView.h"
#import "NSColor+UC.h"

NSUInteger MINI_PLANES_VIEW_ROWS = 17;
NSUInteger MINI_PLANES_VIEW_COLS = 1;
NSUInteger MINI_PLANES_VIEW_HEIGHT = 128;
NSUInteger MINI_PLANES_VIEW_WIDTH = 128;
NSUInteger MINI_PLANES_VIEW_PADDING = 16;
//NSUInteger MINI_PLANES_VIEW_OFFSET_WIDTH = 64;

@implementation UCMiniPlanesView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

+ (instancetype)miniPlanesView {
    CGFloat width = MINI_PLANES_VIEW_PADDING + (MINI_PLANES_VIEW_WIDTH + MINI_PLANES_VIEW_PADDING) * MINI_PLANES_VIEW_COLS;
//    CGFloat height = MINI_PLANES_VIEW_PADDING + (MINI_PLANES_VIEW_HEIGHT + MINI_PLANES_VIEW_PADDING) * MINI_PLANES_VIEW_ROWS;
    return [[self alloc] initWithFrame:NSMakeRect(0, 0, width, 2200)];
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, false);
    
//    [[NSColor whiteColor] setFill];
//    NSRectFill(dirtyRect);
    
    /*
     - plane 00: BMP - Basic Multilingual Plane
     - plane 01: SMP - Supplementary Multilingual Plane
     - plane 02: SIP - Supplementary Ideographic Plane
     - plane 03: unassigned
     - plane 04: unassigned
     - plane 05: unassigned
     - plane 06: unassigned
     - plane 07: unassigned
     - plane 08: unassigned
     - plane 09: unassigned
     - plane 10: unassigned
     - plane 11: unassigned
     - plane 12: unassigned
     - plane 13: unassigned
     - plane 14: SSP - Supplement­ary Special-purpose Plane
     - plane 15: SPUA A - Supplement­ary Private Use Area A
     - plane 16: SPUA B - Supplement­ary Private Use Area B
     */
    
    NSArray *planes = @[ @{@"y":@(12),       @"lines":@[@"Plane 00", @"", @"BMP", @"", @"Basic", @"Multiligual", @"Plane"]},
                         @{@"y":@(12+16*8),  @"lines":@[@"Plane 01", @"", @"SMP", @"", @"Supplementary", @"Multiligual", @"Plane"]},
                         @{@"y":@(12+16*8*2), @"lines":@[@"Plane 02", @"", @"SIP", @"", @"Supplementary", @"Ideographic", @"Plane"]},
                         @{@"y":@(12+16*8*3), @"lines":@[@"Plane 03", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*4), @"lines":@[@"Plane 04", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*5), @"lines":@[@"Plane 05", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*6), @"lines":@[@"Plane 06", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*7), @"lines":@[@"Plane 07", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*8), @"lines":@[@"Plane 08", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*9), @"lines":@[@"Plane 09", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*10), @"lines":@[@"Plane 10", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*11), @"lines":@[@"Plane 11", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*12), @"lines":@[@"Plane 12", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*13), @"lines":@[@"Plane 13", @"", @"unassigned"]},
                         @{@"y":@(12+16*8*14), @"lines":@[@"Plane 14", @"", @"SSP", @"", @"Supplement­ary", @"Special-purpose", @"Plane"]},
                         @{@"y":@(12+16*8*15), @"lines":@[@"Plane 15", @"", @"SPUA A", @"", @"Supplement­ary", @"Private Use Area A"]},
                         @{@"y":@(12+16*8*16), @"lines":@[@"Plane 16", @"", @"SPUA B", @"", @"Supplement­ary", @"Private Use Area B"]} ];

    NSDictionary *fontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };

    NSDictionary *colorForPlaneNumber = @{@(0):[NSColor uc_planeColor_0_light],
                                          @(1):[NSColor uc_planeColor_1_light],
                                          @(2):[NSColor uc_planeColor_2_light],
                                          @(14):[NSColor uc_planeColor_14_light]};
    
    [planes enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL *stop) {

        NSArray *lines = d[@"lines"];
        CGFloat y = [d[@"y"] doubleValue];
        
//        NSUInteger row = idx;//[d[@"row"] unsignedIntegerValue];
        NSUInteger col = 0;//[d[@"col"] unsignedIntegerValue];
        
        CGFloat x = MINI_PLANES_VIEW_PADDING + col * (MINI_PLANES_VIEW_WIDTH + MINI_PLANES_VIEW_PADDING);
        //CGFloat y = MINI_PLANES_VIEW_PADDING + row * (MINI_PLANES_VIEW_HEIGHT + MINI_PLANES_VIEW_PADDING);
        
        NSRect rect = NSMakeRect(x, y, MINI_PLANES_VIEW_WIDTH, MINI_PLANES_VIEW_HEIGHT);
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
        
        NSColor *fillColor = [NSColor colorWithCalibratedRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
        NSColor *specificColor = colorForPlaneNumber[@(idx)];
        
        if(specificColor) fillColor = specificColor;
        
        [fillColor setFill];
        [path fill];
        
        [[NSColor blackColor] set];
        [path stroke];
        
        NSMutableArray *allLines = [lines mutableCopy];
        
        uint32_t planeStart = (uint32_t)idx * 0x10000;
        NSString *planeStartString = [NSString stringWithFormat:@"            0x%06X", planeStart];
        NSString *planeStopString = [NSString stringWithFormat:@"            0x%06X", planeStart + 0xFFFF];

        [allLines insertObject:planeStartString atIndex:0];
        [allLines insertObject:@"" atIndex:1];

        while([allLines count] < 10) {
            [allLines insertObject:@"" atIndex:[allLines count]];
        }
        [allLines insertObject:planeStopString atIndex:[allLines count]];

        [allLines enumerateObjectsUsingBlock:^(id obj, NSUInteger lineIndex, BOOL *stop) {
            NSString *s = (NSString *)obj;
            NSPoint p = NSMakePoint(x + 4, y + (lineIndex * 11));
            [s drawAtPoint:p withAttributes:fontAttributes];
        }];
        
//        
//        NSPoint fromPoint = NSMakePoint(x + 48, y + 102);
//        NSPoint toPoint = NSMakePoint(x + 48, y + 113);
//        [planeStartString drawAtPoint:fromPoint withAttributes:fontAttributes];
//        [planeStopString drawAtPoint:toPoint withAttributes:fontAttributes];

    }];
    
    CGContextRestoreGState(context);
}

@end
