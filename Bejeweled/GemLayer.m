//
//  GemLayer.m
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import "GemLayer.h"


@implementation GemLayer

@synthesize gemName;
@synthesize gemValue;
@synthesize row;
@synthesize col;
@synthesize anim_row;
@synthesize anim_col;
@synthesize isFocus;
@synthesize willDrop;
@synthesize beforeDrop;
@synthesize dropDistance;

-(id)init
{
    if (self = [super init])
    {
        self.beforeDrop = 0;
        self.dropDistance = 0;
        self.willDrop = FALSE;
        self.isFocus = FALSE;
    }
    return self;
}

-(id)initWithGemLayer:(GemLayer *)gem
{
    if (self = [super init])
    {
        self.row = gem.row;
        self.col = gem.col;
        self.gemName = gem.gemName;
        self.gemValue = gem.gemValue;
        self.anim_row = gem.anim_row;
        self.anim_col = gem.anim_col;
        self.isFocus = gem.isFocus;
        self.willDrop = gem.willDrop;
        self.beforeDrop = gem.beforeDrop;
        self.dropDistance = gem.dropDistance;
    }
    
    return self;
}

- (id)initWithGemValue:(int)value andRow:(int)mRow andCol:(int)mCol
{
    if (self = [super init])
    {
        self.gemValue = value;
        self.row = mRow;
        self.col = mCol;
        self.beforeDrop = 0;
        self.dropDistance = 0;
        self.willDrop = FALSE;
        self.isFocus = FALSE;
    }
    return self;
}

// ****************************************************
//      Check a gem is neighbor of self
//
-(BOOL) isNeighbor:(GemLayer *)other
{
    if (abs(row - other.row) == 1 && abs(col-other.col) == 0)
    {
        return true;
    }
    else if (abs(row - other.row) == 0 && abs(col - other.col) == 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

-(void) moveRow:(int)step andDirection:(int)direction
{
    anim_row += step*direction;
}

-(void) moveCol:(int)step andDirection:(int)direction
{
    anim_col += step*direction;
}


@end
