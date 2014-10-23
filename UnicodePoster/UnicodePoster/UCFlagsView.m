//
//  UCFlagsView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 12/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCFlagsView.h"

@interface UCFlagsView ()
@property (nonatomic, strong) NSArray *flagsCodepoints;
@end

NSUInteger FLAGS_VIEW_TITLE_HEIGHT = 94;
NSUInteger FLAGS_VIEW_LINE_HEIGHT = 18;

@implementation UCFlagsView

+ (NSArray *)flagsCodepointsFromFileAtPath:(NSString *)path {
    
    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    NSArray *lines = [s componentsSeparatedByString:@"\n"];

    NSMutableArray *flagsCodepoints = [NSMutableArray array];

    for(NSString *line in lines) {
        if([line length] == 0) continue;
        
        NSString *codepoint1String = [line substringWithRange:NSMakeRange(0, 7)];
        NSString *codepoint2String = [line substringWithRange:NSMakeRange(10, 7)];
        
        unsigned long long firstInt, secondInt;
        
        NSScanner *scanner1 = [NSScanner scannerWithString:codepoint1String];
        [scanner1 scanHexLongLong:&firstInt];
        
        NSScanner *scanner2 = [NSScanner scannerWithString:codepoint2String];
        [scanner2 scanHexLongLong:&secondInt];
        
        NSArray *a = @[ @(firstInt), @(secondInt) ];
        
        [flagsCodepoints addObject:a];
    }
    
    return flagsCodepoints;
}

+ (instancetype)flagsView {
    NSArray *flagsCodepoints = [self flagsCodepointsFromFileAtPath:@"/Users/nst/Projects/UnicodePoster/UnicodePoster/Flags.txt"];
    
    UCFlagsView *flagsView = [[self alloc] initWithFrame:NSMakeRect(0, 0, 235, FLAGS_VIEW_TITLE_HEIGHT + [flagsCodepoints count] * FLAGS_VIEW_LINE_HEIGHT + 1)];
    flagsView.flagsCodepoints = flagsCodepoints;
    return flagsView;
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

    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, FLAGS_VIEW_TITLE_HEIGHT - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];

    NSRect tableRect = NSMakeRect(0, FLAGS_VIEW_TITLE_HEIGHT, self.frame.size.width - 1, self.frame.size.height - FLAGS_VIEW_TITLE_HEIGHT);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];

    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSDictionary *systemFontAttributes = @{ NSFontAttributeName : [NSFont systemFontOfSize:14.0] };
    
    NSString *title = @"Country Flags";
    NSString *subTitle1 = @"";
    NSString *subTitle2 = @"Country flags are combinations of two";
    NSString *subTitle3 = @"letters from the Enclosed Alphanumeric";
    NSString *subTitle4 = @"Supplement block, according to their ";
    NSString *subTitle5 = @"ISO code. Apple currently implements";
    NSString *subTitle6 = @"only ten of them.";
    
    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 26) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 39) withAttributes:fixedSizeFontAttributes];
    [subTitle4 drawAtPoint:NSMakePoint(3, 52) withAttributes:fixedSizeFontAttributes];
    [subTitle5 drawAtPoint:NSMakePoint(3, 65) withAttributes:fixedSizeFontAttributes];
    [subTitle6 drawAtPoint:NSMakePoint(3, 78) withAttributes:fixedSizeFontAttributes];
    
    [_flagsCodepoints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *cps = (NSArray *)obj;
        
        uint32_t c0 = [cps[0] unsignedIntValue];
        uint32_t c1 = [cps[1] unsignedIntValue];
        
        NSString *s0 = [[NSString alloc] initWithBytes:&c0 length:sizeof(uint32_t) encoding:NSUTF32LittleEndianStringEncoding];
        NSString *s1 = [[NSString alloc] initWithBytes:&c1 length:sizeof(uint32_t) encoding:NSUTF32LittleEndianStringEncoding];
        
        NSString *cp0 = [[NSString stringWithFormat:@"U+%05x", c0] uppercaseString];
        NSString *cp1 = [[NSString stringWithFormat:@"U+%05x", c1] uppercaseString];
        
        NSString *key = [NSString stringWithFormat:@"%@ + %@", cp0, cp1];
        NSString *value = [NSString stringWithFormat:@"%@ %@ %@%@", s0, s1, s0, s1];

        //NSLog(@"-- %@ %@", key, value);
        
        CGFloat x = 3;
        CGFloat y = FLAGS_VIEW_TITLE_HEIGHT + idx * FLAGS_VIEW_LINE_HEIGHT;
        
        [key drawAtPoint:NSMakePoint(x, y) withAttributes:fixedSizeFontAttributes];

        CGContextSetAllowsAntialiasing(context, true);
        [value drawAtPoint:NSMakePoint(x + 120, y-1) withAttributes:systemFontAttributes];
        CGContextSetAllowsAntialiasing(context, false);
    }];
    
    CGContextRestoreGState(context);
}

@end
