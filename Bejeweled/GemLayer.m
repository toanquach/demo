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

-(id)initWithGemLayer:(GemLayer *)gem
{
    
    if (self = [super init])
    {
        self.row = gem.row;
        self.col = gem.col;
        self.gemName = gem.gemName;
        self.gemValue = gem.gemValue;
    }
    return self;
}

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
@end
