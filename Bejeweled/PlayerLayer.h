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

@interface PlayerLayer : CCLayer {
    
    int _locations[kRows][kCols];
    GemLayer *gems[kRows][kCols];
}

@property(nonatomic) int level;

+(CCScene *) scene;

- (void)initGame;

@end
