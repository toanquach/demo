//
//  MAGem.h
//  Bejeweled2
//
//  Created by Toan.Quach on 8/20/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MAPlayfieldLayer;

typedef enum
{
    kGemAnyType = 0,
    kGemBlue,
    kGemGreen,
    kGemOrange,
    kGemPurple,
    kGemRed,
    kGemWhite,
    kGemYellow
}GemType;

typedef enum
{
    kGemIdle    = 100,
    kGemMoving,
    kGemScoring,
    kGemNew
}GemState;

@interface MAGem : CCSprite
{
    NSInteger _rowNum;              // Row number for this gem
    NSInteger _colNum;              // Column number for this gem
    GemType _gemType;               // The enum value of the gem
    GemState _gemState;             // The current state of the gem
    MAPlayfieldLayer *gameLayer;    // The game layer
}

@property (nonatomic, assign) NSInteger rowNum;
@property (nonatomic, assign) NSInteger colNum;
@property (nonatomic, assign) GemType gemType;
@property (nonatomic, assign) GemState gemState;
@property (nonatomic, assign) MAPlayfieldLayer *gameLayer;

-(BOOL) isGemSameAs:(MAGem*)otherGem;
-(BOOL) isGemInSameRow:(MAGem*)otherGem;
-(BOOL) isGemInSameColumn:(MAGem*)otherGem;
-(BOOL) isGemBeside:(MAGem*)otherGem;

-(void) highlightGem;
-(void) stopHighlightGem;

- (BOOL) containsTouchLocation:(CGPoint)pos;

@end
