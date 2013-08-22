//
//  MenuLayer.m
//  Bejeweled2
//
//  Created by Toan.Quach on 8/20/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import "MenuLayer.h"
#import "MAPlayfieldLayer.h"

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
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"WoodRetroApple_iPad_HomeScreen.png" rect:CGRectMake(0, 0, winSize.width, winSize.height)];
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
        
        if (!IS_RETINA)
        {
            logoSprite.scale = 0.5;
            menu02.scale = 0.5;
            menu01.scale = 0.5;
        }
        
        if (IS_IPHONE_5)
        {
            menu.position = ccp(winSize.width/2,winSize.height - 200);
            [menu alignItemsVerticallyWithPadding:15];
        }
        else
        {
            menu.position = ccp(winSize.width/2,winSize.height - 250);
            [menu alignItemsVertically];
        }
        
        [self addChild:menu];
    }

    return self;
}

#pragma mark - Menu event pressed

- (void)newGamePressed
{
    CCScene *playerScene = [MAPlayfieldLayer scene];
    CCTransitionMoveInR *transition = [CCTransitionMoveInR transitionWithDuration:0.5f scene:playerScene];
    [[CCDirector sharedDirector] pushScene:transition];
}

- (void)infoPressed
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"Menu clicked" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertView show];
}

@end
