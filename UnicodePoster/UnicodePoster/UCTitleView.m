//
//  UCNormalizationView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 13/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCTitleView.h"

@implementation UCTitleView

+ (instancetype)titleView {
    UCTitleView *titleView = [[self alloc] initWithFrame:NSMakeRect(0, 0, 235, 211)];
    return titleView;
}

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
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, false);
    
    NSRect rect = NSMakeRect(0, 1, self.frame.size.width - 1, self.frame.size.height - 1);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    [[NSColor whiteColor] setFill];
    [path fill];
    [[NSColor blackColor] set];
    [path stroke];
    
    NSString *s = [NSString stringWithContentsOfFile:@"/Users/nst/Projects/UnicodePoster/UnicodePoster/title_text.txt"
                                            encoding:NSUTF8StringEncoding
                                               error:nil];

    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    [s drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextRestoreGState(context);

}

@end
