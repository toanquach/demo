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
            GemLayer *gem = [self randomGem:i andCol:j];
            gems[i][j] = gem;
        }
    }
    
    chains = [[NSMutableArray alloc] init];
}

- (GemLayer *)randomGem:(int)row andCol:(int)col
{
    GemLayer *gem = [[GemLayer alloc] init];
    gem.row = row;
    gem.col = col;
    gem.gemValue = arc4random()%kNumGems;
    
    if (row == 0 && col == 1)
    {
        gem.gemValue = 0;
    }
    switch (gem.gemValue)
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
    
    return gem;
}

-(void) renderGem
{
    if (IS_IPHONE_5)
    {
        startY = 200;
    }
    else
    {
        startY = 155;
    }
    
    gemSpriteList = [[NSMutableArray alloc] init];
    for(int i = 0; i < kRows; i++)
    {
        for(int j = 0; j < kCols; j++)
        {
            GemLayer *gem = gems[i][j];
            CCSprite *gemSprite = [CCSprite spriteWithFile:gem.gemName];
            gemSprite.tag = i*kRows + j;
            
            int x = i * kGem_Witdh + kGameAreaStartX;
            int y = kGameAreaStartY - j*kGem_Height;
            
            gemSprite.position = ccp(x,y);
            [self addChild:gemSprite];
            [gemSpriteList addObject:gemSprite];
        }
    }
    
    //[self performSelector:@selector(performIsStable) withObject:nil afterDelay:2.0];
}

