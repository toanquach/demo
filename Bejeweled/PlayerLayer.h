//
//  PlayerLayer.h
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GemLayer.h"
#import "SimpleAudioEngine.h"

@interface PlayerLayer : CCLayer {
    
    int _locations[kRows][kCols];
    GemLayer *gems[kRows][kCols];
    NSMutableArray *gemSpriteList;
    int startY;
    GemLayer *selectedGem;
}

@property(nonatomic) int level;

+(CCScene *) scene;

- (void)initGame;

- (void)swapGem:(GemLayer *)gem1 andGem:(GemLayer *)gem2;

@end
