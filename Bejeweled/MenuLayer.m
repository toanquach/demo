//
//  MenuLayer.m
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import "MenuLayer.h"
#import "PlayerLayer.h"

@implementation MenuLayer


+(CCScene *) scene
{
    // Create scene
    CCScene *scene = [CCScene node];
    
    // Add Menu Layer
    MenuLayer *menu = [MenuLayer node];
    
    [scene addChild:menu];
    
    return scene;
}

-(id) init
{
    if (self = [super init])
    {
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        // ***********************************************
        //          Add background image
        //
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"WoodRetroApple_iPad_HomeScreen.jpg" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
        backgroundImage.position = ccp(winSize.width/2, winSize.height/2);
        [self addChild:backgroundImage z:-2];
        // ***********************************************
        //          Add logo images
        //
        CCSprite *logoSprite = [CCSprite spriteWithFile:@"bejeweled_logo.png"];
        logoSprite.position = ccp(winSize.width/2, winSize.height - 50);
        [self addChild:logoSprite];
        // **********************************************
        //          Add Menu images
        //
        CCMenuItemImage *menu01 = [CCMenuItemImage itemWithNormalImage:@"menu01.png" selectedImage:@"menu01_hover.png" target:self selector:@selector(newGamePressed)];
        CCMenuItemImage *menu02 = [CCMenuItemImage itemWithNormalImage:@"menu02.png" selectedImage:@"menu02_hover.png" target:self selector:@selector(infoPressed)];
        
        CCMenu *menu = [CCMenu menuWithItems:menu01,menu02, nil];
        [menu alignItemsVerticallyWithPadding:15];
        menu.position = ccp(winSize.width/2,winSize.height - 200);
        [self addChild:menu];
        
        if (!IS_RETINA)
        {
            logoSprite.scale = 0.5;
            menu02.scale = 0.5;
            menu01.scale = 0.5;
        }
    }
    
    return self;
}

#pragma mark - Menu event pressed

- (void)newGamePressed
{
    CCScene *playerScene = [PlayerLayer scene];
    //CCTransitionFlipAngular *transition = [CCTransitionFlipAngular transitionWithDuration:0.5f scene:MonsterRunScene];
    CCTransitionMoveInR *transition = [CCTransitionMoveInR transitionWithDuration:0.5f scene:playerScene];
    [[CCDirector sharedDirector] replaceScene:transition];
}

- (void)infoPressed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Menu clicked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
