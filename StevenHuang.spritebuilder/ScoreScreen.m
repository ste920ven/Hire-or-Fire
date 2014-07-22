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

-(void)setScreenWithScore:(int)score message:(NSString*)msg total:(int)total correct:(int)correct{
    _messageLabel.string=msg;
    _scoreLabel.string=[NSString stringWithFormat:@"Resumes Passed: %d",score];
    _totalLabel.string=[NSString stringWithFormat:@"Total Resumes: %d",total];
    _correctLabel.string=[NSString stringWithFormat:@"Correct Resumes: %d",correct];
    
    int moneyEarned=score*5;
    _moneyEarnedLabel.string=[NSString stringWithFormat:@"Earned: $%d",moneyEarned];
    
    //update money
    NSInteger money = [[NSUserDefaults standardUserDefaults] integerForKey:@"money"];
    [[NSUserDefaults standardUserDefaults] setInteger:money+moneyEarned forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _moneyLabel.string=[NSString stringWithFormat:@"Total: $%d",moneyEarned+money];
    
    [_nextLevelButton setTarget:self selector:@selector(nextLevel)];
}

-(void) nextLevel{
    [GameplayManager sharedInstance].level++;
    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)LevelSelect{
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
