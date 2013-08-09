//
//  GemLayer.h
//  Bejeweled
//
//  Created by Toan.Quach on 8/9/13.
//  Copyright 2013 Toan.Quach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GemLayer : CCNode {
    
}

@property(nonatomic, retain) NSString *gemName;
@property(nonatomic) int gemValue;
@property(nonatomic) int row;
@property(nonatomic) int col;

@end
