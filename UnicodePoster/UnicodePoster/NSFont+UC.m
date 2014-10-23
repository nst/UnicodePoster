//
//  NSFont+UC.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 20/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "NSFont+UC.h"

@implementation NSFont (UC)

+ (NSFont *)uc_fontWithName:(NSString *)fontName
                       size:(CGFloat)size
              fallbackNames:(NSArray *)fallbackNames {

	NSMutableArray *fallbackDescriptors = [NSMutableArray array];
    
	for (NSString *name in fallbackNames) {
		NSFontDescriptor *fd = [NSFontDescriptor fontDescriptorWithName:name size:size];
        if(fd == nil) {
            NSLog(@"-- can't find font descriptor for fallback font %@", name);
            continue;
        }
        [fallbackDescriptors addObject:fd];
	}
    
	NSDictionary *attributes = @{ NSFontNameAttribute : fontName,
                                  NSFontCascadeListAttribute : fallbackDescriptors };
    
    NSFontDescriptor *fd = [NSFontDescriptor fontDescriptorWithFontAttributes:attributes];
    
    return [NSFont fontWithDescriptor:fd size:size];
}

- (NSString *)uc_actualFontNameForFirstGlyphInString:(NSString *)s {
    CFStringRef string = (__bridge CFStringRef)s;
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:self forKey: (NSString *)kCTFontAttributeName];
    CFAttributedStringRef attrStr = CFAttributedStringCreate(kCFAllocatorDefault, string, (CFDictionaryRef) stringAttributes);
    CTLineRef line = CTLineCreateWithAttributedString(attrStr);
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    CFIndex runsCount = CFArrayGetCount(runs);
    if(runsCount == 0) return nil;
    
    CTRunRef run = CFArrayGetValueAtIndex(runs, 0);
    NSDictionary *d = (__bridge NSDictionary *)CTRunGetAttributes(run);
    NSFont *usedFont = [d valueForKey:@"NSFont"];
    NSString *usedFontName = [usedFont fontName];
    return usedFontName;
}

@end
