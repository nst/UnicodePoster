//
//  NSColor+UC.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 24/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

// http://tools.medialab.sciences-po.fr/iwanthue/

#import "NSColor+UC.h"

@implementation NSColor (UC)

+ (NSColor *)uc_planeColor_0_light {
    return [NSColor colorWithCalibratedRed:0.9 green:0.9 blue:1.0 alpha:1.0];
}

+ (NSColor *)uc_planeColor_0_dark {
    return [NSColor colorWithCalibratedRed:0.7 green:0.7 blue:1.0 alpha:1.0];
}

+ (NSColor *)uc_planeColor_1_light {
    return [NSColor colorWithCalibratedRed:0.8 green:0.9 blue:0.8 alpha:1.0];
}

+ (NSColor *)uc_planeColor_1_dark {
    return [NSColor colorWithCalibratedRed:0.7 green:0.9 blue:0.7 alpha:1.0];
}

+ (NSColor *)uc_planeColor_2_light {
    return [NSColor colorWithCalibratedRed:1.0 green:0.9 blue:0.9 alpha:1.0];
}

+ (NSColor *)uc_planeColor_2_dark {
    return [NSColor colorWithCalibratedRed:1.0 green:0.8 blue:0.8 alpha:1.0];
}

+ (NSColor *)uc_planeColor_14_light {
    return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.8 alpha:1.0];
}

+ (NSColor *)uc_planeColor_14_dark {
    return [NSColor colorWithCalibratedRed:1.0 green:1.0 blue:0.6 alpha:1.0];
}

+ (NSColor *)uc_planeColor_1_4 {
    return [NSColor colorWithCalibratedRed:228/255. green:202/255. blue:123/255. alpha:0.7];
}

+ (NSColor *)uc_planeColor_2_4 {
    return [NSColor colorWithCalibratedRed:169/255. green:228/255. blue:141/255. alpha:0.7];
}

+ (NSColor *)uc_planeColor_3_4 {
    return [self uc_planeColor_0_dark];//[NSColor colorWithCalibratedRed:198/255. green:88/255. blue:62/255. alpha:0.7];
}

+ (NSColor *)uc_planeColor_4_4 {
    return [self uc_planeColor_2_dark];//[NSColor colorWithCalibratedRed:106/255. green:120/255. blue:185/255. alpha:0.7];
}

- (NSColor *)copyWithAlpha:(CGFloat)alpha {
    CGFloat r,g,b,a;
    
    [self getRed:&r green:&g blue:&b alpha:&a];
    
    NSColor *c = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:alpha];
    
    return c;
}

- (NSColor *)uc_lightColor {
    return [self copyWithAlpha:0.4];
}

@end
