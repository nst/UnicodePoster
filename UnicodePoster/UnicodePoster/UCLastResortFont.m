//
//  UCAlternateCharsView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 12/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCLastResortFont.h"

NSUInteger LASTRESORT_VIEW_TITLE_HEIGHT = 55;
NSUInteger LASTRESORT_VIEW_LINE_HEIGHT = 110;
NSUInteger LASTRESORT_VIEW_LINE_WIDTH = 110;

@implementation UCLastResortFont

+ (instancetype)lastResortFontView {
    return [[self alloc] initWithFrame:NSMakeRect(0, 0, 800, 620)];
}

+ (void)showCompositionDetailsForString:(NSString *)s font:(NSFont *)font {
    CFStringRef string = (__bridge CFStringRef)s;
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: (NSString *)kCTFontAttributeName];
    CFAttributedStringRef attrStr = CFAttributedStringCreate(kCFAllocatorDefault, string, (CFDictionaryRef) stringAttributes);
    CTLineRef line = CTLineCreateWithAttributedString(attrStr);
    CFShow(line);
    CFRelease(line);
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
    return NO;
}

+ (NSFont *)lastResortFontWithSize:(CGFloat)size {
    NSFontDescriptor *fallbackFd = [NSFontDescriptor fontDescriptorWithName:@"LastResort" size:size];
	NSDictionary *attributes = @{NSFontCascadeListAttribute : @[fallbackFd]};
    NSFontDescriptor *fd = [NSFontDescriptor fontDescriptorWithFontAttributes:attributes];
    return [NSFont fontWithDescriptor:fd size:size];
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
    
    CGFloat HEIGHT = self.frame.size.height;
    
    NSRect titleRect = NSMakeRect(0, HEIGHT - LASTRESORT_VIEW_TITLE_HEIGHT, self.frame.size.width - 1, LASTRESORT_VIEW_TITLE_HEIGHT - 1);
    NSBezierPath *titlePath = [NSBezierPath bezierPathWithRect:titleRect];
    [[NSColor blackColor] set];
    [titlePath stroke];
    
    NSRect tableRect = NSMakeRect(0, 0, self.frame.size.width - 1, HEIGHT - LASTRESORT_VIEW_TITLE_HEIGHT);
    NSBezierPath *tablePath = [NSBezierPath bezierPathWithRect:tableRect];
    [[NSColor blackColor] set];
    [tablePath stroke];
    
    /**/
    
    NSDictionary *fixedSizeFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] };
//    NSDictionary *systemFontAttributes = @{ NSFontAttributeName : [NSFont systemFontOfSize:14.0] };
    
    NSString *title = @"LastResort Font";
    NSString *subTitle1 = @"";
    NSString *subTitle2 = @"The LastResort font is used by the operating system to display Unicode data when no other font can be found.";
    NSString *subTitle3 = @"Glyphs correspond to Unicode blocks. The LastResort font is made available by Apple via the Unicode Consortium.";
    
    [title drawAtPoint:NSMakePoint(3, HEIGHT - 14) withAttributes:fixedSizeFontAttributes];
    [subTitle1 drawAtPoint:NSMakePoint(3, HEIGHT - 27) withAttributes:fixedSizeFontAttributes];
    [subTitle2 drawAtPoint:NSMakePoint(3, HEIGHT - 40) withAttributes:fixedSizeFontAttributes];
    [subTitle3 drawAtPoint:NSMakePoint(3, HEIGHT - 53) withAttributes:fixedSizeFontAttributes];
    
    CGContextSetAllowsAntialiasing(context, true);

    NSFont *font = [NSFont fontWithName:@"LastResort" size:96.0];

    NSArray *line0 = @[@"lastresortlatin", @"lastresortcombiningdiacritics", @"lastresortcyrillic", @"lastresorthebrew", @"lastresortarabic", @"lastresortgeorgian", @"lastresortethiopic"];
    NSArray *line1 = @[@"lastresortdingbats", @"lastresorthiragana", @"lastresortkatakana", @"lastresortmahjongtiles", @"lastresortdominotiles", @"lastresortplayingcards", @"lastresortemoticons"];
    NSArray *line2 = @[@"lastresortcuneiform", @"lastresortegyptianhieroglyphs", @"lastresortbyzantinemusic", @"lastresortalchemicalsym", @"lastresortphaistosdisc", @"lastresortcombiningdiacritics", @"lastresortvariationselectors"];
    NSArray *line3 = @[@"lastresortnotdefplanezero", @"lastresortnotdefplaneone", @"lastresortnotdefplanetwo", @"lastresortnotdefplanethree", @"lastresortnotdefplanefourteen", @"lastresortspecials", @"lastresortnotaunicode"];
    NSArray *line4 = @[@"lastresorthighsurrogate", @"lastresorthighprivatesurrogate", @"lastresortlowsurrogate", @"lastresortprivateuse", @"lastresortprivateplane15", @"lastresortprivateplane16", @"lastresortprivateplane17"];

    NSArray *glyphsLines = @[ line0, line1, line2, line3, line4 ];
    
    [glyphsLines enumerateObjectsUsingBlock:^(NSArray *glypheNames, NSUInteger row, BOOL *stop) {

        [glypheNames enumerateObjectsUsingBlock:^(NSString *name, NSUInteger col, BOOL *stop) {

            NSGlyph glyph = [font glyphWithName:name];
            
            CGFloat x = 7 + col * LASTRESORT_VIEW_LINE_WIDTH;
            CGFloat y = HEIGHT - LASTRESORT_VIEW_TITLE_HEIGHT - 90 - row * LASTRESORT_VIEW_LINE_HEIGHT;
            
            NSPoint p = NSMakePoint(x, y);
            
            NSBezierPath *bp = [NSBezierPath bezierPath];
            [bp moveToPoint:p];
            [bp appendBezierPathWithGlyph:glyph inFont:font];
            [bp fill];

        }];
        
    }];
    
    CGContextRestoreGState(context);
}

@end
