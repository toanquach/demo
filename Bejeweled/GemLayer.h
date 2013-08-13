//
//  GemLayer.h
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GemLayer : CCNode
{
    
}

@property(nonatomic, retain) NSString *gemName;
@property(nonatomic) int    gemValue;
@property(nonatomic) int    row;
@property(nonatomic) int    col;
@property(nonatomic) int    anim_row;
@property(nonatomic) int    anim_col;
@property(nonatomic) BOOL   isFocus;
@property(nonatomic) BOOL   willDrop;
@property(nonatomic) int    beforeDrop;
@property(nonatomic) int    dropDistance;

- (id)initWithGemLayer:(GemLayer *)gem;

- (id)initWithGemValue:(int)value andRow:(int)mRow andCol:(int)mCol;

- (BOOL)isNeighbor:(GemLayer *)other;

- (void)moveRow:(int)step andDirection:(int)direction;

- (void)moveCol:(int)step andDirection:(int)direction;

@end
