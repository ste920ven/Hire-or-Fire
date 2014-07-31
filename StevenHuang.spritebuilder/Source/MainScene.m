//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

- (void)play {
    
    [[CCDirector sharedDirector]setDisplayStats:true];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"noUnlocked"]==nil){
        [[NSUserDefaults standardUserDefaults] setObject:@[@"shredder"] forKey:@"noUnlocked"];
    }
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"noSelected"]==nil){
        [[NSUserDefaults standardUserDefaults] setObject:@[@"shredder"] forKey:@"noSelected"];
    }
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
