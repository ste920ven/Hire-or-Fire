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
    CCNode *_worldNode;
    NSMutableArray*noUnlocked,*noSelected;
    NSArray * noOptions;
    int selectedAmountCount;
}

-(void)levelSelect{
    //save defaults
    [[NSUserDefaults standardUserDefaults] setObject:noUnlocked forKey:@"noUnlocked"];
    [[NSUserDefaults standardUserDefaults] setObject:noSelected forKey:@"noSelected"];
    [[NSUserDefaults standardUserDefaults] setInteger:selectedAmountCount forKey:@"noNumber"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    CCScene *gameplayScene = [CCBReader loadAsScene:@"LevelSelect"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

-(void)didLoadFromCCB{
    self.userInteractionEnabled = TRUE;
    
    //reset unlocked defaults
//    [[NSUserDefaults standardUserDefaults] setObject:[[NSArray alloc]init] forKey:@"noSelected"];
//    [[NSUserDefaults standardUserDefaults] setObject:[[NSArray alloc]init] forKey:@"noUnlocked"];
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"noNumber"];
//    [[NSUserDefaults standardUserDefaults] setInteger:1000 forKey:@"money"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    noOptions=[[_scrollView contentNode] children];
    noUnlocked=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults]objectForKey:@"noUnlocked"]];
    selectedAmountCount=[[NSUserDefaults standardUserDefaults] integerForKey:@"noNumber"];
    noSelected=[NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"noSelected"]];
    
    for(StoreItem* item in noOptions){
        if([noUnlocked indexOfObject:item.title]!=NSNotFound){
            [item greyOut];
        }
        if([noSelected indexOfObject:item.title]!=NSNotFound)
            [item check:true];
    }
    
    _money.string=[NSString stringWithFormat:@"$%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"money"] ];
    _selectedAmountLabel.string=[NSString stringWithFormat:@"%d/3",selectedAmountCount];
}

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event{

}

-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    CGPoint touchLocation = [touch locationInNode:_scrollView];
    //CGRect rect=[_scrollView boundingBox];
    CGPoint newtouchLocation=ccp(touchLocation.x,_scrollView.contentSizeInPoints.height-touchLocation.y);
    for(StoreItem* item in noOptions){
        NSString *str=[NSString stringWithFormat:@"{{%f,%f},{%f,%f}}",item.position.x,item.position.y,item.contentSize.width,item.contentSize.height];
        CGRect r=CGRectFromString(str);
        if(CGRectContainsPoint(r, newtouchLocation)){
            if([noUnlocked indexOfObject:item.title]==NSNotFound){
                if([item buy]){
                    [item greyOut];
                    [noUnlocked addObject:item.title];
                    [[NSUserDefaults standardUserDefaults] setObject:noUnlocked forKey:@"noUnlocked"];
                    _money.string=[NSString stringWithFormat:@"$%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"money"] ];
                    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: item.title, @"item", nil];
                    [MGWU logEvent:@"itemBought" withParams:params];
                }
            }else{
                if([noSelected indexOfObject:item.title]==NSNotFound){
                    if(selectedAmountCount<3){
                        [noSelected addObject:item.title];
                        [item check:true];
                        ++selectedAmountCount;
                    }
                }
                else{
                    if(selectedAmountCount>1){
                        [noSelected removeObject:item.title];
                        [item check:false];
                        --selectedAmountCount;
                    }
                }
            }
            _selectedAmountLabel.string=[NSString stringWithFormat:@"%d/3",selectedAmountCount];
            break;
        }
    }
}

@end
