//
//  UCCaseConversionView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 23/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCCaseMappingView.h"

@implementation UCCaseMappingView

CGFloat CASE_CONVERSION_TITLE_HEIGHT = 55;

// totally crappy method, to be rewritten property
- (void)drawLineFromPoint:(NSPoint)p0 toY:(CGFloat)p1Y rotateByDegrees:(CGFloat)rotateByDegrees arrowAtStart:(BOOL)arrowAtStart arrowAtEnd:(BOOL)arrowAtEnd {
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:p0];
    [path lineToPoint:NSMakePoint(p0.x, p1Y)];
    
    if(arrowAtStart) {
        NSPoint pLeft = NSMakePoint(p0.x - 5, p0.y + 5);
        NSPoint pRight = NSMakePoint(p0.x + 5, p0.y + 5);
        NSPoint pEndLeft = NSMakePoint(p0.x, p0.y);
        NSPoint pEndRight = NSMakePoint(p0.x, p0.y);

        [path moveToPoint:p0];
        
        [path moveToPoint:pLeft];
        [path lineToPoint:pEndLeft];
        
        [path moveToPoint:pRight];
        [path lineToPoint:pEndRight];
    }
    
    if(arrowAtEnd) {
        NSPoint pLeft = NSMakePoint(p0.x - 5, p1Y - 5);
        NSPoint pRight = NSMakePoint(p0.x + 5, p1Y - 5);
        NSPoint pEndLeft = NSMakePoint(p0.x, p1Y);
        NSPoint pEndRight = NSMakePoint(p0.x, p1Y);
        
        [path moveToPoint:NSMakePoint(p0.x, p1Y)];
        
        [path moveToPoint:pLeft];
        [path lineToPoint:pEndLeft];
        
        [path moveToPoint:pRight];
        [path lineToPoint:pEndRight];
    }
    
    NSAffineTransform *t0 = [NSAffineTransform transform];
    [t0 translateXBy:p0.x * -1
                 yBy:p0.y * -1];
    
    NSAffineTransform *t1 = [NSAffineTransform transform];
    [t1 rotateByDegrees:rotateByDegrees];
    
    NSAffineTransform *t2 = [NSAffineTransform transform];
    [t2 translateXBy:p0.x
                 yBy:p0.y];
    
    
    [path transformUsingAffineTransform:t0];
    [path transformUsingAffineTransform:t1];
    [path transformUsingAffineTransform:t2];
    
    [path stroke];
}

- (void)drawStringInTimes24:(NSString *)s atPoint:(NSPoint)p context:(CGContextRef)context {

    NSDictionary *times24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Times New Roman" size:24] };

    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, true);
    
    [s drawAtPoint:NSMakePoint(p.x, p.y - 10) withAttributes:times24FontAttributes];
    
    CGContextSetAllowsAntialiasing(context, false);
    
    CGContextRestoreGState(context);
}

- (void)drawCodepoint1:(uint32_t)c1 codePoint2:(uint32_t)c2 atPoint:(NSPoint)p drawCircle:(BOOL)drawCircle context:(CGContextRef)context {
    
    uint32_t prefixCodepoint = drawCircle ? 0x000025CC : 0x0;

    NSString *s = nil;
    
    if(c2 == 0x0) {
        uint32_t values[2] = {prefixCodepoint, c1};
        s = [[NSString alloc] initWithBytes:values length:(sizeof(uint32_t)*2) encoding:NSUTF32LittleEndianStringEncoding];
    } else {
        uint32_t values[3] = {prefixCodepoint, c1, c2};
        s = [[NSString alloc] initWithBytes:values length:(sizeof(uint32_t)*3) encoding:NSUTF32LittleEndianStringEncoding];
    }
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSDictionary *times24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Times New Roman" size:24] };
    
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, true);
    
    [s drawAtPoint:NSMakePoint(p.x - 4, p.y - 10) withAttributes:times24FontAttributes];
    
    CGContextSetAllowsAntialiasing(context, false);
    
    NSString *codePointString = nil;
    
    if(c2 == 0x0) {
        codePointString = [NSString stringWithFormat:@"U+%04X", c1];
        [codePointString drawAtPoint:NSMakePoint(p.x - 15, p.y + 15) withAttributes:fixedSizeFontAttributes];
    } else {
        codePointString = [NSString stringWithFormat:@"U+%04X U+%04x", c1, c2];
        [codePointString drawAtPoint:NSMakePoint(p.x - 30, p.y + 15) withAttributes:fixedSizeFontAttributes];
    }
    
    CGContextRestoreGState(context);
}

