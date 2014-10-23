//
//  UCUTF16View.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 13/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCUTF16View.h"
#import "UCBitsView.h"
#import "NSColor+UC.h"

@implementation UCUTF16View

CGFloat UTF16_TITLE_HEIGHT = 55;

+ (instancetype)utf16View {
    UCUTF16View *utf16View = [[UCUTF16View alloc] initWithFrame:NSMakeRect(0, 0, 800, 520)];
    return utf16View;
}

+ (CGFloat)titleHeight {
    return UTF16_TITLE_HEIGHT;
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
    
    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, [UCBitsView titleHeight] - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, [UCBitsView titleHeight], self.frame.size.width - 1, self.frame.size.height - [UCBitsView titleHeight]);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];
    
    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSString *title = @"UTF-16  ";
    NSString *subTitle1 = @"Universal Character Set Transformation Format 16-bit.";
    NSString *subTitle2 = @"UTF-16 uses a single 16 bits code unit to encode the most common 63K characters,";
    NSString *subTitle3 = @"and a pair of 16-bit code units, called surrogates, to encode the 1M less commonly Unicode characters.";
    
    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 26) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 39) withAttributes:fixedSizeFontAttributes];
    
    CGFloat TOP_MARGIN = 48;
    CGFloat LEFT_MARGIN = 3;
    CGFloat SPACER = 10;
    CGFloat PLANE_SQUARE_WIDTH = 64+1;
    CGFloat PLANE_SQUARE_HEIGHT = 256+1;
    
    // draw BMP
    
    NSPoint bmpP0 = NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER);
    NSPoint bmpP2 = NSMakePoint(bmpP0.x + PLANE_SQUARE_WIDTH, bmpP0.y + PLANE_SQUARE_HEIGHT);
    
    NSBezierPath *bmpPath = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP0.x, bmpP0.y, bmpP2.x - bmpP0.x, bmpP2.y - bmpP0.y)];
    [bmpPath stroke];
    
    // draw other planes start
    
    [[NSColor uc_planeColor_4_4] setFill];
    
    CGFloat teethSize = PLANE_SQUARE_WIDTH / 16.0;
    
    NSPoint opStartP0 = NSMakePoint(bmpP0.x, bmpP2.y + SPACER);
    NSPoint opStartP2 = NSMakePoint(bmpP2.x, opStartP0.y + PLANE_SQUARE_HEIGHT / 3.);
    
    NSBezierPath *otherPlanesStartPath = [NSBezierPath bezierPath];
    [otherPlanesStartPath moveToPoint:opStartP0];
    [otherPlanesStartPath lineToPoint:NSMakePoint(opStartP0.x, opStartP2.y)];
    
    for(NSUInteger i = 0; i <= 16; i++) {
        BOOL isDown = (i%2 == 0);
        NSPoint p = NSMakePoint(opStartP0.x + teethSize * i, opStartP2.y + (isDown ? teethSize : teethSize * -1));
        [otherPlanesStartPath lineToPoint:p];
    }
    
    [otherPlanesStartPath lineToPoint:NSMakePoint(opStartP2.x, opStartP0.y)];
    [otherPlanesStartPath closePath];
    
    [otherPlanesStartPath fill];
    [otherPlanesStartPath stroke];
    
    // draw other planes stop
    
    NSPoint opStopP0 = NSMakePoint(opStartP0.x, opStartP2.y + SPACER);
    NSPoint opStopP2 = NSMakePoint(bmpP2.x, opStopP0.y + PLANE_SQUARE_HEIGHT / 3.);
    
    NSBezierPath *otherPlanesStopPath = [NSBezierPath bezierPath];
    [otherPlanesStopPath moveToPoint:opStopP0];
    NSPoint cp = otherPlanesStopPath.currentPoint;
    [otherPlanesStopPath moveToPoint:NSMakePoint(cp.x, cp.y + 8)];
    
    for(NSUInteger i = 0; i <= 16; i++) {
        BOOL isDown = (i%2 == 0);
        NSPoint p = NSMakePoint(opStopP0.x + teethSize * i, opStopP0.y + (isDown ? teethSize : teethSize * -1));
        [otherPlanesStopPath lineToPoint:p];
    }
    
    [otherPlanesStopPath lineToPoint:NSMakePoint(opStopP2.x, opStopP2.y)];
    [otherPlanesStopPath lineToPoint:NSMakePoint(opStopP0.x, opStopP2.y)];
    [otherPlanesStopPath closePath];
    
    [otherPlanesStopPath fill];
    [otherPlanesStopPath stroke];
    
    // draw zones
    
    [[NSColor uc_planeColor_3_4] setFill];
    NSBezierPath *utf16_bmp_path = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP0.x+1, bmpP0.y, PLANE_SQUARE_WIDTH - 1, 0xFF+1)];
    [utf16_bmp_path fill];
    
    [[NSColor whiteColor] setFill];
    NSBezierPath *utf16_bmp_surrogates_path = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP0.x+1, bmpP0.y - 1 + 0xD8, PLANE_SQUARE_WIDTH - 1, 0xE0-0xD8)];
    [utf16_bmp_surrogates_path fill];
    
    // draw graduations
    
    [@"0x0000" drawAtPoint:NSMakePoint(bmpP0.x + 3, bmpP0.y - 1) withAttributes:fixedSizeFontAttributes];
    [@"0xD800" drawAtPoint:NSMakePoint(bmpP0.x + 3, bmpP0.y - 4 + 0xD8) withAttributes:fixedSizeFontAttributes];
    [@"0xE000" drawAtPoint:NSMakePoint(bmpP0.x + 3, bmpP0.y - 2 + 0xE0) withAttributes:fixedSizeFontAttributes];
    [@"0xFFFF" drawAtPoint:NSMakePoint(bmpP2.x - 37, bmpP2.y - 14) withAttributes:fixedSizeFontAttributes];
    
    [@"0x010000" drawAtPoint:NSMakePoint(opStartP0.x + 3, opStartP0.y - 1) withAttributes:fixedSizeFontAttributes];
    [@"0x10FFFF" drawAtPoint:NSMakePoint(opStartP2.x - 49, opStopP2.y - 14) withAttributes:fixedSizeFontAttributes];
    
    /*
     // draw zones handles
     
     NSBezierPath *pBMP1 = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4, bmpP0.y + 1, 0, 0xD8-2)];
     [pBMP1 stroke];
     
     NSBezierPath *pBMP2 = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4, bmpP0.y + 0xE0, 0, 0xFF-0xE0 + 1)];
     //    NSPoint pBMP2Points[] = {
     //        NSMakePoint(bmpP2.x + 4, bmpP0.y + 0x70),
     //        NSMakePoint(bmpP2.x + 4 + 25, bmpP0.y + 0x70),
     ////        NSMakePoint(bmpP2.x + 4 + 25, bmpP0.y + 0x70),
     ////        NSMakePoint(bmpP2.x + 4 + 45, bmpP0.y + 101),
     //    };
     //    [pBMP2 appendBezierPathWithPoints:pBMP2Points count:2];
     [pBMP2 stroke];
     
     NSBezierPath *pBMP12 = [NSBezierPath bezierPath];
     NSPoint pBMP12Points[] = {
     NSMakePoint(bmpP2.x + 4, bmpP0.y + 0x70),
     NSMakePoint(bmpP2.x + 4 + 15, bmpP0.y + 0x70),
     NSMakePoint(bmpP2.x + 4 + 15, bmpP0.y + 0x70 + 128),
     NSMakePoint(bmpP2.x + 4, bmpP0.y + 0x70 + 128)
     };
     [pBMP12 appendBezierPathWithPoints:pBMP12Points count:4];
     [pBMP12 stroke];
     
     NSBezierPath *pBMP12Right = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4 + 15, (bmpP0.y + 0x70 + 128/2), 30, 0)];
     [pBMP12Right stroke];
     
     
     
     //    NSBezierPath *p3 = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4, bmpP0.y + 10, 0, 0xFF - 9)];
     //    NSPoint p3Points[] = {
     //        NSMakePoint(bmpP2.x + 4, bmpP0.y + 128),
     //        NSMakePoint(bmpP2.x + 4 + 15, bmpP0.y + 128),
     //        NSMakePoint(bmpP2.x + 4 + 15, bmpP0.y + 180),
     //        NSMakePoint(bmpP2.x + 4 + 45, bmpP0.y + 180),
     //    };
     //    [p3 appendBezierPathWithPoints:p3Points count:4];
     //    [p3 stroke];
     
     NSBezierPath *p4 = [NSBezierPath bezierPathWithRect:NSMakeRect(opStartP2.x + 4, opStartP0.y + 1, 0, 180)];
     NSPoint p4Points[] = {
     NSMakePoint(bmpP2.x + 4, opStartP0.y + 45),
     NSMakePoint(bmpP2.x + 4 + 25, opStartP0.y + 45),
     NSMakePoint(bmpP2.x + 4 + 25, opStartP0.y - 8),
     NSMakePoint(bmpP2.x + 4 + 45, opStartP0.y - 8),
     };
     [p4 appendBezierPathWithPoints:p4Points count:4];
     [p4 stroke];
     
     */
    
    // colors
    
