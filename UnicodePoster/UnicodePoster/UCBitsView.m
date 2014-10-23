//
//  UCBitsView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 10/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCBitsView.h"

CGFloat BITSVIEW_TITLE_HEIGHT = 55;

@implementation UCBitsView

+ (instancetype)bitsViewWithBits:(NSString *)bits comment:(NSString *)comment {
    UCBitsView *bytesView = [[UCBitsView alloc] initWithFrame:NSMakeRect(0, 0, [bits length]*[self bitBoxWidth] + 1 + [comment length] * 10, [self bitBoxHeight])];
    bytesView.bits = bits;
    bytesView.comment = comment;
    return bytesView;
}

+ (CGFloat)titleHeight {
    return BITSVIEW_TITLE_HEIGHT;
}

+ (CGFloat)bitBoxWidth {
    return 14;
}

+ (CGFloat)bitBoxHeight {
    return 14;
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
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    
    CGFloat BYTE_BOX_BIT_WIDTH = [[self class] bitBoxWidth];
    CGFloat BYTE_BOX_WIDTH = BYTE_BOX_BIT_WIDTH * [_bits length];
    CGFloat BYTE_BOX_HEIGHT = [[self class] bitBoxHeight];
    
    NSPoint p0 = NSMakePoint(0, 1);
    NSPoint p2 = NSMakePoint(BYTE_BOX_WIDTH, BYTE_BOX_HEIGHT);
    
    NSColor *strikeColor = _strikeBoxes ? [NSColor blackColor] : [NSColor whiteColor];
    
    for(NSUInteger i = 0; i < [_bits length]; i++) {
        [strikeColor setStroke];
        
        NSPoint pUpLeft = NSMakePoint(p0.x + i * BYTE_BOX_BIT_WIDTH, p0.y);
        NSPoint pDownRight = NSMakePoint(p0.x + (i+1) * BYTE_BOX_BIT_WIDTH, p2.y);
        
        NSString *bitString = [_bits substringWithRange:NSMakeRange(i, 1)];
        
        NSColor *bitColor = (i < _rightColorStartIndex) ? _leftColor : _rightColor;
        
        if([bitString isEqualToString:@" "]) {
            bitColor = [NSColor whiteColor];
        }
        
        [bitColor setFill];
        
        NSRect bitRect = NSMakeRect(pUpLeft.x, pUpLeft.y, pDownRight.x - pUpLeft.x, pDownRight.y - pUpLeft.y);
        NSBezierPath *bitPath = [NSBezierPath bezierPathWithRect:bitRect];
        [bitPath fill];
        [bitPath stroke];
        
        [bitString drawAtPoint:NSMakePoint(pUpLeft.x + 5, pUpLeft.y - 1) withAttributes:fixedSizeFontAttributes];
    }
    
    if(_comment) {
        [_comment drawAtPoint:NSMakePoint(p2.x + 10, p0.y - 1) withAttributes:fixedSizeFontAttributes];
    }
    
    /**/
    
    CGContextRestoreGState(context);
}

@end
