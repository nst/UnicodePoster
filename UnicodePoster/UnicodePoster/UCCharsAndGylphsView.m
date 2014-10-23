//
//  UCSampleView.m
//  UnicodeSampleView
//
//  Created by Nicolas Seriot on 30/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCCharsAndGylphsView.h"

@implementation UCCharsAndGylphsView

+ (instancetype)charsAndGylphsView {
    UCCharsAndGylphsView *cagView = [[self alloc] initWithFrame:NSMakeRect(0, 0, 540, 125)];
    return cagView;
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
    
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);

    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    
    NSDictionary *times24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Times New Roman" size:24] };
    NSDictionary *timesItalic24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Times New Roman Italic" size:24] };
    NSDictionary *timesBold24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Times New Roman Bold" size:24] };
    
    NSDictionary *helvetica24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Helvetica" size:24] };
    NSDictionary *helveticaItalic24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Helvetica Oblique" size:24] };
    NSDictionary *helveticaBold24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Helvetica Bold" size:24] };
    
    CGFloat COL_1_X = 250;
    CGFloat COL_2_X = 340;
    
    [@"Characters" drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [@"Glyphs" drawAtPoint:NSMakePoint(COL_1_X + 3, 0) withAttributes:fixedSizeFontAttributes];
    [@"Fonts" drawAtPoint:NSMakePoint(COL_2_X + 3, 0) withAttributes:fixedSizeFontAttributes];

    // example 1: A

    [@"U+0041 \"LATIN CAPITAL LETTER A\"" drawAtPoint:NSMakePoint(3, 16) withAttributes:fixedSizeFontAttributes];
    
    CGContextSetAllowsAntialiasing(context, true);
    [@"A" drawAtPoint:NSMakePoint(COL_1_X + 3, 16) withAttributes:times24FontAttributes];
    [@"A" drawAtPoint:NSMakePoint(COL_1_X + 23, 16) withAttributes:timesItalic24FontAttributes];
    [@"A" drawAtPoint:NSMakePoint(COL_1_X + 43, 16) withAttributes:timesBold24FontAttributes];

    [@"A" drawAtPoint:NSMakePoint(COL_1_X + 3, 36) withAttributes:helvetica24FontAttributes];
    [@"A" drawAtPoint:NSMakePoint(COL_1_X + 23, 36) withAttributes:helveticaItalic24FontAttributes];
    [@"A" drawAtPoint:NSMakePoint(COL_1_X + 43, 36) withAttributes:helveticaBold24FontAttributes];
    CGContextSetAllowsAntialiasing(context, false);

    [@"Times New Roman 24, Italic, Bold" drawAtPoint:NSMakePoint(COL_2_X + 3, 16) withAttributes:fixedSizeFontAttributes];
    [@"Helvetica 24, Oblique, Bold" drawAtPoint:NSMakePoint(COL_2_X + 3, 36) withAttributes:fixedSizeFontAttributes];

    // example 2: e with accent
    
    CGFloat ROW_2_Y_OFFSET = 66;
    
    [@"U+00E9 \"LATIN SMALL LETTER E WITH ACUTE\"" drawAtPoint:NSMakePoint(3, ROW_2_Y_OFFSET) withAttributes:fixedSizeFontAttributes];
//    [@"U+0065 \"LATIN SMALL LETTER E\"" drawAtPoint:NSMakePoint(10, ROW_2_Y_OFFSET + 13*2) withAttributes:fixedSizeFontAttributes];
//    [@"U+0301 \"COMBINING ACUTE ACCENT\"" drawAtPoint:NSMakePoint(10, ROW_2_Y_OFFSET + 13*3) withAttributes:fixedSizeFontAttributes];
    
    CGContextSetAllowsAntialiasing(context, true);
    [@"e + \u25CC\u0301 = \u00E9" drawAtPoint:NSMakePoint(COL_1_X + 3, ROW_2_Y_OFFSET + 3) withAttributes:times24FontAttributes];
    CGContextSetAllowsAntialiasing(context, false);

    [@"Times New Roman 24" drawAtPoint:NSMakePoint(COL_2_X + 3, ROW_2_Y_OFFSET) withAttributes:fixedSizeFontAttributes];

    // example 3: f + l
    
    CGFloat ROW_3_Y_OFFSET = 95;
    
    [@"U+0066 \"LATIN SMALL LETTER F\"" drawAtPoint:NSMakePoint(3, ROW_3_Y_OFFSET) withAttributes:fixedSizeFontAttributes];
    [@"U+006C \"LATIN SMALL LETTER L\"" drawAtPoint:NSMakePoint(3, ROW_3_Y_OFFSET + 13) withAttributes:fixedSizeFontAttributes];

//    [@"U+FB02 \"LATIN SMALL LIGATURE FL\"" drawAtPoint:NSMakePoint(10, ROW_3_Y_OFFSET + 13) withAttributes:fixedSizeFontAttributes];
    
    CGContextSetAllowsAntialiasing(context, true);
    [@"\uFB02" drawAtPoint:NSMakePoint(COL_1_X + 3, ROW_3_Y_OFFSET) withAttributes:times24FontAttributes];
    CGContextSetAllowsAntialiasing(context, false);

    [@"Times New Roman 24" drawAtPoint:NSMakePoint(COL_2_X + 3, ROW_3_Y_OFFSET) withAttributes:fixedSizeFontAttributes];

    /**/
    
    NSBezierPath *path0 = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 1, self.frame.size.width-1, self.frame.size.height-1)];
    [path0 stroke];

    NSBezierPath *path1 = [NSBezierPath bezierPathWithRect:NSMakeRect(0, 0, self.frame.size.width, 16)];
    [path1 stroke];

    NSBezierPath *path2 = [NSBezierPath bezierPathWithRect:NSMakeRect(COL_1_X, 0, COL_2_X - COL_1_X, self.frame.size.height)];
    [path2 stroke];

    NSBezierPath *path3 = [NSBezierPath bezierPathWithRect:NSMakeRect(0, ROW_2_Y_OFFSET, self.frame.size.width, ROW_3_Y_OFFSET - ROW_2_Y_OFFSET)];
    [path3 stroke];

    
    CGContextRestoreGState(context);
}

@end
