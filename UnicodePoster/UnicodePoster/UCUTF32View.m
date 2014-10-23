//
//  UCUTF32View.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 23/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCUTF32View.h"
#import "NSColor+UC.h"
#import "UCBitsView.h"

@implementation UCUTF32View

CGFloat UTF32_TITLE_HEIGHT = 55;

+ (instancetype)utf32View {
    UCUTF32View *utf32View = [[UCUTF32View alloc] initWithFrame:NSMakeRect(0, 0, 800, 520)];
    return utf32View;
}

+ (CGFloat)titleHeight {
    return UTF32_TITLE_HEIGHT;
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
    
    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, [UCUTF32View titleHeight] - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, [UCUTF32View titleHeight], self.frame.size.width - 1, self.frame.size.height - [UCUTF32View titleHeight]);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];
    
    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSString *title = @"UTF-32";
    NSString *subTitle1 = @"Universal Character Set Transformation Format 32-bit.";
    NSString *subTitle2 = @"The UTF-32 form of a character is a direct representation of its codepoint.";
    NSString *subTitle3 = @"The main disadvantage of UTF-32 is that it is space inefficient, using four bytes per character.";
    
    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 26) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 39) withAttributes:fixedSizeFontAttributes];
    
#warning TODO: illustrate endianness
#warning TODO: explain BOM
    
    CGFloat TOP_MARGIN = 48;
    CGFloat LEFT_MARGIN = 3;
    CGFloat SPACER = 10;
    CGFloat PLANE_SQUARE_WIDTH = 64+1;
    
    // draw complete address space
    
    NSPoint asP0 = NSMakePoint(LEFT_MARGIN, TOP_MARGIN + SPACER);
    NSPoint asP2 = NSMakePoint(asP0.x + PLANE_SQUARE_WIDTH, asP0.y + 449);
    
    NSBezierPath *asPath = [NSBezierPath bezierPathWithRect:NSMakeRect(asP0.x, asP0.y, asP2.x - asP0.x, asP2.y - asP0.y)];
    [[NSColor uc_planeColor_3_4] setFill];
    [asPath fill];
    [[NSColor blackColor] setStroke];
    [asPath stroke];
    
    // draw graduations
    
    [@"0x0000" drawAtPoint:NSMakePoint(asP0.x + 3, asP0.y - 1) withAttributes:fixedSizeFontAttributes];
    [@"0x10FFFF" drawAtPoint:NSMakePoint(asP2.x - 49, asP2.y - 14) withAttributes:fixedSizeFontAttributes];

    //
    
    CGFloat lineY = 0;
    CGFloat LINE_X = 120;
    
    [@"example: U+266A \u266A \"EIGHTH NOTE\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
//    [@"excluding range U+D800 to U+DFFF, ie UTF-16 surrogates" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
//    [@"example: U+266A \u266A \"EIGHTH NOTE\"" drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + (lineY+=13)) withAttributes:fixedSizeFontAttributes];
    
    lineY += 15;
    UCBitsView *bitsViewNote = [UCBitsView bitsViewWithBits:@"00100110 01101010" comment:@"0x266A"];
    bitsViewNote.rightColor = [[NSColor uc_planeColor_3_4] uc_lightColor]; // lightCyanColor;
    [bitsViewNote setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNote];
    lineY += 15;
    
    UCBitsView *bitsViewNoteUTF32_1 = [UCBitsView bitsViewWithBits:@"00000000" comment:@"0x00"];
    bitsViewNoteUTF32_1.strikeBoxes = YES;
    bitsViewNoteUTF32_1.leftColor = [NSColor lightGrayColor];
    bitsViewNoteUTF32_1.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bitsViewNoteUTF32_1.rightColorStartIndex = 0;
    [bitsViewNoteUTF32_1 setFrameOrigin:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNoteUTF32_1];
    
    UCBitsView *bitsViewNoteUTF32_2 = [UCBitsView bitsViewWithBits:@"00000000" comment:@"0x00"];
    bitsViewNoteUTF32_2.strikeBoxes = YES;
    bitsViewNoteUTF32_2.leftColor = [NSColor lightGrayColor];
    bitsViewNoteUTF32_2.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bitsViewNoteUTF32_2.rightColorStartIndex = 0;
    [bitsViewNoteUTF32_2 setFrameOrigin:NSMakePoint(LINE_X + 175, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNoteUTF32_2];
    
    UCBitsView *bitsViewNoteUTF32_3 = [UCBitsView bitsViewWithBits:@"00100110" comment:@"0x26"];
    bitsViewNoteUTF32_3.strikeBoxes = YES;
    bitsViewNoteUTF32_3.leftColor = [NSColor lightGrayColor];
    bitsViewNoteUTF32_3.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bitsViewNoteUTF32_3.rightColorStartIndex = 0;
    [bitsViewNoteUTF32_3 setFrameOrigin:NSMakePoint(LINE_X + 175*2, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNoteUTF32_3];
    
    UCBitsView *bitsViewNoteUTF32_4 = [UCBitsView bitsViewWithBits:@"01101010" comment:@"0x6A"];
    bitsViewNoteUTF32_4.strikeBoxes = YES;
    bitsViewNoteUTF32_4.leftColor = [NSColor lightGrayColor];
    bitsViewNoteUTF32_4.rightColor = [NSColor uc_planeColor_3_4];//[NSColor cyanColor];
    bitsViewNoteUTF32_4.rightColorStartIndex = 0;
    [bitsViewNoteUTF32_4 setFrameOrigin:NSMakePoint(LINE_X + 175*3, TOP_MARGIN + SPACER + lineY)];
    [self addSubview:bitsViewNoteUTF32_4];
    
    lineY += 13 * 2;
    NSArray *lines = @[@"Byte Order Mark (BOM) and Endianness",
                       @"Big endian        optional BOM '00 00 FE FF'    'A' is encoded as:    '00 00 00 41'",
                       @"Little endian    mandatory BOM 'FF FE 00 00'    'A' is encoded as:    '41 00 00 00'"];
    for(NSString *line in lines) {
        lineY += 13;
        [line drawAtPoint:NSMakePoint(LINE_X, TOP_MARGIN + SPACER + lineY) withAttributes:fixedSizeFontAttributes];
    }
    
    
    CGContextRestoreGState(context);
}

@end
