//
//  PlayerLayer.h
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PlayerLayer : CCLayer {
    
    int _localtions[kRows][kCols];
}

+(CCScene *) scene;

@end
