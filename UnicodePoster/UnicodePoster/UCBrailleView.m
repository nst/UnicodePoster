//
//  UCBrailleView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 20/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCBrailleView.h"

NSUInteger BRAILLE_VIEW_TITLE_HEIGHT = 55;

// http://www.johndcook.com/blog/2014/01/15/braille-unicode-and-binary/

@implementation UCBrailleView

+ (instancetype)brailleView {
    UCBrailleView *brailleView = [[self alloc] initWithFrame:NSMakeRect(0, 0, 500, 320)];
    return brailleView;
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

- (void)drawBrailleCodepoint:(uint16_t)c atPoint:(NSPoint)p drawIndices:(BOOL)drawIndices context:(CGContextRef)context {
    
    NSString *s = [[NSString alloc] initWithBytes:&c length:sizeof(uint16_t) encoding:NSUTF16LittleEndianStringEncoding];
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSDictionary *brailleFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Apple Braille Outline 8 Dot" size:96.0] };
    
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, true);
    [s drawAtPoint:NSMakePoint(p.x - 4, p.y - 10) withAttributes:brailleFontAttributes];
    
    if(drawIndices) {
        CGContextSetAllowsAntialiasing(context, false);
        
        [@"1" drawAtPoint:NSMakePoint(p.x, p.y) withAttributes:fixedSizeFontAttributes];
        [@"2" drawAtPoint:NSMakePoint(p.x, p.y + 23) withAttributes:fixedSizeFontAttributes];
        [@"3" drawAtPoint:NSMakePoint(p.x, p.y + 23*2) withAttributes:fixedSizeFontAttributes];
        [@"7" drawAtPoint:NSMakePoint(p.x, p.y + 23*3) withAttributes:fixedSizeFontAttributes];
        
        [@"4" drawAtPoint:NSMakePoint(p.x + 52, p.y) withAttributes:fixedSizeFontAttributes];
        [@"5" drawAtPoint:NSMakePoint(p.x + 52, p.y + 23) withAttributes:fixedSizeFontAttributes];
        [@"6" drawAtPoint:NSMakePoint(p.x + 52, p.y + 23*2) withAttributes:fixedSizeFontAttributes];
        [@"8" drawAtPoint:NSMakePoint(p.x + 52, p.y + 23*3) withAttributes:fixedSizeFontAttributes];
    
        NSString *cpString = [[NSString stringWithFormat:@"U+%04x", c] uppercaseString];
        
        [cpString drawAtPoint:NSMakePoint(p.x + 12, p.y + 23*4) withAttributes:fixedSizeFontAttributes];
        
        CGContextSetAllowsAntialiasing(context, true);
    }
    
    CGContextRestoreGState(context);
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    CGContextSaveGState(context);

    CGContextSetAllowsAntialiasing(context, false);
    
    [[NSColor whiteColor] setFill];
    NSRectFill(dirtyRect);
    
    /**/
    
    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, BRAILLE_VIEW_TITLE_HEIGHT - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, BRAILLE_VIEW_TITLE_HEIGHT, self.frame.size.width - 1, self.frame.size.height - BRAILLE_VIEW_TITLE_HEIGHT);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];
    
    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    
    // http://en.wikipedia.org/wiki/Braille_ASCII
    
    NSString *title = @"Braille";
    NSString *subTitle1 = @"There are many different types of Braille.";
    NSString *subTitle2 = @"Braille ASCII is encoded with 6 dots set up in two columns.";
    NSString *subTitle3 = @"Unicode Braille uses 8 dots. The two most significant dots are stored at bottom.";
    
    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 26) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 39) withAttributes:fixedSizeFontAttributes];
    
    [self drawBrailleCodepoint:0x2800 atPoint:NSMakePoint(80, 70) drawIndices:YES context:context];
    [self drawBrailleCodepoint:0x2895 atPoint:NSMakePoint(160, 70) drawIndices:YES context:context];
    [self drawBrailleCodepoint:0x281D atPoint:NSMakePoint(160, 190) drawIndices:YES context:context];
    
    CGContextSetAllowsAntialiasing(context, false);

    NSString *s_1_0 = @"10010101 = 0x95";
    NSString *s_1_1 = @"U+2800 + 0x95 = U+2895";
    NSString *s_1_2 = @"Not part of Braille ASCII.";
    [s_1_0 drawAtPoint:NSMakePoint(230, 70) withAttributes:fixedSizeFontAttributes];
    [s_1_1 drawAtPoint:NSMakePoint(230, 83) withAttributes:fixedSizeFontAttributes];
    [s_1_2 drawAtPoint:NSMakePoint(230, 96) withAttributes:fixedSizeFontAttributes];

    NSString *mappingHeader = @"ASCII Braille Mapping:";
    NSString *mapping00 = @"0x00 | A1B'K2L@CIF/MSP";
    NSString *mapping10 = @"0x10 |\"E3H9O6R^DJG>NTQ";
    NSString *mapping20 = @"0x20 |,*5<-U8V.%[$+X!&";
    NSString *mapping30 = @"0x30 |;:4\\0Z7(_?W]#Y)=";
    [mappingHeader drawAtPoint:NSMakePoint(3, 190) withAttributes:fixedSizeFontAttributes];
    [mapping00 drawAtPoint:NSMakePoint(3, 203) withAttributes:fixedSizeFontAttributes];
    [mapping10 drawAtPoint:NSMakePoint(3, 216) withAttributes:fixedSizeFontAttributes];
    [mapping20 drawAtPoint:NSMakePoint(3, 229) withAttributes:fixedSizeFontAttributes];
    [mapping30 drawAtPoint:NSMakePoint(3, 242) withAttributes:fixedSizeFontAttributes];

    NSString *s_2_0 = @"00011101 = 0x1D";
    NSString *s_2_1 = @"U+2800 + 0x1D = U+281D";
    NSString *s_2_2 = @"Character at index 0x1D is N.";
    NSString *s_2_3 = @"This is Braille ASCII code for letter N.";
    [s_2_0 drawAtPoint:NSMakePoint(230, 190) withAttributes:fixedSizeFontAttributes];
    [s_2_1 drawAtPoint:NSMakePoint(230, 203) withAttributes:fixedSizeFontAttributes];
    [s_2_2 drawAtPoint:NSMakePoint(230, 216) withAttributes:fixedSizeFontAttributes];
    [s_2_3 drawAtPoint:NSMakePoint(230, 229) withAttributes:fixedSizeFontAttributes];
    
    CGContextRestoreGState(context);

}

@end
