//
//  UCNormalizationView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 13/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCNormalizationView.h"

NSUInteger NORMALIZATION_VIEW_TITLE_HEIGHT = 94;
NSUInteger NORMALIZATION_VIEW_LINE_HEIGHT = 18;

#warning TODO: add decomposing NFC
#warning TODO: add maximum expansion

@implementation UCNormalizationView

+ (instancetype)normalizationView {
    UCNormalizationView *nv = [[self alloc] initWithFrame:NSMakeRect(0, 0, 630, 350)];
    return nv;
}

- (void)drawDownArrowStartingAtPoint:(NSPoint)p height:(CGFloat)height {
    NSPoint pDown = NSMakePoint(p.x, p.y + height);
    NSPoint pLeft = NSMakePoint(p.x-2, pDown.y-5);
    NSPoint pRight = NSMakePoint(p.x+3, pDown.y-5);
    NSPoint pDownLeft = NSMakePoint(p.x+1, p.y + height);
    NSPoint pDownRight = NSMakePoint(p.x, p.y + height);
    
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:p];
    [path lineToPoint:pDown];

    [path moveToPoint:pLeft];
    [path lineToPoint:pDownLeft];

    [path moveToPoint:pRight];
    [path lineToPoint:pDownRight];
    
    [path stroke];
}

