//
//  RuleBook.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, RuleType){
    MAXAGE,
    MINAGE,
    NAME,
    ADDRESS,
    EDUCATION,
    PHONE,
    EXPERIENCE
};


@interface RuleBook : CCNode

@property (nonatomic,strong) NSArray* Leveldata;
@property (nonatomic,strong) NSDictionary *rules;
@property (nonatomic,strong) NSDictionary *specialRules;

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data;
@end