- (void)drawCodepoint:(uint32_t)c1 atPoint:(NSPoint)p drawCircle:(BOOL)drawCircle context:(CGContextRef)context {
    [self drawCodepoint1:c1 codePoint2:0x0 atPoint:p drawCircle:drawCircle context:context];
}

+ (instancetype)caseMappingView {
    UCCaseMappingView *cmView = [[UCCaseMappingView alloc] initWithFrame:NSMakeRect(0, 0, 650, 700)];
    return cmView;
}

+ (CGFloat)titleHeight {
    return CASE_CONVERSION_TITLE_HEIGHT;
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
    
    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, [UCCaseMappingView titleHeight] - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, [UCCaseMappingView titleHeight], self.frame.size.width - 1, self.frame.size.height - [UCCaseMappingView titleHeight]);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];
    
    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSString *title = @"Case Mapping";
    NSString *subTitle1 = @"";
    NSString *subTitle2 = @"Process whereby strings are converted to uppercase or lowercase, possibly for display to the user. Due to";
    NSString *subTitle3 = @"the rich nature of human languages, case mapping is much more subtle that is may seems at first sight.";
    
    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 26) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 39) withAttributes:fixedSizeFontAttributes];
    
    /**/
    
    CGFloat TOP_MARGIN = 48;
    CGFloat LEFT_MARGIN = 3;
    CGFloat SPACER = 10;

    CGFloat lineY = 0;
    
    [@"The UnicodeData.txt file includes all of the one-to-one case mappings." drawAtPoint:NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    [@"The SpecialCasing.txt file was added as a hint for several one-to-many mappings." drawAtPoint:NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"The CLDR contains context, language and locale-specific mappings." drawAtPoint:NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];

    lineY += 13;
    
    /**/
    
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, TOP_MARGIN + SPACER + lineY + 10, self.frame.size.width, 0)] stroke];
    
    [@"Change in length and asymetrical case-pairings" drawAtPoint:NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    
    lineY += 13 * 2;

    [self drawCodepoint:0x00001E9E atPoint:NSMakePoint(160, lineY + 13*5) drawCircle:NO context:context];
    
    [self drawCodepoint1:0x00000053 codePoint2:0x00000053 atPoint:NSMakePoint(290, lineY + 13*5) drawCircle:NO context:context];
    
    [self drawCodepoint:0x000000DF atPoint:NSMakePoint(160, lineY + 13*10) drawCircle:NO context:context];

    [self drawCodepoint1:0x00000073 codePoint2:0x00000073 atPoint:NSMakePoint(290, lineY + 13*10) drawCircle:NO context:context];
    
    [@"LATIN CAPITAL" drawAtPoint:NSMakePoint(LEFT_MARGIN + 40, TOP_MARGIN + SPACER + (lineY)) withAttributes:fixedSizeFontAttributes];
    [@"LETTER SHARP S" drawAtPoint:NSMakePoint(LEFT_MARGIN + 40, TOP_MARGIN + SPACER + (lineY+13)) withAttributes:fixedSizeFontAttributes];

    [@"LATIN SMALL" drawAtPoint:NSMakePoint(LEFT_MARGIN + 40, TOP_MARGIN + SPACER + (lineY+13*5)) withAttributes:fixedSizeFontAttributes];
    [@"LETTER SHARP S" drawAtPoint:NSMakePoint(LEFT_MARGIN + 40, TOP_MARGIN + SPACER + (lineY+13*6)) withAttributes:fixedSizeFontAttributes];

    [self drawLineFromPoint:NSMakePoint(160, lineY + 13*8)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:NO
                 arrowAtEnd:YES];

    [self drawLineFromPoint:NSMakePoint(230, lineY + 13*7)
                    toY:lineY + 13*10
            rotateByDegrees:45
               arrowAtStart:YES
                 arrowAtEnd:NO];

    [self drawLineFromPoint:NSMakePoint(290 + 10, lineY + 13*8)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:YES
                 arrowAtEnd:YES];

    lineY += 13 * 8;

    /**/
    
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, TOP_MARGIN + SPACER + lineY + 10, self.frame.size.width, 0)] stroke];
    
    [@"Context-dependent Case Mappings" drawAtPoint:NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];

    lineY += 13*2;

    [self drawCodepoint:0x000003A3 atPoint:NSMakePoint(225, lineY + 13*5) drawCircle:NO context:context];

    [self drawCodepoint:0x000003C3 atPoint:NSMakePoint(160, lineY + 13*10) drawCircle:NO context:context];

    [self drawCodepoint:0x000003C2 atPoint:NSMakePoint(290, lineY + 13*10) drawCircle:NO context:context];

    [@"GREEK CAPITAL" drawAtPoint:NSMakePoint(LEFT_MARGIN + 120, TOP_MARGIN + SPACER + (lineY)) withAttributes:fixedSizeFontAttributes];
    [@"LETTER SIGMA" drawAtPoint:NSMakePoint(LEFT_MARGIN + 120, TOP_MARGIN + SPACER + (lineY+13)) withAttributes:fixedSizeFontAttributes];

    [@"GREEK SMALL LETTER" drawAtPoint:NSMakePoint(330, TOP_MARGIN + SPACER + (lineY + 13*5)) withAttributes:fixedSizeFontAttributes];
    [@"FINAL SIGMA" drawAtPoint:NSMakePoint(330, TOP_MARGIN + SPACER + (lineY + 13*6)) withAttributes:fixedSizeFontAttributes];

    [@"GREEK SMALL LETTER" drawAtPoint:NSMakePoint(LEFT_MARGIN + 30, TOP_MARGIN + SPACER + (lineY + 13*5)) withAttributes:fixedSizeFontAttributes];
    [@"SIGMA" drawAtPoint:NSMakePoint(LEFT_MARGIN + 30, TOP_MARGIN + SPACER + (lineY + 13*6)) withAttributes:fixedSizeFontAttributes];

    NSString *greekStringUppercase = @"\u038C\u03A3\u039F\u03A3";
    [self drawStringInTimes24:greekStringUppercase atPoint:NSMakePoint(500, lineY+(13*5)) context:context];
    [self drawStringInTimes24:[greekStringUppercase lowercaseString] atPoint:NSMakePoint(500, lineY+(13*10)) context:context];

    [self drawLineFromPoint:NSMakePoint(225 - 10, lineY + 13*8)
                    toY:lineY + 13*11
            rotateByDegrees:45
               arrowAtStart:NO
                 arrowAtEnd:YES];

    [self drawLineFromPoint:NSMakePoint(225 + 10, lineY + 13*8)
                    toY:lineY + 13*11
            rotateByDegrees:-45
               arrowAtStart:NO
                 arrowAtEnd:YES];

    [self drawLineFromPoint:NSMakePoint(530, lineY + 13*7)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:NO
                 arrowAtEnd:YES];

    lineY += 13 * 8;

    /**/
    
    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, TOP_MARGIN + SPACER + lineY + 10, self.frame.size.width, 0)] stroke];

    [@"Locale-dependent Case Mappings" drawAtPoint:NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER + (lineY+=12)) withAttributes:fixedSizeFontAttributes];
    lineY += 13;

    [@"Posix Locale" drawAtPoint:NSMakePoint(LEFT_MARGIN + 10, TOP_MARGIN + SPACER + (lineY+=12)) withAttributes:fixedSizeFontAttributes];
    lineY += 13*2;
    
    [self drawCodepoint:0x00000049 atPoint:NSMakePoint(LEFT_MARGIN + 50, lineY + 13*5) drawCircle:NO context:context];
    
    [self drawCodepoint:0x00000130 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120, lineY + 13*5) drawCircle:NO context:context];

    [self drawCodepoint:0x00000049 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2, lineY + 13*5) drawCircle:NO context:context];
    [self drawCodepoint:0x00000307 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2 + 40, lineY + 13*5) drawCircle:YES context:context];