//    NSColor *lightRedColor = [NSColor colorWithCalibratedRed:1.0 green:0.7 blue:0.7 alpha:1.0];
//    NSColor *lightYellowColor = [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.7 alpha:1.0];
//    NSColor *lightCyanColor = [NSColor colorWithCalibratedRed:0.7 green:1.0 blue:1.0 alpha:1.0];
//    NSColor *lightMagentaColor = [NSColor colorWithCalibratedRed:1.0 green:0.7 blue:1.0 alpha:1.0];
    
    // BMP codepoints
    
    CGFloat lineY = 0;
    CGFloat LINE_X = 120;
    
    [@"BMP codepoints" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"excluding range U+D800 to U+DFFF, ie UTF-16 surrogates" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"example: U+266A \u266A \"EIGHTH NOTE\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    
    lineY += 15;
    UCBitsView *bitsViewNote = [UCBitsView bitsViewWithBits:@"00100110 01101010" comment:@"0x266A"];
    bitsViewNote.rightColor = [[NSColor uc_planeColor_3_4] uc_lightColor]; // lightCyanColor;
    [bitsViewNote setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNote];
    lineY += 15;
    
    UCBitsView *bitsViewNoteUTF16_1 = [UCBitsView bitsViewWithBits:@"00100110" comment:@"0x26"];
    bitsViewNoteUTF16_1.strikeBoxes = YES;
    bitsViewNoteUTF16_1.leftColor = [NSColor lightGrayColor];
    bitsViewNoteUTF16_1.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bitsViewNoteUTF16_1.rightColorStartIndex = 0;
    [bitsViewNoteUTF16_1 setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNoteUTF16_1];
    
    UCBitsView *bitsViewNoteUTF16_2 = [UCBitsView bitsViewWithBits:@"01101010" comment:@"0x6A"];
    bitsViewNoteUTF16_2.strikeBoxes = YES;
    bitsViewNoteUTF16_2.leftColor = [NSColor lightGrayColor];
    bitsViewNoteUTF16_2.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bitsViewNoteUTF16_2.rightColorStartIndex = 0;
    [bitsViewNoteUTF16_2 setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNoteUTF16_2];
    
    lineY += SPACER;
    
    lineY += 13 * 5;
    NSArray *lines = @[@"Byte Order Mark (BOM) and Endianness",
                       @"Big endian        optional BOM 'FE FF'    'A' is encoded as:    '00 41'    (by default)",
                       @"Little endian    mandatory BOM 'FF FE'    'A' is encoded as:    '41 00'"];
    for(NSString *line in lines) {
        lineY += 13;
        [line drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    }
    
    // non-BMP codepoints
    
    lineY = 252;
    
    [@"non-BMP codepoints" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"from U+10000 to U+10FFFF" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"example: U+1F441 \U0001F441 \"EYE\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    
    lineY += 15;
    [@"Substract 0x10000. The highest possible codepoint U+10FFFF will be transformed into 0xFFFFF, ie 20 bits max." drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    lineY += 15;
    UCBitsView *bitsViewSurrogates = [UCBitsView bitsViewWithBits:@"0000 11110100 01000001" comment:@"0x0F441"];
    bitsViewSurrogates.rightColor = [[NSColor uc_planeColor_4_4] uc_lightColor];//lightMagentaColor;
    [bitsViewSurrogates setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewSurrogates];
    lineY += 15;
    [@"Split the 20 bits into two groups of 10 bits and fill the surrogates 0xD800 and 0xDC00 (Big Endian)." drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    lineY += 15;
    
    {
        UCBitsView *bv = [UCBitsView bitsViewWithBits:@"11011000" comment:@"0xD8"];
        bv.strikeBoxes = YES;
        bv.leftColor = [NSColor lightGrayColor];
        bv.rightColor = [NSColor whiteColor];
        bv.rightColorStartIndex = 6;
        [bv setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
        [self addSubview:bv];
    }
    
    {
        UCBitsView *bv = [UCBitsView bitsViewWithBits:@"00000000" comment:@"0x00"];
        bv.strikeBoxes = YES;
        bv.leftColor = [NSColor lightGrayColor];
        bv.rightColor = [NSColor whiteColor];
        bv.rightColorStartIndex = 0;
        [bv setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
        [self addSubview:bv];
    }
    
    {
        UCBitsView *bv = [UCBitsView bitsViewWithBits:@"11011100" comment:@"0xDC"];
        bv.strikeBoxes = YES;
        bv.leftColor = [NSColor lightGrayColor];
        bv.rightColor = [NSColor whiteColor];
        bv.rightColorStartIndex = 6;
        [bv setFrameOrigin:NSMakePoint(LINE_X + 175*2, TOP_MARGIN + SPACER + lineY)];
        [self addSubview:bv];
    }
    
    {
        UCBitsView *bv = [UCBitsView bitsViewWithBits:@"00000000" comment:@"0x00"];
        bv.strikeBoxes = YES;
        bv.leftColor = [NSColor lightGrayColor];
        bv.rightColor = [NSColor whiteColor];
        bv.rightColorStartIndex = 0;
        [bv setFrameOrigin:NSMakePoint(LINE_X + 175*3, TOP_MARGIN + SPACER + lineY)];
        [self addSubview:bv];
    }
    
    lineY += 15;
    
    UCBitsView *bitsViewSurrogatesBE11 = [UCBitsView bitsViewWithBits:@"11011000" comment:@"0xD8"];
    bitsViewSurrogatesBE11.strikeBoxes = YES;
    bitsViewSurrogatesBE11.leftColor = [NSColor lightGrayColor];
    bitsViewSurrogatesBE11.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bitsViewSurrogatesBE11.rightColorStartIndex = 6;
    [bitsViewSurrogatesBE11 setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewSurrogatesBE11];
    
    UCBitsView *bitsViewSurrogatesBE12 = [UCBitsView bitsViewWithBits:@"00111101" comment:@"0x3D"];
    bitsViewSurrogatesBE12.strikeBoxes = YES;
    bitsViewSurrogatesBE12.leftColor = [NSColor lightGrayColor];
    bitsViewSurrogatesBE12.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bitsViewSurrogatesBE12.rightColorStartIndex = 0;
    [bitsViewSurrogatesBE12 setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewSurrogatesBE12];
    
    UCBitsView *bitsViewSurrogatesBE21 = [UCBitsView bitsViewWithBits:@"11011100" comment:@"0xDC"];
    bitsViewSurrogatesBE21.strikeBoxes = YES;
    bitsViewSurrogatesBE21.leftColor = [NSColor lightGrayColor];
    bitsViewSurrogatesBE21.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bitsViewSurrogatesBE21.rightColorStartIndex = 6;
    [bitsViewSurrogatesBE21 setFrameOrigin:NSMakePoint(LINE_X + 175*2, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewSurrogatesBE21];
    
    UCBitsView *bitsViewSurrogatesBE22 = [UCBitsView bitsViewWithBits:@"01000001" comment:@"0x41"];
    bitsViewSurrogatesBE22.strikeBoxes = YES;
    bitsViewSurrogatesBE22.leftColor = [NSColor lightGrayColor];
    bitsViewSurrogatesBE22.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bitsViewSurrogatesBE22.rightColorStartIndex = 0;
    [bitsViewSurrogatesBE22 setFrameOrigin:NSMakePoint(LINE_X + 175*3, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewSurrogatesBE22];
    
    /**/
    
    lineY += 13*2;
    lines = @[@"Illegal sequences include unpaired surrogates, such as:",
              @"- [0xD800-0xDBFF] not followed by [0xDC00-0xDFFF]",
              @"- [0xDC00-0xDFFF] not preceded by [0xD800-0xDBFF]"];
    for(NSString *line in lines) {
        lineY += 13;
        [line drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    }
    
    /**/
    
    CGContextRestoreGState(context);
}

@end
