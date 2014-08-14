//
//  scoreScreen.m
//  StevenHuang
//
//  Created by Steven Huang on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ScoreScreen.h"
#import "GameplayManager.h"

@implementation ScoreScreen{
    CCLabelTTF *_moneyLabel,*_moneyEarnedLabel,*_messageLabel,*_totalLabel,*_correctLabel;
    CCButton *_nextLevelButton;
}

-(void)setScreenWithScore:(int)score message:(bool)msg total:(int)total correct:(int)correct{
    if(msg){
    _messageLabel.string=@"Level Passed";
    }else{
        _messageLabel.string=@"Level Failed";
            [_nextLevelButton setTarget:self selector:@selector(replay)];
            _nextLevelButton.title=@"Replay";
    }

    _totalLabel.string=[NSString stringWithFormat:@"Total Resumes: %d",total];
    _correctLabel.string=[NSString stringWithFormat:@"Correct Resumes: %d",correct];
    
    int moneyEarned=score;
    _moneyEarnedLabel.string=[NSString stringWithFormat:@"Earned: $%d",moneyEarned];
    
    //update money
    NSInteger money = [[NSUserDefaults standardUserDefaults] integerForKey:@"money"];
    [[NSUserDefaults standardUserDefaults] setInteger:money+moneyEarned forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _moneyLabel.string=[NSString stringWithFormat:@"Total: $%d",moneyEarned+money];
}

-(void) nextLevel{
     [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    if([GameplayManager sharedInstance].level==9){
        CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
        [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }else{
    [GameplayManager sharedInstance].level++;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
    }
}

-(void) replay{
     [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)LevelSelect{
     [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:.5f]];
}

@end
