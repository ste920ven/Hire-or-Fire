//
//  scoreScreen.h
//  StevenHuang
//
//  Created by Steven Huang on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface ScoreScreen : CCNode

-(void)setScreenWithScore:(int)score message:(NSString*)msg total:(int)total;

@end
