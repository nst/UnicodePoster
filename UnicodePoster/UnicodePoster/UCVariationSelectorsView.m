//
//  UCAlternateEmojisView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 12/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCVariationSelectorsView.h"
#import "NSFont+UC.h"

NSUInteger ALT_EMOJIS_VIEW_TITLE_HEIGHT = 55;
NSUInteger ALT_EMOJIS_VIEW_HEADER_HEIGHT = 16;
NSUInteger ALT_EMOJIS_VIEW_ROW_HEIGHT = 19;
NSUInteger ALT_EMOJIS_VIEW_COL_WIDTH = 180;

@interface UCVariationSelectorsView ()
@property (nonatomic, strong) NSArray *codepointsArray;
@property (nonatomic) NSUInteger numberOfRows;
@end

@implementation UCVariationSelectorsView

+ (NSArray *)codepointsArraysAtPath:(NSString *)path {
    
    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *parts = [s componentsSeparatedByString:@"\n\n"];
    
    NSMutableArray *codepointsArrays = [NSMutableArray array];
    
    for(NSString *part in parts) {
        NSArray *lines = [part componentsSeparatedByString:@"\n"];
        
        NSMutableArray *codepoints = [NSMutableArray array];
        
        for(NSString *line in lines) {
            if([line length] == 0) continue;
            NSString *s = [[line componentsSeparatedByString:@"\t"] objectAtIndex:1];
            [codepoints addObject:s];
        }
        
        [codepointsArrays addObject:codepoints];
    }
    
    return codepointsArrays;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    return self;
}

+ (instancetype)alternateEmojisView {
    NSArray *codepointsArray = [self codepointsArraysAtPath:@"/Users/nst/Projects/UnicodePoster/UnicodePoster/BMP_emojis_variants.txt"];
    __block NSUInteger numberOfRows = 0;
    [codepointsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *codepoints = (NSArray *)obj;
        numberOfRows = MAX(numberOfRows, [codepoints count]);
    }];

    CGFloat width = ALT_EMOJIS_VIEW_COL_WIDTH * [codepointsArray count];
    CGFloat height = ALT_EMOJIS_VIEW_TITLE_HEIGHT + ALT_EMOJIS_VIEW_HEADER_HEIGHT + ALT_EMOJIS_VIEW_ROW_HEIGHT * numberOfRows;
    
    UCVariationSelectorsView *aev = [[self alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
    aev.codepointsArray = codepointsArray;
    aev.numberOfRows = numberOfRows;
    return aev;
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
    
    CGFloat y = ALT_EMOJIS_VIEW_TITLE_HEIGHT + ALT_EMOJIS_VIEW_HEADER_HEIGHT;
    CGFloat width = (self.frame.size.width - 1) / [_codepointsArray count];
    CGFloat gridHeight = self.frame.size.height - ALT_EMOJIS_VIEW_TITLE_HEIGHT - ALT_EMOJIS_VIEW_HEADER_HEIGHT - 1;

    NSRect titleRect = NSMakeRect(0, 1, self.frame.size.width - 1, ALT_EMOJIS_VIEW_TITLE_HEIGHT - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
        
    NSRect headerRect = NSMakeRect(0, ALT_EMOJIS_VIEW_TITLE_HEIGHT, self.frame.size.width - 1, ALT_EMOJIS_VIEW_HEADER_HEIGHT - 1);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:headerRect];
    [[NSColor blackColor] set];
    [path stroke];

    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
    NSFont *systemFont = [NSFont systemFontOfSize:14.0];
    NSDictionary *systemFontAttributes = @{ NSFontAttributeName : systemFont };

    /**/
    
    NSString *title = @"Variation Selectors";
    NSString *subTitle1 = @"Variation selectors may modify the font used for a codepoint. Plane 00 (BMP) has 16 VS. from U+FE00 to U+FEFF.";
    NSString *subTitle2 = @"240 more variation selectors are available in plane 14 - Supplementary Special-purpose Plane (SSP).";
    NSString *subTitle3 = @"Here are Apple Emojis in plane 00 (BMP) and their possible variations with VS15 and VS16. Default font: Lucida Grande.";

    [title drawAtPoint:NSMakePoint(3, 0) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, 13) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, 26) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, 39) withAttributes:fixedSizeFontAttributes];
    
    /**/
    
    [_codepointsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *codepoints = (NSArray *)obj;
        
        CGFloat x = (1.0 * idx / [_codepointsArray count]) * (self.frame.size.width - 1);

        NSRect colRect = NSMakeRect(x, ALT_EMOJIS_VIEW_TITLE_HEIGHT, width, self.frame.size.height - ALT_EMOJIS_VIEW_TITLE_HEIGHT);
        NSBezierPath *path = [NSBezierPath bezierPathWithRect:colRect];
        [[NSColor blackColor] set];
        [path stroke];

        [@"U+FE0E" drawAtPoint:NSMakePoint(x+98, headerRect.origin.y) withAttributes:fixedSizeFontAttributes];
        [@"U+FE0F" drawAtPoint:NSMakePoint(x+140, headerRect.origin.y) withAttributes:fixedSizeFontAttributes];

        [codepoints enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSString *s = (NSString *)obj;
        
            unichar c = [s characterAtIndex:0];
            unichar varSel15 = 0xFE0E;
            unichar varSel16 = 0xFE0F;
            
            NSString *hexValueString = [[NSString stringWithFormat:@"U+%04x", c] uppercaseString];
            NSString *withVarSel15 = [NSString stringWithFormat:@"%@%C", s, varSel15];
            NSString *withVarSel16 = [NSString stringWithFormat:@"%@%C", s, varSel16];
            
            //NSLog(@"-- U+%04x %@ %@%C %@%C", c, s, s, varSel15, s, varSel16);
            
            [hexValueString drawAtPoint:NSMakePoint(x+4, y + gridHeight * idx / _numberOfRows + 2) withAttributes:fixedSizeFontAttributes];

            NSString *fontName00 = [systemFont uc_actualFontNameForFirstGlyphInString:s];
            NSString *fontName15 = [systemFont uc_actualFontNameForFirstGlyphInString:withVarSel15];
            NSString *fontName16 = [systemFont uc_actualFontNameForFirstGlyphInString:withVarSel16];
            NSLog(@"--> %@\t%@\t%@\t%@", hexValueString, fontName00, fontName15, fontName16);
            
            CGContextSetAllowsAntialiasing(context, true);

            [s drawAtPoint:           NSMakePoint(x+70,  y + gridHeight * idx / _numberOfRows - 1) withAttributes:systemFontAttributes];
            [withVarSel15 drawAtPoint:NSMakePoint(x+110, y + gridHeight * idx / _numberOfRows - 1) withAttributes:systemFontAttributes];
            [withVarSel16 drawAtPoint:NSMakePoint(x+150, y + gridHeight * idx / _numberOfRows - 1) withAttributes:systemFontAttributes];

            CGContextSetAllowsAntialiasing(context, false);

        }];
    }];

    CGContextRestoreGState(context);
    
}

@end
