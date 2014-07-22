//
//  StoreItem.m
//  StevenHuang
//
//  Created by Steven Huang on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "StoreItem.h"

@implementation StoreItem{
    CCLabelTTF *_titleLabel,*_moneyLabel;
    CCSprite *_item,*_yesNode;
    CCNodeColor *_greybox;
}


-(void)didLoadFromCCB{
    _titleLabel.string=self.title;
    _moneyLabel.string=[NSString stringWithFormat:@"%d",self.value];
    [self.animationManager runAnimationsForSequenceNamed:self.title];
}

-(bool)buy{
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"money"]>=self.value){
        [[NSUserDefaults standardUserDefaults] setInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"money"]-self.value forKey:@"money"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return true;
    }else
        return false;
}

-(void)check:(bool)b{
    _yesNode.visible=b;
}

-(void)greyOut{
    _greybox.visible=true;
}


@end
