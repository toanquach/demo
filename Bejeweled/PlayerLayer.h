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
#import "Algorithms.h"

@interface PlayerLayer : CCLayer
{
    int _locations[kRows][kCols];
    
    // gem item obj
    GemLayer *gems[kRows][kCols];

    // gem item ccsprite
    NSMutableArray *gemSpriteList;
    
    int startY;
    
    GemLayer *selectedGem;
    
    Algorithms *solver;
    
    NSMutableArray *chains;
}

@property(nonatomic) int level;

+(CCScene *) scene;

- (void)initGame;

- (void)swapGem:(GemLayer *)gem1 andGem:(GemLayer *)gem2;

- (BOOL)updateGame;

//-----------------------------------------------------
- (void)performIsStable;

- (BOOL)isStable;

- (void)rmChains;

- (void)markDeleted;

- (void)calculateDrop;

- (void)checkColumns;

- (void)checkRows;

- (void)applyDrop;

- (void)fillEmpty;

- (void)endCascade;

- (GemLayer *)randomGem:(int)row andCol:(int)col;

@end
