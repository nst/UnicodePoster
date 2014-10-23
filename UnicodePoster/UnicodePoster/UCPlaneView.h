//
//  UCMultiplaneView.h
//  UnicodePoster
//
//  Created by Nicolas Seriot on 01/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface UCPlaneView : NSView

@property (nonatomic, strong) NSArray *blocks;

@property (nonatomic, strong) NSMutableArray *blocksWithAdjacentRows;

@property (nonatomic) uint32_t startOffset;
@property (nonatomic) uint32_t stopOffset;

@property (nonatomic) BOOL drawCharacters;
@property (nonatomic) BOOL drawBlockNames;

@property (nonatomic) unsigned int variationSelector; // 0xFE0E, 0xFE0F, ...

+ (instancetype)multiplaneBlocksViewOfWidth:(CGFloat)width startOffset:(uint32_t)startOffset stopOffset:(uint32_t)stopOffset;

+ (instancetype)multiplaneCharsViewWithStartOffset:(uint32_t)startOffset stopOffset:(uint32_t)stopOffset;

@end
