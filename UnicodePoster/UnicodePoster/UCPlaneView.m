//
//  UCMultiplaneView.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 01/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCPlaneView.h"
#import "UCBlocksReader.h"
#import "NSFont+UC.h"
#import "NSColor+UC.h"

#define SKIP_CJK 0

static CGFloat MULTIPLANE_VIEW_LEFT_MARGIN = 19.0;
static CGFloat MULTIPLANE_VIEW_TOP_MARGIN = 12.0;
static CGFloat MULTIPLANE_VIEW_ROW_HEIGHT = 17.0;
static CGFloat MULTIPLANE_CHAR_FONT_SIZE = 16.0;

static CGFloat MULTIPLANE_VIEW_LARGE_GRADUATION_WIDTH = 19;
static CGFloat MULTIPLANE_VIEW_SHORT_GRADUATION_WIDTH = 2;

@implementation UCPlaneView

+ (instancetype)multiplaneBlocksViewOfWidth:(CGFloat)width startOffset:(uint32_t)startOffset stopOffset:(uint32_t)stopOffset {
    
    assert(stopOffset > startOffset);
    
    CGFloat height = 8614;//MULTIPLANE_VIEW_TOP_MARGIN + (0xFF+1) * MULTIPLANE_VIEW_ROW_HEIGHT + 1;
    
    UCPlaneView *mpv = [[self alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
    mpv.drawBlockNames = YES;
    mpv.startOffset = startOffset;
    mpv.stopOffset = stopOffset;
    return mpv;
}

+ (instancetype)multiplaneCharsViewWithStartOffset:(uint32_t)startOffset stopOffset:(uint32_t)stopOffset {
    
    assert(stopOffset > startOffset);
    
    CGFloat width = MULTIPLANE_VIEW_LEFT_MARGIN + (0xFF+1) * (MULTIPLANE_CHAR_FONT_SIZE + 1) + 1;
    CGFloat height = 8614;//MULTIPLANE_VIEW_TOP_MARGIN + (0xFF+1) * MULTIPLANE_VIEW_ROW_HEIGHT + MULTIPLANE_VIEW_ROW_HEIGHT + 1;
    UCPlaneView *mpv = [[self alloc] initWithFrame:NSMakeRect(0, 0, width, height)];
    mpv.drawCharacters = YES;
    mpv.startOffset = startOffset;
    mpv.stopOffset = stopOffset;
    return mpv;
}

- (BOOL)isFlipped
{
    return YES;
}

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        self.blocks = [UCBlocksReader unicodeBlocksAtPath:@"/Users/nst/Projects/UnicodePoster/UnicodePoster/Blocks.txt"];
    }
    return self;
}

- (NSArray *)blocksWithAdjacentRows {
    
    if(_blocksWithAdjacentRows == nil) {
        
        self.blocksWithAdjacentRows = [NSMutableArray array];
        
        __block uint32_t previousBlockStop = 0;
        
        __block NSMutableArray *adjacentBlocks = [NSMutableArray array];
        
        for(NSDictionary *d in self.blocks) {
            
            uint32_t start = [[d valueForKey:@"start"] unsignedIntValue];
            uint32_t stop = [[d valueForKey:@"stop"] unsignedIntValue];
            
            //            NSLog(@"-- start: 0x%08x", start);
            //            NSLog(@"-- stop: 0x%08x", stop);
            
            BOOL shouldBreak = ((start >> 8) - (previousBlockStop >> 8)) > 1;
            
            previousBlockStop = stop;
            
            if(shouldBreak) {
                [_blocksWithAdjacentRows addObject:adjacentBlocks];
                adjacentBlocks = [NSMutableArray array];
            }
            
            [adjacentBlocks addObject:d];
        }
        
        [_blocksWithAdjacentRows addObject:adjacentBlocks];
    }
    
    return _blocksWithAdjacentRows;
}

- (void)drawEachBlockName:(NSString *)blockName upperLeftStartingPoint:(NSPoint)p {
    // do nothing
}

