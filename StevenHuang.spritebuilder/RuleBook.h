//
//  RuleBook.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, RuleType){
    YOUNGAGE,
    OLDAGE,
    NAME,
    ADDRESS,
    EDUCATION,
    PHONE,
    EXPERIENCE
};


@interface RuleBook : CCNode

@property (nonatomic,strong) NSArray* Leveldata;


-(void)createRulesWithLevel:(int)level;
@end
