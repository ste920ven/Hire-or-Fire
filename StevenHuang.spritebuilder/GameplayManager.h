//
//  GameplayManager.h
//  StevenHuang
//
//  Created by Steven Huang on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameplayManager : NSObject

+(instancetype)sharedInstance;

@property (nonatomic) NSInteger level;
@property (assign) bool paused;
@property (assign) float roundCounter;
@property (assign) bool minigame;
@property (assign) bool submitted;

@end
