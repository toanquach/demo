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
        
        //[self schedule:@selector(renderGem) interval:.5];
        [self performSelector:@selector(renderGem) withObject:nil afterDelay:0.5];
        //  *************************************************
        //      Select Gem
        //
        selectedGem = nil;
        self.touchEnabled = YES;
    }
    
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
            
            //_locations[0][0] = 0;
            //_locations[0][1] = 0;
            //_locations[0][2] = 0;
            
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

    if (IS_IPHONE_5)
    {
        startY = 200;
    }
    else
    {
        startY = 155;
    }
    
    gemSpriteList = [[NSMutableArray alloc] init];
    //winSize.height - kGameAreaStartY;
    for(int i = 0; i < kRows; i++)
    {
        for(int j = 0; j < kCols; j++)
        {
            GemLayer *gem = gems[i][j];
            CCSprite *gemSprite = [CCSprite spriteWithFile:gem.gemName];
            gemSprite.tag = i*kRows + j;
            
            int x = i * kGem_Witdh + kGameAreaStartX;
            int y = (startY - kGem_Height + kGameAreaHeight) - j * kGem_Height - kGem_Height/2;
            gemSprite.position = ccp(x,y);
            [self addChild:gemSprite];
            [gemSpriteList addObject:gemSprite];
        }
    }
}

#pragma mark - back button

-(void) onBack:(id)sender
{
    //MenuLayer *menuLayer = [MenuLayer scene];
    [[CCDirector sharedDirector] popScene];
}

#pragma mark - Touch event

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    for (CCSprite *sprite in gemSpriteList)
    {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation))
        {
            NSLog(@"%d",sprite.tag);
            int row = sprite.tag/kRows;
            int col = sprite.tag%kRows;
            
            int x = row * kGem_Witdh + kGameAreaStartX;
            int y = (startY - kGem_Height + kGameAreaHeight) - col * kGem_Height - kGem_Height/2;
            CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
            if (focusSprite != nil)
            {
                [focusSprite removeFromParent];
                focusSprite = nil;
            }
            focusSprite = [CCSprite spriteWithFile:@"focus.png"];
            focusSprite.tag = kGame_FocusGem_Tag;
            focusSprite.position = ccp(x,y);
            [self addChild:focusSprite];
            
            // *********************************************
            //      Check focus gem
            //
            if (selectedGem == nil)
            {
                selectedGem = gems[row][col];
                
                [[SimpleAudioEngine sharedEngine] playEffect:@"select.wav"];
            }
            else
            {
                GemLayer *clickedGem = gems[row][col];
                if (selectedGem == clickedGem)
                {
                    selectedGem = nil;
                    CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
                    if (focusSprite != nil)
                    {
                        [focusSprite removeFromParent];
                        focusSprite = nil;
                    }
                }
                else
                {
                    // ***************************
                    //      check isNeighbor
                    //
                    if([clickedGem isNeighbor:selectedGem])
                    {
                        [self swapGem:clickedGem andGem:selectedGem];
                        selectedGem = nil;
                        CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
                        if (focusSprite != nil)
                        {
                            [focusSprite removeFromParent];
                            focusSprite = nil;
                        }
                    }
                    else
                    {
                        selectedGem = clickedGem;
                    }
                }
            }
        }
    }
}

- (void)swapGem:(GemLayer *)gem1 andGem:(GemLayer *)gem2
{
    int tag1 = gem1.row*kRows + gem1.col;
    int tag2 = gem2.row*kRows + gem2.col;
    CCSprite *sprite1 = (CCSprite *)[self getChildByTag:tag1];
    CCSprite *sprite2 = (CCSprite *)[self getChildByTag:tag2];
    
    int x1 = gem2.row * kGem_Witdh + kGameAreaStartX;
    int y1 = (startY - kGem_Height + kGameAreaHeight) - gem2.col * kGem_Height - kGem_Height/2;
    CCMoveTo *move1Action = [CCMoveTo actionWithDuration:0.1 position:ccp(x1,y1)];
    [sprite1 runAction:move1Action];
    sprite1.tag = tag2;
    
    int x2 = gem1.row * kGem_Witdh + kGameAreaStartX;
    int y2 = (startY - kGem_Height + kGameAreaHeight) - gem1.col * kGem_Height - kGem_Height/2;
    CCMoveTo *move2Action = [CCMoveTo actionWithDuration:0.1 position:ccp(x2,y2)];
    [sprite2 runAction:move2Action];
    sprite2.tag = tag1;
    
    GemLayer *gemT = [[GemLayer alloc] initWithGemLayer:gem2];
    gem2.row = gem1.row;
    gem2.col = gem1.col;
    gem2.gemName = gem1.gemName;
    gem2.gemValue = gem1.gemValue;
    
    gem1.row = gemT.row;
    gem1.col = gemT.col;
    gem1.gemName = gemT.gemName;
    gem1.gemValue = gemT.gemValue;
    
    gems[gem2.row][gem2.col] = gem2;
    gems[gem1.row][gem1.col] = gem1;
}

@end
