//
//  UCUTF8View.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 13/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCUTF8View.h"
#import "UCBitsView.h"
#import "NSColor+UC.h"

@implementation UCUTF8View

+ (instancetype)utf8View {
    UCUTF8View *utf8View = [[UCUTF8View alloc] initWithFrame:NSMakeRect(0, 0, 800, 520)];
    return utf8View;
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
    NSString *title = @"UTF-8";
    NSString *subTitle1 = @"Universal Character Set Transformation Format 8-bit.";
    NSString *subTitle2 = @"Variable-length character encoding. Dominant character encoding on the web. Backward compatible with ASCII.";
    NSString *subTitle3 = @"Allows self-synchronization. Encodes each of the 1,112,064 valid Unicode code points using 1 to 4 bytes.";
    
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

    [/*[NSColor magentaColor]*/[NSColor uc_planeColor_4_4] setFill];

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

    [/*[NSColor cyanColor]*/[NSColor uc_planeColor_3_4] setFill];
    NSBezierPath *utf8_3_path = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP0.x+1, bmpP0.y, PLANE_SQUARE_WIDTH - 1, 0xFF+1)];
    [utf8_3_path fill];

    [[NSColor uc_planeColor_2_4]/*[NSColor yellowColor]*/ setFill];
    NSBezierPath *utf8_2_path = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP0.x+1, bmpP0.y, PLANE_SQUARE_WIDTH - 1, 0x08)];
    [utf8_2_path fill];

    [[NSColor uc_planeColor_1_4]/*[NSColor redColor]*/ setFill];
    NSBezierPath *utf8_1_path = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP0.x+1, bmpP0.y, PLANE_SQUARE_WIDTH / 2., 1)];
    [utf8_1_path fill];
    
    // draw graduations
    
    [@"0x0800" drawAtPoint:NSMakePoint(bmpP0.x + 3, bmpP0.y + 7) withAttributes:fixedSizeFontAttributes];
    [@"0xFFFF" drawAtPoint:NSMakePoint(bmpP2.x - 37, bmpP2.y - 14) withAttributes:fixedSizeFontAttributes];

    [@"0x010000" drawAtPoint:NSMakePoint(opStartP0.x + 3, opStartP0.y - 1) withAttributes:fixedSizeFontAttributes];
    [@"0x10FFFF" drawAtPoint:NSMakePoint(opStartP2.x - 49, opStopP2.y - 14) withAttributes:fixedSizeFontAttributes];

    // draw zones handles
    
    NSBezierPath *p1 = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4, bmpP0.y + 1, 0, 0)];
    NSPoint p1Points[] = {
        NSMakePoint(bmpP2.x + 4 + 35, bmpP0.y + 1),
        NSMakePoint(bmpP2.x + 4 + 35, bmpP0.y + 1 + 21),
        NSMakePoint(bmpP2.x + 4 + 45, bmpP0.y + 1 + 21),
    };
    [p1 appendBezierPathWithPoints:p1Points count:3];
    [p1 stroke];

    NSBezierPath *p2 = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4, bmpP0.y + 3, 0, 5)];
    NSPoint p2Points[] = {
        NSMakePoint(bmpP2.x + 4, bmpP0.y + 6),
        NSMakePoint(bmpP2.x + 4 + 25, bmpP0.y + 6),
        NSMakePoint(bmpP2.x + 4 + 25, bmpP0.y + 101),
        NSMakePoint(bmpP2.x + 4 + 45, bmpP0.y + 101),
    };
    [p2 appendBezierPathWithPoints:p2Points count:4];
    [p2 stroke];

    NSBezierPath *p3 = [NSBezierPath bezierPathWithRect:NSMakeRect(bmpP2.x + 4, bmpP0.y + 10, 0, 0xFF - 9)];
    NSPoint p3Points[] = {
        NSMakePoint(bmpP2.x + 4, bmpP0.y + 128),
        NSMakePoint(bmpP2.x + 4 + 15, bmpP0.y + 128),
        NSMakePoint(bmpP2.x + 4 + 15, bmpP0.y + 180),
        NSMakePoint(bmpP2.x + 4 + 45, bmpP0.y + 180),
    };
    [p3 appendBezierPathWithPoints:p3Points count:4];
    [p3 stroke];

    NSBezierPath *p4 = [NSBezierPath bezierPathWithRect:NSMakeRect(opStartP2.x + 4, opStartP0.y + 1, 0, 180)];
    NSPoint p4Points[] = {
        NSMakePoint(bmpP2.x + 4, opStartP0.y + 45),
        NSMakePoint(bmpP2.x + 4 + 25, opStartP0.y + 45),
        NSMakePoint(bmpP2.x + 4 + 25, opStartP0.y + 8),
        NSMakePoint(bmpP2.x + 4 + 45, opStartP0.y + 8),
    };
    [p4 appendBezierPathWithPoints:p4Points count:4];
    [p4 stroke];
    
    // draw 1 byte encoding
    
    CGFloat lineY = 0;
    CGFloat LINE_X = 120;
    
    [@"7-bits codepoints" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"from U+0000 to U+007F, ie the \"Basic Latin\" block" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"example: U+0041 A \"LATIN CAPITAL LETTER A\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];

    lineY += 15;
    UCBitsView *bitsViewA = [UCBitsView bitsViewWithBits:@"1000001" comment:@"0x41"];
    bitsViewA.rightColor = [[NSColor uc_planeColor_1_4] uc_lightColor];
    [bitsViewA setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewA];
    lineY += 15;
    
    UCBitsView *bytes1View = [UCBitsView bitsViewWithBits:@"01000001" comment:@"0x41"];
    bytes1View.strikeBoxes = YES;
    bytes1View.leftColor = [NSColor lightGrayColor];
    bytes1View.rightColor = [NSColor uc_planeColor_1_4];//[NSColor redColor];
    bytes1View.rightColorStartIndex = 1;
    [bytes1View setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes1View];
    
    lineY += SPACER;
    
    // draw 2 bytes encoding

    [@"11-bits codepoints" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"from U+0080 to U+07FF, ie blocks \"Latin-1\", \"Cyrillic\", \"Hebrew\", \"Arabic\", ..." drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"example: U+03C6 \u03C6 \"GREEK SMALL LETTER PHI\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];

    lineY += 15;
    UCBitsView *bitsViewPhi = [UCBitsView bitsViewWithBits:@"01111 000110" comment:@"0x03C6"];
    bitsViewPhi.rightColor = [[NSColor uc_planeColor_2_4] uc_lightColor];//lightYellowColor;
    [bitsViewPhi setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewPhi];
    lineY += 15;

    UCBitsView *bytes21View = [UCBitsView bitsViewWithBits:@"11001111" comment:@"0xCF"];
    bytes21View.strikeBoxes = YES;
    bytes21View.leftColor = [NSColor lightGrayColor];
    bytes21View.rightColor = [NSColor uc_planeColor_2_4];//[NSColor yellowColor];
    bytes21View.rightColorStartIndex = 3;
    [bytes21View setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes21View];
    
    UCBitsView *bytes22View = [UCBitsView bitsViewWithBits:@"10000110" comment:@"0x86"];
    bytes22View.strikeBoxes = YES;
    bytes22View.leftColor = [NSColor lightGrayColor];
    bytes22View.rightColor = [NSColor uc_planeColor_2_4];//[NSColor yellowColor];
    bytes22View.rightColorStartIndex = 2;
    [bytes22View setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes22View];

    lineY += SPACER;
    
    // draw 3 bytes encoding
    
    [@"16-bits codepoints" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"from U+0800 to U+FFFF, ie all the BMP from U+0800" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"example: U+266A \u266A \"EIGHTH NOTE\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    
    lineY += 15;
    UCBitsView *bitsViewWatch = [UCBitsView bitsViewWithBits:@"0010 011001 101010" comment:@"0x266A"];
    bitsViewWatch.rightColor = [[NSColor uc_planeColor_3_4] uc_lightColor];//lightCyanColor;
    [bitsViewWatch setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewWatch];
    lineY += 15;

    UCBitsView *bytes31View = [UCBitsView bitsViewWithBits:@"11100010" comment:@"0xE2"];
    bytes31View.strikeBoxes = YES;
    bytes31View.leftColor = [NSColor lightGrayColor];
    bytes31View.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bytes31View.rightColorStartIndex = 4;
    [bytes31View setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes31View];
    
    UCBitsView *bytes32View = [UCBitsView bitsViewWithBits:@"10011001" comment:@"0x99"];
    bytes32View.strikeBoxes = YES;
    bytes32View.leftColor = [NSColor lightGrayColor];
    bytes32View.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bytes32View.rightColorStartIndex = 2;
    [bytes32View setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes32View];

    UCBitsView *bytes33View = [UCBitsView bitsViewWithBits:@"10101010" comment:@"0xAA"];
    bytes33View.strikeBoxes = YES;
    bytes33View.leftColor = [NSColor lightGrayColor];
    bytes33View.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bytes33View.rightColorStartIndex = 2;
    [bytes33View setFrameOrigin:NSMakePoint(LINE_X + 175*2, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes33View];

    lineY += SPACER;

    // draw 4 bytes encoding

    lineY += 15;
    
    [@"21-bits codepoints" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"from U+10000 to U+1FFFFF, ie planes 01 to 17" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    [@"example: U+1F441 \U0001F441 \"EYE\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    
    lineY += 15;
    UCBitsView *bitsViewDesert = [UCBitsView bitsViewWithBits:@"000 011111 010001 000001" comment:@"0x1F441"];
    bitsViewDesert.rightColor = [[NSColor uc_planeColor_4_4] uc_lightColor];//lightMagentaColor;
    [bitsViewDesert setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewDesert];
    lineY += 15;
    
    UCBitsView *bytes41View = [UCBitsView bitsViewWithBits:@"11110000" comment:@"0xF0"];
    bytes41View.strikeBoxes = YES;
    bytes41View.leftColor = [NSColor lightGrayColor];
    bytes41View.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bytes41View.rightColorStartIndex = 5;
    [bytes41View setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes41View];
    
    UCBitsView *bytes42View = [UCBitsView bitsViewWithBits:@"10011111" comment:@"0x9F"];
    bytes42View.strikeBoxes = YES;
    bytes42View.leftColor = [NSColor lightGrayColor];
    bytes42View.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bytes42View.rightColorStartIndex = 2;
    [bytes42View setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes42View];
    
    UCBitsView *bytes43View = [UCBitsView bitsViewWithBits:@"10010001" comment:@"0x91"];
    bytes43View.strikeBoxes = YES;
    bytes43View.leftColor = [NSColor lightGrayColor];
    bytes43View.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bytes43View.rightColorStartIndex = 2;
    [bytes43View setFrameOrigin:NSMakePoint(LINE_X + 175*2, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes43View];

    UCBitsView *bytes44View = [UCBitsView bitsViewWithBits:@"10000001" comment:@"0x81"];
    bytes44View.strikeBoxes = YES;
    bytes44View.leftColor = [NSColor lightGrayColor];
    bytes44View.rightColor = [NSColor uc_planeColor_4_4];//[NSColor magentaColor];
    bytes44View.rightColorStartIndex = 2;
    [bytes44View setFrameOrigin:NSMakePoint(LINE_X + 175*3, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bytes44View];

    /**/
    
    lineY += SPACER;
    lineY += 15;
    
    [@"Optional BOM: 'EF BB BF'" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    lineY += 13*2;
    
    [@"Illegal sequences include:" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    lineY += 13;

    [@"- overlong encoding" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    lineY += 15;
    
    UCBitsView *illegalByte21View = [UCBitsView bitsViewWithBits:@"11000000" comment:@"0xC0"];
    illegalByte21View.strikeBoxes = YES;
    illegalByte21View.leftColor = [NSColor lightGrayColor];
    illegalByte21View.rightColor = [NSColor uc_planeColor_2_4];//[NSColor yellowColor];
    illegalByte21View.rightColorStartIndex = 3;
    [illegalByte21View setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:illegalByte21View];
    
    UCBitsView *illegalByte22View = [UCBitsView bitsViewWithBits:@"01000001" comment:@"0x41"];
    illegalByte22View.strikeBoxes = YES;
    illegalByte22View.leftColor = [NSColor lightGrayColor];
    illegalByte22View.rightColor = [NSColor uc_planeColor_2_4];//[NSColor yellowColor];
    illegalByte22View.rightColorStartIndex = 2;
    [illegalByte22View setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:illegalByte22View];

    lineY += 15;
    [@"- unexpected continuation byte" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    lineY += 15;
    
    UCBitsView *illegalByte11View = [UCBitsView bitsViewWithBits:@"110     " comment:@""];
    illegalByte11View.strikeBoxes = YES;
    illegalByte11View.leftColor = [NSColor lightGrayColor];
    illegalByte11View.rightColor = [NSColor whiteColor];
    illegalByte11View.rightColorStartIndex = 3;
    [illegalByte11View setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:illegalByte11View];
    
    UCBitsView *illegalByte12View = [UCBitsView bitsViewWithBits:@"0       " comment:@""];
    illegalByte12View.strikeBoxes = YES;
    illegalByte12View.leftColor = [NSColor lightGrayColor];
    illegalByte12View.rightColor = [NSColor whiteColor];
    illegalByte12View.rightColorStartIndex = 1;
    [illegalByte12View setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:illegalByte12View];
    
    /**/

    CGContextRestoreGState(context);
}

@end
