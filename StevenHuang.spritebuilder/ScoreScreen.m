//
//  scoreScreen.m
//  StevenHuang
//
//  Created by Steven Huang on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ScoreScreen.h"

@implementation ScoreScreen{
    
    CCLabelTTF *_moneyLabel,*_moneyEarnedLabel,*_scoreLabel,*_messageLabel,*_totalLabel;
}

-(void)setScreenWithScore:(int)score message:(NSString*)msg total:(int)total{
    _messageLabel.string=msg;
    _scoreLabel.string=[NSString stringWithFormat:@"Resumes Passed: %d",score];
    _totalLabel.string=[NSString stringWithFormat:@"Total Resumes: %d",total];
    
    int moneyEarned=score*5;
    _moneyEarnedLabel.string=[NSString stringWithFormat:@"Earned: $%d",moneyEarned];
    
    //update money
    NSInteger money = [[NSUserDefaults standardUserDefaults] integerForKey:@"money"];
    [[NSUserDefaults standardUserDefaults] setInteger:money+moneyEarned forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _moneyLabel.string=[NSString stringWithFormat:@"Total: $%d",moneyEarned+money];

}



@end
