//
//  noChoice.m
//  StevenHuang
//
//  Created by Steven Huang on 8/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "noChoice.h"

@implementation noChoice

-(void)didLoadFromCCB{
    self.userInteractionEnabled=true;
}

-(void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
        [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
        [self.animationManager runAnimationsForSequenceNamed:@"selected"];
}

-(void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
}

@end
