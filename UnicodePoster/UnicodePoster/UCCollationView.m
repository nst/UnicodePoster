//
//  UCCollationView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 23/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCCollationView.h"

#warning TODO: see presentation slides

@implementation UCCollationView

CGFloat COLLATION_TITLE_HEIGHT = 81;

+ (instancetype)collationView {
    UCCollationView *collationView = [[UCCollationView alloc] initWithFrame:NSMakeRect(0, 0, 500, 296)];
    return collationView;
}

+ (CGFloat)titleHeight {
    return COLLATION_TITLE_HEIGHT;
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
    
    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, [UCCollationView titleHeight] - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, [UCCollationView titleHeight], self.frame.size.width - 1, self.frame.size.height - [UCCollationView titleHeight]);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];
    
    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    
    NSString *title = @"Collation";
    NSString *subTitle1 = @"";
    NSString *subTitle2 = @"Unicode collation algorithm (UCA) is a customizable method to compare two strings.";
    NSString *subTitle3 = @"UCA uses the Default Unicode Collation Element Table (DUCET) in allkeys.txt";
    NSString *subTitle4 = @"UCA is context, language and usage dependent. Also, it's not stable over versions.";
    NSString *subTitle5 = @"The Unicode Common Locale Data Repository (CLRD) defines tailored DUCET tables.";
    
    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 13*2) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 13*3) withAttributes:fixedSizeFontAttributes];
    [subTitle4 drawAtPoint:NSMakePoint(3, 13*4) withAttributes:fixedSizeFontAttributes];
    [subTitle5 drawAtPoint:NSMakePoint(3, 13*5) withAttributes:fixedSizeFontAttributes];
    
    /**/
    
    CGFloat TABLE_LEFT = 15;
    CGFloat TABLE_TOP = 96;
    CGFloat CELL_HEIGHT = 17;
    CGFloat COL_0_WIDTH = 30;
    
    NSColor *pastelColor1 = [NSColor colorWithCalibratedRed:0.8 green:0.8 blue:0.8 alpha:1.0];

    {
        NSMutableAttributedString *as0 = [[NSMutableAttributedString alloc] initWithString:@"Collation Element Array, found in allkeys.txt" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:@"[.193E.0020.0002] [.190C.0020.0002] [.1925.0020.0002]" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:@"[.193E.0020.0008] [.190C.0020.0002] [.1925.0020.0002]" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as3 = [[NSMutableAttributedString alloc] initWithString:@"[.193E.0020.0002] [.190C.0020.0002] [.0000.0025.0002] [.1925.0020.0002]" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as4 = [[NSMutableAttributedString alloc] initWithString:@"[.1953.0020.0002] [.190C.0020.0002] [.1925.0020.0002]" attributes:fixedSizeFontAttributes];
        
        [as1 addAttribute:NSBackgroundColorAttributeName
                    value:pastelColor1
                    range:NSMakeRange(2, 4)];

        [as1 addAttribute:NSBackgroundColorAttributeName
                    value:pastelColor1
                    range:NSMakeRange(20, 4)];

        [as1 addAttribute:NSBackgroundColorAttributeName
                    value:pastelColor1
                    range:NSMakeRange(38, 4)];
        

        NSArray *rows = @[@[@"",         as0],
                          @[@"cab",      as1],
                          @[@"Cab",      as2],
                          @[@"c\u00e0b", as3],
                          @[@"dab",      as4]];
        
        [rows enumerateObjectsUsingBlock:^(NSArray *a, NSUInteger idx, BOOL *stop) {
            
            NSString *s = a[0];
            NSAttributedString *as = a[1];
            
            [s drawAtPoint:NSMakePoint(TABLE_LEFT+6, TABLE_TOP + CELL_HEIGHT * idx) withAttributes:fixedSizeFontAttributes];
            [as drawAtPoint:NSMakePoint(TABLE_LEFT+6 + COL_0_WIDTH, TABLE_TOP + CELL_HEIGHT * idx)];
            
            [[NSBezierPath bezierPathWithRect:CGRectMake(TABLE_LEFT, TABLE_TOP + CELL_HEIGHT*idx, 470, CELL_HEIGHT)] stroke];
        }];
        
        [[NSBezierPath bezierPathWithRect:CGRectMake(TABLE_LEFT + COL_0_WIDTH, TABLE_TOP, 0, [rows count] * CELL_HEIGHT)] stroke];
    }
    
    /**/
    
    TABLE_TOP = 196;
    
    {
        NSMutableAttributedString *as0 = [[NSMutableAttributedString alloc] initWithString:@"Sort Key, made up from parts of collation elements" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as1 = [[NSMutableAttributedString alloc] initWithString:@"193E 190C 1925 0020 0020 0020 0002 0002 0002" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as2 = [[NSMutableAttributedString alloc] initWithString:@"193E 190C 1925 0020 0020 0020 0008 0002 0002" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as3 = [[NSMutableAttributedString alloc] initWithString:@"193E 190C 1925 0020 0020 0025 0020 0002 0002 0002 0002" attributes:fixedSizeFontAttributes];
        NSMutableAttributedString *as4 = [[NSMutableAttributedString alloc] initWithString:@"1953 190C 1925 0020 0020 0020 0002 0002 0002" attributes:fixedSizeFontAttributes];
        
        NSColor *red = [NSColor colorWithCalibratedRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        NSColor *green = [NSColor colorWithCalibratedRed:0.0 green:0.6 blue:0.0 alpha:1.0];
        NSColor *blue = [NSColor colorWithCalibratedRed:0.0 green:0.0 blue:1.0 alpha:1.0];
        
        [as1 addAttribute:NSBackgroundColorAttributeName
                    value:pastelColor1
                    range:NSMakeRange(0, 4)];

        [as1 addAttribute:NSBackgroundColorAttributeName
                    value:pastelColor1
                    range:NSMakeRange(5, 4)];

        [as1 addAttribute:NSBackgroundColorAttributeName
                    value:pastelColor1
                    range:NSMakeRange(10, 4)];

        //
        
        [as1 addAttribute:NSForegroundColorAttributeName
                    value:blue
                    range:NSMakeRange(5*6, 4)];
        
        [as2 addAttribute:NSForegroundColorAttributeName
                    value:blue
                    range:NSMakeRange(5*6, 4)];
        
        [as2 addAttribute:NSForegroundColorAttributeName
                    value:green
                    range:NSMakeRange(5*5, 4)];
        
        [as3 addAttribute:NSForegroundColorAttributeName
                    value:green
                    range:NSMakeRange(5*5, 4)];
        
        [as3 addAttribute:NSForegroundColorAttributeName
                    value:red
                    range:NSMakeRange(5*0, 4)];
        
        [as4 addAttribute:NSForegroundColorAttributeName
                    value:red
                    range:NSMakeRange(5*0, 4)];
        
        
        //                                           [NSColor redColor], NSForegroundColorAttributeName,
        //                                           [NSFont systemFontOfSize:24], NSFontAttributeName,
        
        NSArray *rows = @[@[@"",         as0],
                          @[@"cab",      as1],
                          @[@"Cab",      as2],
                          @[@"c\u00e0b", as3],
                          @[@"dab",      as4]];
        
        [rows enumerateObjectsUsingBlock:^(NSArray *a, NSUInteger idx, BOOL *stop) {
            
            NSString *s = a[0];
            NSAttributedString *as = a[1];
            
            [s drawAtPoint:NSMakePoint(TABLE_LEFT+6, TABLE_TOP + CELL_HEIGHT * idx) withAttributes:fixedSizeFontAttributes];
            [as drawAtPoint:NSMakePoint(TABLE_LEFT+6 + COL_0_WIDTH, TABLE_TOP + CELL_HEIGHT * idx)];
            
            [[NSBezierPath bezierPathWithRect:CGRectMake(TABLE_LEFT, TABLE_TOP + CELL_HEIGHT*idx, 470, CELL_HEIGHT)] stroke];
        }];
        
        [[NSBezierPath bezierPathWithRect:CGRectMake(TABLE_LEFT + COL_0_WIDTH, TABLE_TOP, 0, [rows count] * CELL_HEIGHT)] stroke];
        
    }
    
    CGContextRestoreGState(context);
}

@end