- (void)drawRect:(NSRect)dirtyRect
{
    NSLog(@"-- DRAWING %@", self);
    
    [super drawRect:dirtyRect];
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    CGContextSaveGState(context);
    
    CGContextSetAllowsAntialiasing(context, false);
    
    //    [[NSColor whiteColor] setFill];
    //    NSRectFill(dirtyRect);
    
    CGFloat SCALE_FONT_SIZE = 10.0;
    
    NSDictionary *fixedWithFontAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:SCALE_FONT_SIZE] };
    
    NSFont *monaco10Font = [NSFont fontWithName:@"Monaco" size:10.0];
    
    CGFloat GRID_WIDTH = self.frame.size.width - MULTIPLANE_VIEW_LEFT_MARGIN - 1;
    //CGFloat GRID_HEIGHT = (0xFF+1) * MULTIPLANE_VIEW_ROW_HEIGHT;
    
    // title
    
    //    NSPoint p = NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - SCALE_FONT_SIZE - 3, MULTIPLANE_VIEW_TOP_MARGIN - SCALE_FONT_SIZE - 4);
    //    NSString *s = [[NSString stringWithFormat:@"%02x", (unsigned int)_planeNumber] uppercaseString];
    //    [s drawAtPoint:p withAttributes:fixedWithFontAttributes];
    
    // horizontal scale
    {
        NSBezierPath *path = [NSBezierPath bezierPath];
        for(unsigned int i = 0; i <= 0xFF; i += 0x10) {
            CGFloat x = MULTIPLANE_VIEW_LEFT_MARGIN + GRID_WIDTH * (1.0 * i / (0xFF+1));
            
            [path moveToPoint:NSMakePoint(x, MULTIPLANE_VIEW_TOP_MARGIN - MULTIPLANE_VIEW_ROW_HEIGHT)];
            [path lineToPoint:NSMakePoint(x, MULTIPLANE_VIEW_TOP_MARGIN)];
            
            NSPoint p = NSMakePoint(x + 3, MULTIPLANE_VIEW_TOP_MARGIN - SCALE_FONT_SIZE - 4);
            NSString *s = [[NSString stringWithFormat:@"%02x", i] uppercaseString];
            [s drawAtPoint:p withAttributes:fixedWithFontAttributes];
        }
        
        [path moveToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN + GRID_WIDTH, MULTIPLANE_VIEW_TOP_MARGIN - MULTIPLANE_VIEW_ROW_HEIGHT)];
        [path lineToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN + GRID_WIDTH, MULTIPLANE_VIEW_TOP_MARGIN)];
        
        [path stroke];
    }
    
    //    [[NSColor whiteColor] setFill];
    //    NSRectFill(dirtyRect);
    
    NSArray *blocksWithAdjacentRows = [self blocksWithAdjacentRows];
    
    [blocksWithAdjacentRows writeToFile:@"/tmp/blocks.plist" atomically:YES];
    
    __block NSFont *font = [NSFont uc_fontWithName:@"AppleColorEmoji"
                                              size:MULTIPLANE_CHAR_FONT_SIZE
                                     fallbackNames:@[@"Unifont", @"Lucida Grande", @"Unifont Upper", @"Unifont CSUR", @"Unifont Upper CSUR"]];
    
    NSDictionary *fontNameForBlock = @{@"Egyptian Hieroglyphs" : @{@"name":@"Noto Sans Egyptian Hieroglyphs", @"antialiasing":@(YES)},
                                       @"Basic Latin" : @{@"name":@"Unifont", @"antialiasing":@(NO)}};
    
    //    NSFont *font = [NSFont uc_fontWithName:@"NotoSans"
    //                                      size:MULTIPLANE_CHAR_FONT_SIZE
    //                             fallbackNames:@[@"NotoSans"]];
    
    NSDictionary *attributes = @{ NSFontAttributeName : font };
    
    NSMutableSet *fontsUsedSet = [NSMutableSet set];
    
    __block NSUInteger blockIndex = 0;
    __block NSUInteger gridRow = 0;
    
    __block uint32_t previousBlockStart = 0;
    __block uint32_t previousBlockStop = 0;
    
    __block NSMutableSet *drawnGraduationsSet = [NSMutableSet set]; // store drawn graduations to avoid drawing twice with different styles
    
    __block CGFloat yStopMax = 0;
    
    NSBezierPath *scalePath = [NSBezierPath bezierPath];
    
    [blocksWithAdjacentRows enumerateObjectsUsingBlock:^(NSArray *adjacentBlocks, NSUInteger blocksWithAdjacentRowsIndex, BOOL *stop) {
        
        //NSLog(@"-- %@", adjacentBlocks);
        
        [adjacentBlocks enumerateObjectsUsingBlock:^(NSDictionary *d, NSUInteger idx, BOOL *stop) {
            
            NSNumber *startNumber = [d valueForKey:@"start"];
            NSNumber *stopNumber = [d valueForKey:@"stop"];
            NSString *blockName = d[@"name"];
            
            NSLog(@"-- drawing %@", blockName);
            
            uint32_t blockStart = [startNumber unsignedIntValue];
            uint32_t blockStop = [stopNumber unsignedIntValue];
            
            if(blockStart < self.startOffset || blockStop > self.stopOffset) {
                //NSLog(@"-- drop 0x%08x - 0x%08x %@", [startNumber unsignedIntValue], [stopNumber unsignedIntValue], blockName);
                return;
            };
            
            //NSLog(@"-- _use 0x%08x - 0x%08x %@", [startNumber unsignedIntValue], [stopNumber unsignedIntValue], blockName);
            
            NSUInteger hexColumnStart = blockStart & 0x00FF;
            NSUInteger hexColumnStop = blockStop & 0x00FF;
            
            NSUInteger previousBlockAdvancement = (previousBlockStop >> 8) - (previousBlockStart >> 8);
            
            gridRow += previousBlockAdvancement;
            
            BOOL startsOnDifferentLineThanPreviousBlocksEnds = (blockStart >> 8) != (previousBlockStop >> 8);
            
            BOOL changeLine = (previousBlockStop > 0) && (previousBlockStop >= self.startOffset) && startsOnDifferentLineThanPreviousBlocksEnds;
            if(changeLine) gridRow += 1;
            previousBlockStart = blockStart;
            previousBlockStop = blockStop;
            
            //NSLog(@"  previous block: +%d \t changeLine: %d, gridRow %lu, %@", previousBlockAdvancement, changeLine, (unsigned long)gridRow, blockName);
            
            //NSLog(@"-- 0x%04x - 0x%04x -> %@", (unsigned int)start, (unsigned int)stop, blockName);
            
            // hex line and column
            
            NSUInteger numberOfLines = ((blockStop & 0xFF00) >> 8) - ((blockStart & 0xFF00) >> 8) + 1;
            BOOL isMultiLine = numberOfLines > 1;
            
            NSUInteger hexLine = (blockStart >> 8);
            
            // graduations
            
            BOOL isMajorGraduation = (hexLine & 0xF) == 0;
            BOOL drawGraduation = gridRow == 0 || idx == 0 || isMajorGraduation;
            
            CGFloat y = MULTIPLANE_VIEW_TOP_MARGIN + MULTIPLANE_VIEW_ROW_HEIGHT * gridRow;
            
            BOOL drawGraduationLine = [drawnGraduationsSet containsObject:@(hexLine)] == NO;
            
            if (drawGraduation) {
                NSPoint p = NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - 19, y);
                NSString *s = [[NSString stringWithFormat:@"%03x", (blockStart >> 8)] uppercaseString];
                
                [s drawAtPoint:p withAttributes:fixedWithFontAttributes];
                
                [drawnGraduationsSet addObject:@(hexLine)];
            }
            
            CGFloat graduationWidth = drawGraduation ? MULTIPLANE_VIEW_LARGE_GRADUATION_WIDTH : MULTIPLANE_VIEW_SHORT_GRADUATION_WIDTH;
            
            if(drawGraduationLine) {
                
                if(gridRow > 0 && idx == 0) {
                    [scalePath moveToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - graduationWidth, y-1)];
                    [scalePath lineToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN, y-1)];
                    [scalePath moveToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - graduationWidth, y+1)];
                    [scalePath lineToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN, y+1)];
                } else {
                    [scalePath moveToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - graduationWidth, y)];
                    [scalePath lineToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN, y)];
                }
                
            }
            
            if(isMultiLine) {
                for(unsigned int i = 1; i < numberOfLines; i++) {
                    unsigned int currentHexLine = ((blockStart >> 8) + i); // ex. 0x201
                    
                    BOOL isMajorGraduation = (currentHexLine & 0xF) == 0;
                    
                    CGFloat y = MULTIPLANE_VIEW_TOP_MARGIN + MULTIPLANE_VIEW_ROW_HEIGHT * (gridRow+i);
                    CGFloat graduationWidth = isMajorGraduation ? MULTIPLANE_VIEW_LARGE_GRADUATION_WIDTH : MULTIPLANE_VIEW_SHORT_GRADUATION_WIDTH;
                    [scalePath moveToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - graduationWidth, y)];
                    [scalePath lineToPoint:NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN, y)];
                    
                    if(isMajorGraduation) {
                        NSPoint p = NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN - 19, y);
                        NSString *s = [[NSString stringWithFormat:@"%03x", currentHexLine] uppercaseString];
                        [s drawAtPoint:p withAttributes:fixedWithFontAttributes];
                    }
                }
            }
            
            // drawing coordinates
            
            CGFloat xStart = MULTIPLANE_VIEW_LEFT_MARGIN + GRID_WIDTH * (double)hexColumnStart / (0xFF+1);
            CGFloat xStop = MULTIPLANE_VIEW_LEFT_MARGIN + GRID_WIDTH * ((double)hexColumnStop+1.0) / (0xFF+1);
            CGFloat yStart = MULTIPLANE_VIEW_TOP_MARGIN + (MULTIPLANE_VIEW_ROW_HEIGHT * gridRow);
            CGFloat yStop = yStart + (numberOfLines) * MULTIPLANE_VIEW_ROW_HEIGHT;
            
            yStopMax = MAX(yStopMax, yStop);
            
            //NSLog(@"  xStart:%f \t xStop:%f \t yStart:%f \t yStop:%f", xStart, xStop, yStart, yStop);
            
            /**/
            
            NSBezierPath *path = [NSBezierPath bezierPath];
            
            /*
             +---------0------1
             6---------7      |
             |      3---------2
             5------4---------+
             */
            
            NSPoint p0 = NSMakePoint(xStart, yStart);
            NSPoint p1 = NSMakePoint(isMultiLine ? MULTIPLANE_VIEW_LEFT_MARGIN + GRID_WIDTH : xStop, p0.y);
            NSPoint p2 = NSMakePoint(p1.x, yStop - MULTIPLANE_VIEW_ROW_HEIGHT);
            NSPoint p3 = NSMakePoint(xStop, p2.y);
            NSPoint p4 = NSMakePoint(xStop, yStop);
            NSPoint p5 = NSMakePoint(isMultiLine ? MULTIPLANE_VIEW_LEFT_MARGIN : xStart, yStop);
            NSPoint p6 = NSMakePoint(p5.x, yStart + MULTIPLANE_VIEW_ROW_HEIGHT);
            NSPoint p7 = NSMakePoint(xStart, p6.y);
            
            [path moveToPoint:p0];
            [path lineToPoint:p1];
            [path lineToPoint:p2];
            [path lineToPoint:p3];
            [path lineToPoint:p4];
            [path lineToPoint:p5];
            [path lineToPoint:p6];
            [path lineToPoint:p7];
            [path lineToPoint:p0];
            
            NSColor *lightColor = nil;
            NSColor *darkColor = nil;
            
            NSUInteger planeNumber = blockStart >> 16;
            
            if(planeNumber == 0) {
                lightColor = [NSColor uc_planeColor_0_light];
                darkColor = [NSColor uc_planeColor_0_dark];
            } else if (planeNumber == 1) {
                lightColor = [NSColor uc_planeColor_1_light];
                darkColor = [NSColor uc_planeColor_1_dark];
            } else if (planeNumber == 2) {
                lightColor = [NSColor uc_planeColor_2_light];
                darkColor = [NSColor uc_planeColor_2_dark];
            } else if (planeNumber == 14) {
                lightColor = [NSColor uc_planeColor_14_light];
                darkColor = [NSColor uc_planeColor_14_dark];
            } else {
                lightColor = [NSColor lightGrayColor];
                darkColor = [NSColor grayColor];
            }
            
            if (blockIndex % 2 == 0) {
                [lightColor set];
            } else {
                [darkColor set];
            }
            
            [path fill];
            [[NSColor blackColor] set];
            
            [path stroke];
            
            if(self.drawBlockNames) {
                NSPoint p = NSMakePoint(xStart + 3, yStart);
                [blockName drawAtPoint:p withAttributes:@{ NSFontAttributeName : [NSFont fontWithName:@"Monaco" size:10] }];
            }
            
            // iterate over each character
            
            BOOL drawingBlockCharactersIsPrevented = (SKIP_CJK && [blockName hasPrefix:@"CJK"]);
            
            if(self.drawCharacters && !drawingBlockCharactersIsPrevented) {
                
                CGContextSetAllowsAntialiasing(context, false);
                
                NSDictionary *d = [fontNameForBlock valueForKey:blockName];
                NSString *alternameFontName = d[@"name"];
                BOOL antialiasing = [d[@"antialiasing"] boolValue];
                if(alternameFontName) {
                    font = [NSFont uc_fontWithName:alternameFontName
                                              size:MULTIPLANE_CHAR_FONT_SIZE
                                     fallbackNames:@[]];
                    CGContextSetAllowsAntialiasing(context, antialiasing);
                }
                
                uint32_t highBitsStart = (blockStart >> 8);
                uint32_t highBitsStop = (blockStop >> 8);
                
                for(uint32_t highBits = highBitsStart; highBits <= highBitsStop; highBits += 1) {
                    
                    //NSLog(@"** highBits = 0x%08x", highBits);
                    
                    for(uint32_t lowBits = 0x00; lowBits < (0xFF+1); lowBits++) {
                        
                        uint32_t unicodeInt = (highBits << 8) + lowBits;
                        
                        if(unicodeInt < blockStart) {
                            //NSLog(@"-- block: [0x%08x 0x%08x] \t 0x%08x < 0x%08x", blockStart, blockStop, unicodeInt, blockStart);
                            continue;
                        }
                        
                        if(unicodeInt > blockStop) {
                            //NSLog(@"-- block: [0x%08x 0x%08x] \t 0x%08x > 0x%08x", blockStart, blockStop, unicodeInt, blockStop);
                            continue;
                        }
                        
                        NSString *string = nil;
                        
                        if(self.variationSelector > 0) {
                            uint32_t values[2] = {unicodeInt, self.variationSelector};
                            string = [[NSString alloc] initWithBytes:values length:(sizeof(uint32_t)*2) encoding:NSUTF32LittleEndianStringEncoding];
                        } else {
                            NSStringEncoding encoding = (unicodeInt > 0xFFFF) ? NSUTF32LittleEndianStringEncoding : NSUTF16LittleEndianStringEncoding; // UTF32 won't work for surrogates
                            string = [[NSString alloc] initWithBytes:&unicodeInt length:sizeof(uint32_t) encoding:encoding];
                        }
                        
                        assert(string != nil);
                        
                        NSString *usedFontName = [font uc_actualFontNameForFirstGlyphInString:string];
                        
                        //                        if([usedFontName hasPrefix:@"Unifont"] == NO) {
                        //                            if([usedFontName isEqualToString:@"LastResort"] == NO) {
                        //                                NSLog(@"-- 0x%08x %@", unicodeInt, usedFontName);
                        //                            }
                        //                            //continue;
                        //                        }
                        
                        if([usedFontName isEqualToString:@"LastResort"]) {
                            continue;
                        }
                        
                        [fontsUsedSet addObject:usedFontName];
                        
                        CGFloat x = MULTIPLANE_VIEW_LEFT_MARGIN + 1 + (self.frame.size.width - MULTIPLANE_VIEW_LEFT_MARGIN - 1) * (1.0 * lowBits / (0xFF+1));
                        NSUInteger rowNumber = gridRow + (highBits - highBitsStart);
                        CGFloat y = MULTIPLANE_VIEW_TOP_MARGIN + (rowNumber * MULTIPLANE_VIEW_ROW_HEIGHT) - 11;
                        
                        if(antialiasing) y += 2;
                        
                        NSPoint p = NSMakePoint(x, y);
                        
                        //NSLog(@"-- unicodeInt 0x%08x \t row:%lu \t %@", unicodeInt, rowNumber, NSStringFromPoint(p));
                        
                        [string drawAtPoint:p withAttributes:attributes];
                    }
                }
                
                CGContextSetAllowsAntialiasing(context, false);
            }
            
            blockIndex += 1;
        }];
    }];
    
    [scalePath stroke];
    
    NSRect rect = NSMakeRect(MULTIPLANE_VIEW_LEFT_MARGIN, MULTIPLANE_VIEW_TOP_MARGIN, GRID_WIDTH, yStopMax - MULTIPLANE_VIEW_TOP_MARGIN);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    [path stroke];
    
    // footer
    
    if(self.drawCharacters) {
        NSArray *fontsUsed = [[fontsUsedSet allObjects] sortedArrayUsingSelector:@selector(compare:)];
        NSString *footerString = [NSString stringWithFormat:@"Glyphs from fonts: %@.", [fontsUsed componentsJoinedByString:@", "]];
        NSPoint footerTextDrawingPoint = NSMakePoint(MULTIPLANE_VIEW_LEFT_MARGIN + 3, self.frame.size.height - 16);
        [footerString drawAtPoint:footerTextDrawingPoint withAttributes:@{ NSFontAttributeName : monaco10Font }];
    }
    
    CGContextRestoreGState(context);
}


@end
