//
//  NSFont+UC.h
//  UnicodePoster
//
//  Created by Nicolas Seriot on 20/08/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSFont (UC)

+ (NSFont *)uc_fontWithName:(NSString *)fontName size:(CGFloat)size fallbackNames:(NSArray *)fallbackNames;

- (NSString *)uc_actualFontNameForFirstGlyphInString:(NSString *)s;

@end
