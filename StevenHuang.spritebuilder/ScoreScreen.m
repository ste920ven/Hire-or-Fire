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
    _scoreLabel.string=[NSString stringWithFormat:@"%d",score];
    _totalLabel.string=[NSString stringWithFormat:@"%d",total];
}



@end
