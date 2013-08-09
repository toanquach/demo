//
//  PlayerLayer.m
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import "PlayerLayer.h"


@implementation PlayerLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    PlayerLayer *player = [PlayerLayer node];
    
    [scene addChild:player];
    
    return scene;
}

-(id) init
{
    if (self = [super init])
    {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"Screenshot 2013.08.09 14.24.31.png"];
        backgroundImage.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:backgroundImage z:-2];
        
        
        if (!IS_RETINA)
        {
            backgroundImage.scale = 0.5;
        }
    }
    return self;
}
@end
