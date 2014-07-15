//
//  RuleBook.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, RuleType){
    MAXAGE,     //0
    MINAGE,     //1
    NAME,       //2
    ADDRESS,    //3
    EDUCATION,  //4
    PHONE,      //5
    EXPERIENCE, //6
    ADDRESS_TYPE,//7
    EDUCATION_LEVEL //8
};


@interface RuleBook : CCNode

@property (nonatomic,strong) NSArray* Leveldata;
@property (nonatomic,strong) NSDictionary *rules;
@property (nonatomic,strong) NSDictionary *specialRules;

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data;
@end
