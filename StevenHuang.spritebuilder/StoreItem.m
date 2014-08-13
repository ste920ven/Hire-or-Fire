//
//  StoreItem.m
//  StevenHuang
//
//  Created by Steven Huang on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StoreItem.h"

@implementation StoreItem{
    CCLabelTTF *_titleLabel,*_moneyLabel,*_money,*_selectedAmountLabel;
    CCSprite *_item,*_yesNode,*_checkboxNode;
    //CCNodeColor *_greybox;
}


-(void)setup:(CCLabelTTF*)money selected:(CCLabelTTF*)s{
    _money=money;
    _selectedAmountLabel=s;
}


-(void)didLoadFromCCB{
    _titleLabel.string=self.title;
    _moneyLabel.string=[NSString stringWithFormat:@"$%d",self.value];
    [self.animationManager runAnimationsForSequenceNamed:self.title];
    self.userInteractionEnabled=true;
    
//    noUnlocked=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"noUnlocked"]];
//    selectedAmountCount=[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"];
//    noSelected=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"]];
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"noUnlocked"] indexOfObject:self.title]!=NSNotFound){
        [self greyOut];
    }
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"] indexOfObject:self.title]!=NSNotFound)
        [self check:true];
}

-(bool)buy{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"money"]>=self.value){
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"money"]-self.value forKey:@"money"];
        NSMutableArray *noUnlocked=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"noUnlocked"]];
        [noUnlocked addObject:self.title];
        [[NSUserDefaults standardUserDefaults] setObject:noUnlocked forKey:@"noUnlocked"];
        return true;
    }else
        return false;
}

-(void)check:(bool)b{
    _yesNode.visible=b;
   _selectedAmountLabel.string=[NSString stringWithFormat:@"Selected: %d/3",[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"]];
}

-(void)greyOut{
    _moneyLabel.visible=false;
    _checkboxNode.visible=true;
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    
}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"noUnlocked"] indexOfObject:self.title]==NSNotFound){
        if([self buy]){
            [self greyOut];
            _money.string=[NSString stringWithFormat:@"$%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"money"] ];
            NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: self.title, @"item", nil];
            //[MGWU logEvent:@"itemBought" withParams:params];
        }
    }else{
        int selectedAmountCount=[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"];
        NSMutableArray *noSelected=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"]];
        if([noSelected indexOfObject:self.title]==NSNotFound){
            if(selectedAmountCount<3){
                [noSelected addObject:self.title];
                [self check:true];
                ++selectedAmountCount;
            }
        }
        else{
            if(selectedAmountCount>1){
                [noSelected removeObject:self.title];
                [self check:false];
                --selectedAmountCount;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:noSelected forKey:@"noSelected"];
        [[NSUserDefaults standardUserDefaults] setInteger:selectedAmountCount forKey:@"noNumber"];
            _selectedAmountLabel.string=[NSString stringWithFormat:@"Selected: %d/3",selectedAmountCount];
    }
}
@end
