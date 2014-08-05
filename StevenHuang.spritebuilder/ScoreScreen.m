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
    CCLabelTTF *_moneyLabel,*_moneyEarnedLabel,*_scoreLabel,*_messageLabel,*_totalLabel,*_correctLabel;
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
    //_scoreLabel.string=[NSString stringWithFormat:@"Total score: %d",score];
    _scoreLabel.string=@"";
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
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)LevelSelect{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
