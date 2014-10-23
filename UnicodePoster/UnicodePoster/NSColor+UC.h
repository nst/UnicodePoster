//
//  NSColor+UC.h
//  UnicodePoster
//
//  Created by Nicolas Seriot on 24/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (UC)

+ (NSColor *)uc_planeColor_1_4;
+ (NSColor *)uc_planeColor_2_4;
+ (NSColor *)uc_planeColor_3_4;
+ (NSColor *)uc_planeColor_4_4;

+ (NSColor *)uc_planeColor_0_light;
+ (NSColor *)uc_planeColor_0_dark;
+ (NSColor *)uc_planeColor_1_light;
+ (NSColor *)uc_planeColor_1_dark;
+ (NSColor *)uc_planeColor_2_light;
+ (NSColor *)uc_planeColor_2_dark;
+ (NSColor *)uc_planeColor_14_light;
+ (NSColor *)uc_planeColor_14_dark;

- (NSColor *)uc_lightColor;

@end
