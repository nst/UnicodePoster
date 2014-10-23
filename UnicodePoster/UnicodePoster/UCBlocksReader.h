//
//  UCBlocksReader.h
//  UnicodePoster
//
//  Created by Nicolas Seriot on 01/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCBlocksReader : NSObject

+ (NSArray *)unicodeBlocksAtPath:(NSString *)path;

@end
