//
//  PlayerLayer.m
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import "PlayerLayer.h"
#import "MenuLayer.h"

@implementation PlayerLayer

@synthesize level;

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
        // **************************************************
        //      Add background image
        //
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"Screenshot 2013.08.09 14.24.31.png"];
        backgroundImage.position = ccp(winSize.width/2,winSize.height/2);
        [self addChild:backgroundImage z:-2];
        
        
        if (!IS_RETINA)
        {
            backgroundImage.scale = 0.5;
        }
        
        [self initGame];
        
        // *************************************************
        //      Add back button
        //
         CCMenuItemFont *backMenu = [[CCMenuItemFont alloc]initWithString:@"Back" target:self selector:@selector(onBack:)];
        
        CCMenu *menu = [CCMenu menuWithItems:backMenu, nil];
        menu.position = ccp(winSize.width/2, 100);
        [self addChild:menu];
        
        [self schedule:@selector(renderGem) interval:.5];
        
    }
    //self.isTouchEnabled = YES;
    return self;
}

-(void) initGame
{
    // 1
    self.level = 1;
    // 2
    for(int i = 0; i < kRows; i++)
    {
        for(int j = 0; j < kCols; j++)
        {
            _locations[i][j] = arc4random()%kNumGems;
            GemLayer *gem = [[GemLayer alloc] init];
            gem.row = i;
            gem.col = j;
            gem.gemValue = _locations[i][j];
            switch (_locations[i][j])
            {
                case kGem_White:
                    gem.gemName = kGem_White_FileName;
                    break;
                case kGem_Green:
                    gem.gemName = kGem_Green_FileName;
                    break;
                case kGem_Yellow:
                    gem.gemName = kGem_Yellow_FileName;
                    break;
                case kGem_Red:
                    gem.gemName = kGem_Red_FileName;
                    break;
                case kGem_Purple:
                    gem.gemName = kGem_Purple_FileName;
                    break;
                case kGem_Orange:
                    gem.gemName = kGem_Orange_FileName;
                    break;
                case kGem_Blue:
                    gem.gemName = kGem_Blue_FileName;
                    break;
                default:
                    break;
            }
            gems[i][j] = gem;
        }
    }
}

-(void) renderGem
{
    //CGSize winSize = [CCDirector sharedDirector].winSize;
    int startY = 0;
    if (IS_IPHONE_5)
    {
        startY = 200;
    }
    else
    {
        startY = 155;
    }
    
    //winSize.height - kGameAreaStartY;
    for(int i = 0; i < kRows; i++)
    {
        for(int j = 0; j < kCols; j++)
        {
            GemLayer *gem = gems[i][j];
            CCSprite *gemSprite = [CCSprite spriteWithFile:gem.gemName];
            int x = i * kGem_Witdh + kGameAreaStartX;
            int y = (startY - kGem_Height + kGameAreaHeight) - j * kGem_Height - kGem_Height/2;
            gemSprite.position = ccp(x,y);
            [self addChild:gemSprite];
        }
    }
}

#pragma mark - back button

-(void)onBack:(id)sender
{
    //MenuLayer *menuLayer = [MenuLayer scene];
    [[CCDirector sharedDirector] popScene];
}

@end