//    [self drawCodepoint:0x00000130 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 150*3, lineY + 13*5) drawCircle:NO context:context];
//    [self drawCodepoint:0x00000307 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 150*3 + 40, lineY + 13*5) drawCircle:YES context:context];

    //
    
    [self drawCodepoint:0x131 atPoint:NSMakePoint(LEFT_MARGIN + 50, lineY + 13*10) drawCircle:NO context:context];

    [self drawCodepoint:0x69 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120, lineY + 13*10) drawCircle:NO context:context];

    [self drawCodepoint:0x69 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2, lineY + 13*10) drawCircle:NO context:context];
    [self drawCodepoint:0x307 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2 + 40, lineY + 13*10) drawCircle:YES context:context];

    //
    
    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50, lineY + 13*8)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:YES
                 arrowAtEnd:NO];

    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50 + 50, lineY + 13*7)
                    toY:lineY + 13*10
            rotateByDegrees:-45
               arrowAtStart:YES
                 arrowAtEnd:YES];

    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50 + 120 + 50, lineY + 13*7)
                    toY:lineY + 13*10
            rotateByDegrees:-45
               arrowAtStart:NO
                 arrowAtEnd:YES];

    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2 + 20, lineY + 13*8)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:YES
                 arrowAtEnd:YES];

    lineY += 13 * 8;

    //
    
    [@"Turkish Locale" drawAtPoint:NSMakePoint(LEFT_MARGIN + 10, TOP_MARGIN + SPACER + (lineY+=12)) withAttributes:fixedSizeFontAttributes];
    lineY += 13*2;
    
    [self drawCodepoint:0x00000049 atPoint:NSMakePoint(LEFT_MARGIN + 50, lineY + 13*5) drawCircle:NO context:context];
    
    [self drawCodepoint:0x00000130 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120, lineY + 13*5) drawCircle:NO context:context];
    
    [self drawCodepoint:0x00000049 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2, lineY + 13*5) drawCircle:NO context:context];
    [self drawCodepoint:0x00000307 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2 + 40, lineY + 13*5) drawCircle:YES context:context];
    
    [self drawCodepoint:0x00000130 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*3, lineY + 13*5) drawCircle:NO context:context];
    [self drawCodepoint:0x00000307 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*3 + 40, lineY + 13*5) drawCircle:YES context:context];
    
    //
    
    [self drawCodepoint:0x131 atPoint:NSMakePoint(LEFT_MARGIN + 50, lineY + 13*10) drawCircle:NO context:context];
    
    [self drawCodepoint:0x69 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120, lineY + 13*10) drawCircle:NO context:context];
    
    [self drawCodepoint:0x69 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2, lineY + 13*10) drawCircle:NO context:context];
    [self drawCodepoint:0x307 atPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2 + 40, lineY + 13*10) drawCircle:YES context:context];

    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50, lineY + 13*8)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:YES
                 arrowAtEnd:YES];
    
    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50 + 120, lineY + 13*8)
                    toY:lineY + 13*9
            rotateByDegrees:0
               arrowAtStart:YES
                 arrowAtEnd:YES];
    
    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*2 - 50, lineY + 13*7)
                    toY:lineY + 13*10
            rotateByDegrees:45
               arrowAtStart:NO
                 arrowAtEnd:YES];
    
    [self drawLineFromPoint:NSMakePoint(LEFT_MARGIN + 50 + 120*3 - 50 + 20, lineY + 13*7)
                    toY:lineY + 13*10
            rotateByDegrees:45
               arrowAtStart:YES
                 arrowAtEnd:YES];
    
    CGContextRestoreGState(context);
}

@end

