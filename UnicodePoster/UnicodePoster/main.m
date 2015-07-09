//
//  main.m
//  Unicode
//
//  Created by Nicolas Seriot on 26/08/07.
//  Copyright (c) 2014 Nicolas Seriot. All rights reserved.
//

// http://www.unicode.org/roadmaps/bmp/

// http://www.unicode.org/Public/UNIDATA/Blocks.txt

#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#import "UCMainView.h"

#import "UCMiniPlanesView.h"
#import "UCVariationSelectorsView.h"
#import "UCLastResortFont.h"
#import "UCFlagsView.h"
#import "UCUTF8View.h"
#import "UCUTF16View.h"
#import "UCUTF32View.h"
#import "UCNormalizationView.h"
#import "UCCollationView.h"
#import "UCCaseMappingView.h"
#import "UCBrailleView.h"
#import "UCCharsAndGylphsView.h"
#import "UCPlaneView.h"
#import "UCTitleView.h"

#define DRAW_CHARS 1

int main(int argc, const char * argv[])
{
    
    @autoreleasepool {
        
        UCMainView *mainView = [[UCMainView alloc] initWithFrame:NSMakeRect(0, 0, 5800, 10100)];
        
        UCMiniPlanesView *miniPlanesView = [UCMiniPlanesView miniPlanesView];
        [miniPlanesView setFrameOrigin:NSMakePoint(50, 50)];
        [mainView addSubview:miniPlanesView];

        UCPlaneView *planeBlocksView = [UCPlaneView multiplaneBlocksViewOfWidth:1024 startOffset:0x000000 stopOffset:0xF0000];
        [planeBlocksView setFrameOrigin:NSMakePoint(miniPlanesView.frame.origin.x + miniPlanesView.frame.size.width + 20, 50)];
        [mainView addSubview:planeBlocksView];

        UCPlaneView *planeCharsView = [UCPlaneView multiplaneCharsViewWithStartOffset:0x000000 stopOffset:0xF0000];
        [planeCharsView setFrameOrigin:NSMakePoint(planeBlocksView.frame.origin.x + planeBlocksView.frame.size.width + 50, 50)];
#if DRAW_CHARS
        planeCharsView.drawCharacters = YES;
#else
        planeCharsView.drawCharacters = NO;
#endif
        [mainView addSubview:planeCharsView];
        
        /**/
        
        UCUTF8View *utf8View = [UCUTF8View utf8View];
        [utf8View setFrameOrigin:NSMakePoint(50, planeCharsView.frame.origin.y + planeCharsView.frame.size.height + 50)];
        [mainView addSubview:utf8View];

        UCUTF16View *utf16View = [UCUTF16View utf16View];
        [utf16View setFrameOrigin:NSMakePoint(utf8View.frame.origin.x + utf8View.frame.size.width + 50, utf8View.frame.origin.y)];
        [mainView addSubview:utf16View];
        
        UCUTF32View *utf32View = [UCUTF32View utf32View];
        [utf32View setFrameOrigin:NSMakePoint(utf16View.frame.origin.x + utf16View.frame.size.width + 50, utf16View.frame.origin.y)];
        [mainView addSubview:utf32View];

        UCFlagsView *flagsView = [UCFlagsView flagsView];
        [flagsView setFrameOrigin:NSMakePoint(utf32View.frame.origin.x + utf32View.frame.size.width + 50, utf32View.frame.origin.y)];
        [mainView addSubview:flagsView];

        UCLastResortFont *lastResortView = [UCLastResortFont lastResortFontView];
        [lastResortView setFrameOrigin:NSMakePoint(flagsView.frame.origin.x + flagsView.frame.size.width + 50, flagsView.frame.origin.y)];
        [mainView addSubview:lastResortView];
        
        UCVariationSelectorsView *altEmojisView = [UCVariationSelectorsView alternateEmojisView];
        [altEmojisView setFrameOrigin:NSMakePoint(lastResortView.frame.origin.x + lastResortView.frame.size.width + 50, lastResortView.frame.origin.y)];
        [mainView addSubview:altEmojisView];

        UCBrailleView *brailleView = [UCBrailleView brailleView];
        [brailleView setFrameOrigin:NSMakePoint(altEmojisView.frame.origin.x + altEmojisView.frame.size.width + 50, altEmojisView.frame.origin.y)];
        [mainView addSubview:brailleView];
        
        UCNormalizationView *normalizationView = [UCNormalizationView normalizationView];
        [normalizationView setFrameOrigin:NSMakePoint(50, utf8View.frame.origin.y + utf8View.frame.size.height + 50)];
        [mainView addSubview:normalizationView];
        
        UCCaseMappingView *caseMappingView = [UCCaseMappingView caseMappingView];
        [caseMappingView setFrameOrigin:NSMakePoint(normalizationView.frame.origin.x + normalizationView.frame.size.width + 50, normalizationView.frame.origin.y)];
        [mainView addSubview:caseMappingView];

        UCCollationView *collationView = [UCCollationView collationView];
        [collationView setFrameOrigin:NSMakePoint(caseMappingView.frame.origin.x + caseMappingView.frame.size.width + 50, caseMappingView.frame.origin.y)];
        [mainView addSubview:collationView];
        
        UCCharsAndGylphsView *cagView = [UCCharsAndGylphsView charsAndGylphsView];
        [cagView setFrameOrigin:NSMakePoint(collationView.frame.origin.x + collationView.frame.size.width + 50, collationView.frame.origin.y)];
        [mainView addSubview:cagView];

        UCTitleView *titleView = [UCTitleView titleView];
        [titleView setFrameOrigin:NSMakePoint(brailleView.frame.origin.x + brailleView.frame.size.width + 50, brailleView.frame.origin.y)];
        [mainView addSubview:titleView];
        
        NSBitmapImageRep *rep = [mainView bitmapImageRepForCachingDisplayInRect:[mainView bounds]];
        [mainView cacheDisplayInRect:[mainView bounds] toBitmapImageRep:rep];
        NSData *data = [rep representationUsingType:NSPNGFileType properties:@{}];
        
        NSString *path = @"/tmp/poster.png";
        NSLog(@"-- writing %@", path);
        [data writeToFile:path atomically:YES];
    }
    return 0;
}