- (void)performIsStable
{
    while (![self isStable])
    {
        [self rmChains];
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
    // *************************************************************
    //      Check collision between touchPoint with list gem
    //
    for (CCSprite *sprite in gemSpriteList)
    {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation))
        {
            int row = sprite.tag/kRows;
            int col = sprite.tag%kRows;
            
            int x = row * kGem_Witdh + kGameAreaStartX;
            int y = (startY - kGem_Height + kGameAreaHeight) - col * kGem_Height - kGem_Height/2;
            
            // ************************************
            //      if it have selected gem
            //
            CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
            if (focusSprite != nil)
            {
                [focusSprite removeFromParent];
                focusSprite = nil;
            }
            
            // *************************************
            //      Add new gem selected
            //
            focusSprite = [CCSprite spriteWithFile:@"focus.png"];
            focusSprite.tag = kGame_FocusGem_Tag;
            focusSprite.position = ccp(x,y);
            [self addChild:focusSprite];
            
            // *************************************
            //      Play sound select gem
            //
            [[SimpleAudioEngine sharedEngine] playEffect:@"select.wav"];
            
            // *********************************************
            //      Check focus gem
            //
            if (selectedGem == nil)
            {
                selectedGem = gems[row][col];
            }
            else
            {
                GemLayer *clickedGem = gems[row][col];
                if (selectedGem == clickedGem)
                {
                    // ********************************************
                    //      if click on current selected gem
                    //
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
                        
                        // ***********************************
                        //  if swap have chain
                        //
                        if ([self updateGame] == NO)
                        {
                            
                        }
                        else
                        {
                            [self swapGem:clickedGem andGem:selectedGem];
                        }
                        
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

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (selectedGem != nil)
    {
        int tag = -1;
        int mCol = selectedGem.col + 1;
        if (mCol < 8)
        {
            tag = selectedGem.row * kRows + mCol;
            CCSprite *neighborGem = (CCSprite *)[self getChildByTag:tag];
            if (neighborGem)
            {
                if (CGRectContainsPoint(neighborGem.boundingBox, touchLocation))
                {
                    GemLayer *swapGem = gems[selectedGem.row][mCol];
                    [self swapGem:swapGem andGem:selectedGem];
                    selectedGem = nil;
                    CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
                    if (focusSprite != nil)
                    {
                        [focusSprite removeFromParent];
                        focusSprite = nil;
                    }
                }
            }
        }
        
        mCol = selectedGem.col - 1;
        if (mCol >= 0)
        {
            tag = selectedGem.row * kRows + mCol;
            CCSprite *neighborGem = (CCSprite *)[self getChildByTag:tag];
            if (neighborGem)
            {
                if (CGRectContainsPoint(neighborGem.boundingBox, touchLocation))
                {
                    GemLayer *swapGem = gems[selectedGem.row][mCol];
                    [self swapGem:swapGem andGem:selectedGem];
                    selectedGem = nil;
                    CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
                    if (focusSprite != nil)
                    {
                        [focusSprite removeFromParent];
                        focusSprite = nil;
                    }
                }
            }
        }
        
        int mRow = selectedGem.row + 1;
        if (mRow < 8)
        {
            tag = mRow * kRows + selectedGem.col;
            CCSprite *neighborGem = (CCSprite *)[self getChildByTag:tag];
            if (neighborGem)
            {
                if (CGRectContainsPoint(neighborGem.boundingBox, touchLocation))
                {
                    GemLayer *swapGem = gems[mRow][selectedGem.col];
                    [self swapGem:swapGem andGem:selectedGem];
                    selectedGem = nil;
                    CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
                    if (focusSprite != nil)
                    {
                        [focusSprite removeFromParent];
                        focusSprite = nil;
                    }
                }
            }
        }
        
        mRow = selectedGem.row - 1;
        if (mRow >= 0)
        {
            tag = mRow * kRows + selectedGem.col;
            CCSprite *neighborGem = (CCSprite *)[self getChildByTag:tag];
            if (neighborGem)
            {
                if (CGRectContainsPoint(neighborGem.boundingBox, touchLocation))
                {
                    GemLayer *swapGem = gems[mRow][selectedGem.col];
                    [self swapGem:swapGem andGem:selectedGem];
                    selectedGem = nil;
                    CCSprite *focusSprite = (CCSprite *)[self getChildByTag:kGame_FocusGem_Tag];
                    if (focusSprite != nil)
                    {
                        [focusSprite removeFromParent];
                        focusSprite = nil;
                    }
                }
            }
        }
    }
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

#pragma mark - Utils
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

- (BOOL)updateGame
{
    if (![self isStable])
    {
        [self markDeleted];
        [self calculateDrop];

        //animation.setType(Animation.animType.CASCADE);
        //animation.animateCascade();
        [[SimpleAudioEngine sharedEngine] playEffect:@"fall.wav"];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)isStable
{
    [self checkColumns];
    [self checkRows];
    
    if ([chains count] > 0)
    {
        return NO;
    }
    
    return YES;
}

- (void)rmChains
{
    [self markDeleted];
    [self calculateDrop];
    [self applyDrop];
    [self fillEmpty];
    [self endCascade];
}

- (void)markDeleted
{
    int combo = 0;
    int score = 0;
    for (int i=0; i < [chains count]; i++)
    {
        NSMutableArray *arr = [chains objectAtIndex:i];
        combo += [arr count];
        score += [arr count]*10;
        for (int j=0; j < [arr count]; j++)
        {
            GemLayer *gem = [arr objectAtIndex:j];
            gem.gemValue = -1;
            CCSprite *sprite = (CCSprite *)[self getChildByTag:gem.row*kRows + gem.col];
            if (sprite != nil)
            {
                [sprite removeFromParent];
                sprite = nil;
            }
        }
        
    }
    [chains removeAllObjects];
    
    //game.addScore(score);
    //game.setCombo(combo);
}

- (void)calculateDrop
{
    int row,col,temp;
    
    for (col=0;col<8;col++)
    {
        for (row=7;row>=0;row--)
        {
            GemLayer *bottom = gems[row][col];
            bottom.beforeDrop = row;
            if(bottom.gemValue == -1)
            {
                for(temp = row-1; temp >= 0;temp--)
                {
                    GemLayer *above = gems[temp][col];
                    above.willDrop = true;
                    above.dropDistance++;
                }
            }
        }
    }
}

- (void)applyDrop
{
    int row,col;
    for(col = 0; col < 8; ++col)
    {
        for(row = 7; row >= 0; --row)
        {
            GemLayer *tile = gems[row][col];
            if(tile.willDrop && tile.gemValue != -1)
            {
                //gameBoard.putTileAt(row+tile.dropDistance, col, tile);
                gems[row+tile.dropDistance][col] = tile;
                //tile.setAnimCol(col);
                
                int tag1 = tile.row*kRows + tile.col;
                CCSprite *sprite1 = (CCSprite *)[self getChildByTag:tag1];
                int x1 = tile.row * kGem_Witdh + kGameAreaStartX;
                int y1 = (startY - kGem_Height + kGameAreaHeight) - tile.col * kGem_Height - kGem_Height/2;
                CCMoveTo *move1Action = [CCMoveTo actionWithDuration:0.1 position:ccp(x1,y1)];
                [sprite1 runAction:move1Action];
                sprite1.tag = tag1;
                
                //gameBoard.putTileAt(row, col, new Tile(Tile.tileID.DELETED,row,col));
                gems[row][col] = [[GemLayer alloc] initWithGemValue:-1 andRow:row andCol:col];
            }
        }
    }
}

- (void)fillEmpty
{
    int row,col;
    for (row=0;row<8;row++)
    {
        for (col=0;col<8;col++)
        {
            GemLayer *tile = gems[row][col];
            if (tile.gemValue == -1)
            {
                GemLayer *randTile = [self randomGem:row andCol:col];
                gems[row][col] = randTile;
            }
        }
    }
}

- (void)endCascade
{
    int row,col;
    for (row=0;row<8;row++)
    {
        for (col=0;col<8;col++)
        {
            GemLayer *tile = gems[row][col];
            tile.beforeDrop = col;
            tile.dropDistance = 0;
            tile.willDrop = false;
        }
    }
}



- (void)checkColumns
{
    int row,col,tmp;
    for(col = 0; col < 8; col++)
    {
        for(row= 0; row < 6; row++)
        {
            GemLayer *start = gems[row][col];
            NSMutableArray *chain = [[NSMutableArray alloc] initWithCapacity:5];
            [chain addObject:start];
            for (tmp=(row+1);tmp<8;tmp++)
            {
                GemLayer *next = gems[tmp][col];
                if (next.gemValue == start.gemValue)
                {
                    [chain addObject:next];
                }
                else
                {
                    break;
                }
            }
            
            if ([chain count] > 2)
                [chains addObject:chain];
            row = tmp - 1;
        }
    }
}

- (void)checkRows
{
    int row,col,tmp;
    
    for(row = 0; row < 8; row++)
    {
        for(col= 0; col < 6; col++)
        {
            GemLayer *start = gems[row][col];
            NSMutableArray *chain = [[NSMutableArray alloc] initWithCapacity:5];
            [chain addObject:start];
            for (tmp=(col+1);tmp<8;tmp++)
            {
                GemLayer *next = gems[row][tmp];
                if (next.gemValue == start.gemValue)
                {
                    [chain addObject:next];
                }
                else
                {
                    break;
                }
            }
            if ([chain count] > 2)
                [chains addObject:chain];
            col = tmp - 1;
        }
    }
}
@end
