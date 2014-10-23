
//
//  UCBlocksReader.m
//  UnicodePoster
//
//  Created by Nicolas Seriot on 01/09/14.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

#import "UCBlocksReader.h"

@implementation UCBlocksReader

+ (NSArray *)unicodeBlocksAtPath:(NSString *)path {
    
    NSString *s = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lines = [s componentsSeparatedByString:@"\n"];
    
    NSArray *dataLines = [lines filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *line = evaluatedObject;
        
        if([line hasPrefix:@"#"]) return NO;
        
        if([line length] == 0) return NO;
        
        return YES;
    }]];
    
    NSMutableArray *ma = [NSMutableArray array];
    
    for(NSString *line in dataLines) {
        
        // assume that line is formatted like '0D00..0D7F; Malayalam' or 'FE00..FE0F; Var. Sel.; Variation Selectors'
        
        NSArray *rangeAndName = [line componentsSeparatedByString:@"; "];
        NSString *range = rangeAndName[0];
        NSString *name = rangeAndName[1];
        
        NSArray *ranges = [range componentsSeparatedByString:@".."];
        NSString *rangeStringStart = ranges[0];
        NSString *rangeStringStop = ranges[1];
        
        unsigned startInt, stopInt;
        
        NSScanner *scanner1 = [NSScanner scannerWithString:rangeStringStart];
        [scanner1 scanHexInt:&startInt];
        
        NSScanner *scanner2 = [NSScanner scannerWithString:rangeStringStop];
        [scanner2 scanHexInt:&stopInt];
        
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        
        md[@"start"] = @(startInt);
        md[@"stop"] = @(stopInt);
        md[@"name"] = name;
        
        [ma addObject:md];
    }
    
    return ma;
}

@end
