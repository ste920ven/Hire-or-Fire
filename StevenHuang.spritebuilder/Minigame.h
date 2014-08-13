//
//  Minigame.h
//  StevenHuang
//
//  Created by Steven Huang on 7/23/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface Minigame : CCNode

-(void)setGame:(CCNode*)node code:(int)i multiplier:(int)n;
-(int)getScore;

@end
