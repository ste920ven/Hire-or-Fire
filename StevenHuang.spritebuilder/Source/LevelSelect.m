//
//  LevelSelect.m
//  StevenHuang
//
//  Created by Steven Huang on 7/9/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "LevelSelect.h"
#import "GameplayManager.h"
#import "LevelButton.h"

@implementation LevelSelect{
    CCNode *_container;
    NSArray* levels;
}

-(void)play1{
    [self play:0];
}
-(void)play2{
    [self play:1];
}
-(void)play3{
    [self play:2];
}
-(void)play4{
    [self play:3];
}
-(void)play5{
    [self play:4];
}
-(void)play6{
    [self play:5];
}
-(void)play7{
    [self play:6];
}
-(void)play8{
    [self play:7];
}
-(void)play9{
    [self play:8];
}
-(void)play10{
    [self play:9];
}

-(void)didLoadFromCCB{
    levels=[_container children];
    for(LevelButton* item in levels){
        ((CCButton*)[item children][0]).title=[NSString stringWithFormat:@"%d",item.level+1];
        if(item.level>[[NSUserDefaults standardUserDefaults] integerForKey:@"level"])
            ((CCButton*)[item children][0]).enabled=false;
    }
}

-(void)play:(int)level{
    
    [GameplayManager sharedInstance].level=level;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)openStore{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Store"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];

}

@end
