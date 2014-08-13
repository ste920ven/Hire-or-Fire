//
//  StoreScreen.m
//  StevenHuang
//
//  Created by Steven Huang on 7/20/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StoreScreen.h"
#import "StoreItem.h"

@implementation StoreScreen{
    CCLabelTTF *_money,*_selectedAmountLabel;
    CCScrollView *_scrollView;
    NSArray * noOptions;
}

-(void)levelSelect{
    [[OALSimpleAudio sharedInstance] playBg:@"Assets/click1.wav"];
    //save defaults
    [[NSUserDefaults standardUserDefaults] synchronize];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:.3f]];
}

-(void)didLoadFromCCB{
    //reset unlocked defaults
//    [[NSUserDefaults standardUserDefaults] setObject:[[NSArray alloc]init] forKey:@"noSelected"];
//    [[NSUserDefaults standardUserDefaults] setObject:[[NSArray alloc]init] forKey:@"noUnlocked"];
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"noNumber"];
    [[NSUserDefaults standardUserDefaults] setInteger:1000 forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    noOptions=[[_scrollView contentNode] children];
    
    for(StoreItem* item in noOptions){
        [item setup:_money selected:_selectedAmountLabel];
    }
    
    _selectedAmountLabel.string=[NSString stringWithFormat:@"Selected: %d/3",[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"]];
     _money.string=[NSString stringWithFormat:@"$%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"money"] ];
}

@end
