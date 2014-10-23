//
//  UCBitsView.h
//  UnicodePoster
//
//  Created by Nicolas Seriot on 10/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UCBitsView : NSView

+ (instancetype)bitsViewWithBits:(NSString *)bits comment:(NSString *)comment;

@property (nonatomic, strong) NSString *bits;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSColor *leftColor;
@property (nonatomic, strong) NSColor *rightColor;
@property (nonatomic) NSUInteger rightColorStartIndex;
@property (nonatomic) BOOL strikeBoxes;

+ (CGFloat)titleHeight;

@end