- (void)drawCodepoint:(uint32_t)c atPoint:(NSPoint)p drawCircle:(BOOL)drawCircle context:(CGContextRef)context {
    
    uint32_t prefixCodepoint = drawCircle ? 0x000025CC : 0x0;
    
    uint32_t values[2] = {prefixCodepoint, c};
    NSString *s = [[NSString alloc] initWithBytes:values length:(sizeof(uint32_t)*2) encoding:NSUTF32LittleEndianStringEncoding];
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSDictionary *times24FontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Times New Roman" size:24] };
    
    CGContextSaveGState(context);

    CGContextSetAllowsAntialiasing(context, true);
    
    [s drawAtPoint:NSMakePoint(p.x - 4, p.y - 10) withAttributes:times24FontAttributes];

    CGContextSetAllowsAntialiasing(context, false);

    NSString *codePointString = [NSString stringWithFormat:@"U+%04X", c];
    [codePointString drawAtPoint:NSMakePoint(p.x - 15, p.y + 15) withAttributes:fixedSizeFontAttributes];

    CGContextRestoreGState(context);
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
    
    /**/
    
    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, NORMALIZATION_VIEW_TITLE_HEIGHT - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, NORMALIZATION_VIEW_TITLE_HEIGHT, self.frame.size.width - 1, self.frame.size.height - NORMALIZATION_VIEW_TITLE_HEIGHT);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];

    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    //NSDictionary *systemFontAttributes = @{ NSFontAttributeName : [NSFont systemFontOfSize:14.0] };
    
    NSString *title = @"Normalization";
    NSString *subTitle1 = @"";
    NSString *subTitle2 = @"Unicode Normalization Forms are formally defined normalizations of Unicode strings which make it is";
    NSString *subTitle3 = @"possible to determine whether any two Unicode strings are equivalent to each other.";
    NSString *subTitle4 = @"";
    NSString *subTitle5 = @"Strings are generally normalized into NFC representation, so that the binary representation of";
    NSString *subTitle6 = @"canonical-equivalent strings can be compared.";

    NSArray *lines = @[title, subTitle1, subTitle2, subTitle3, subTitle4, subTitle5, subTitle6];

    CGFloat y = 0;
    
    for(NSString *line in lines) {
        [line drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
        y += 13;
    }

    y = NORMALIZATION_VIEW_TITLE_HEIGHT;
    
    /**/
    
    [@"Canonical Equivalence" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += 13*2;
    [@"Two code point sequences with:" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += 13;
    [@"  - same appearance" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += 13;
    [@"  - same meaning" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += (13 + 13 + 13);
    
    [self drawCodepoint:0x212B atPoint:NSMakePoint(50, y) drawCircle:NO context:context];
    [@"and" drawAtPoint:NSMakePoint(100, y-5) withAttributes:fixedSizeFontAttributes];
    [self drawCodepoint:0x0041 atPoint:NSMakePoint(50 + 100, y) drawCircle:NO context:context];
    [self drawCodepoint:0x030A atPoint:NSMakePoint(50 + 150, y) drawCircle:YES context:context];

    [[NSBezierPath bezierPathWithRect:NSMakeRect(0, 220, 230, 0)] stroke];

    y += 13 * 3;
    
    [@"Compatibility equivalence" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += 13*2;
    [@"Two code point sequences with:" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += 13;
    [@"  - possibly distinct appearances" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += 13;
    [@"  - the same meaning in some contexts" drawAtPoint:NSMakePoint(3, y) withAttributes:fixedSizeFontAttributes];
    y += (13 + 13 + 13);
    
    [self drawCodepoint:0xFB01 atPoint:NSMakePoint(50, y) drawCircle:NO context:context];
    [@"and" drawAtPoint:NSMakePoint(100, y-5) withAttributes:fixedSizeFontAttributes];
    [self drawCodepoint:0x0066 atPoint:NSMakePoint(50 + 100, y) drawCircle:NO context:context];
    [self drawCodepoint:0x0069 atPoint:NSMakePoint(50 + 150, y) drawCircle:NO context:context];
    
    /**/

    [[NSBezierPath bezierPathWithRect:NSMakeRect(230, NORMALIZATION_VIEW_TITLE_HEIGHT, 0, self.frame.size.height - NORMALIZATION_VIEW_TITLE_HEIGHT)] stroke];

    /**/
    
    CGFloat x = 250;

    y = NORMALIZATION_VIEW_TITLE_HEIGHT;

    [@"Example with Unicode string:" drawAtPoint:NSMakePoint(x+105, y) withAttributes:fixedSizeFontAttributes];
    y += 13*3;
    [self drawCodepoint:0x00E9 atPoint:NSMakePoint(x+157, y-5) drawCircle:NO context:context];
    [self drawCodepoint:0x2460 atPoint:NSMakePoint(x+207, y-5) drawCircle:NO context:context];

    [[NSBezierPath bezierPathWithRect:NSMakeRect(x + 135, 160, 100, 0)] stroke];
    
    y += (13*4);

    [[NSBezierPath bezierPathWithRect:NSMakeRect(x+87, y+1, 83, 13*2+1)] stroke];
    [[NSBezierPath bezierPathWithRect:NSMakeRect(x+197, y+1, 83, 13*2+1)] stroke];
    
    [@"    canonical" drawAtPoint:NSMakePoint(x+90, y) withAttributes:fixedSizeFontAttributes];
    [@"compatibility" drawAtPoint:NSMakePoint(x+200, y) withAttributes:fixedSizeFontAttributes];
    y += 13;
    [@"decomposition" drawAtPoint:NSMakePoint(x+90, y) withAttributes:fixedSizeFontAttributes];
    [@"decomposition" drawAtPoint:NSMakePoint(x+200, y) withAttributes:fixedSizeFontAttributes];
    y += 13*3;
    
    [self drawCodepoint:0x0065 atPoint:NSMakePoint(x+3, y) drawCircle:NO context:context];
    [self drawCodepoint:0x0301 atPoint:NSMakePoint(x+53, y) drawCircle:YES context:context];
    [self drawCodepoint:0x2460 atPoint:NSMakePoint(x+103, y) drawCircle:NO context:context];
    [@"NFD" drawAtPoint:NSMakePoint(x+150, y) withAttributes:fixedSizeFontAttributes];

    [@"NFKD" drawAtPoint:NSMakePoint(x+200, y) withAttributes:fixedSizeFontAttributes];
    [self drawCodepoint:0x0065 atPoint:NSMakePoint(x+250, y) drawCircle:NO context:context];
    [self drawCodepoint:0x0301 atPoint:NSMakePoint(x+300, y) drawCircle:YES context:context];
    [self drawCodepoint:0x0031 atPoint:NSMakePoint(x+350, y) drawCircle:NO context:context];
    y += (13*3);

    [[NSBezierPath bezierPathWithRect:NSMakeRect(x+117, y+1, 130, 13+1)] stroke];

    [@"canonical composition" drawAtPoint:NSMakePoint(x+120, y) withAttributes:fixedSizeFontAttributes];
    y += 13*3;

    [self drawCodepoint:0x00E9 atPoint:NSMakePoint(x+53, y) drawCircle:NO context:context];
    [self drawCodepoint:0x2460 atPoint:NSMakePoint(x+103, y) drawCircle:NO context:context];
    [@"NFC" drawAtPoint:NSMakePoint(x+150, y) withAttributes:fixedSizeFontAttributes];
    
    [@"NFKC" drawAtPoint:NSMakePoint(x+200, y) withAttributes:fixedSizeFontAttributes];
    [self drawCodepoint:0x00E9 atPoint:NSMakePoint(x+250, y) drawCircle:NO context:context];
    [self drawCodepoint:0x0031 atPoint:NSMakePoint(x+300, y) drawCircle:NO context:context];

    /**/
    
    CGFloat arrowX1 = x + 160;
    CGFloat arrowX2 = x + 160 + 55;
    
    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX1, 164) height:20];
    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX2, 164) height:20];

    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX1, 215) height:20];
    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX2, 215) height:20];

    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX1, 254) height:20];
    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX2, 254) height:20];

    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX1, 295) height:20];
    [self drawDownArrowStartingAtPoint:NSMakePoint(arrowX2, 295) height:20];

    /**/
    
    CGContextSetAllowsAntialiasing(context, true);
    
    CGContextRestoreGState(context);

#warning TODO: maximum sizing factor
#warning TODO: NFC example with more code points
    
}

@end
