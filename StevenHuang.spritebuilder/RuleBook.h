//
//  RuleBook.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

typedef NS_ENUM(NSInteger, RuleType){
    MAXAGE,             //0
    MINAGE,             //1
    NAME,               //2
    ADDRESS,            //3
    EDUCATION,          //4
    PHONE,              //5
    EXPERIENCE_FIELD,   //6
    EXPERIENCE_JOB,     //7
    EXPERIENCE_LOCATION,//8
    ADDRESS_TYPE,       //9
    EDUCATION_LEVEL,     //10
    EXPERIENCE_LENGTH   //11
};

#define ADDRESS_NUM_SIZE 1500
#define ADDRESS_BODY_SIZE 50
#define ADDRESS_END_SIZE 3
#define FIRSTNAME_SIZE 200
#define LASTNAME_SIZE 200
#define BIRTHDAY_RANGE 60
#define SCHOOL_SIZE 14
#define EXPERIENCE_SIZE 3
#define LOCATION_SIZE 4
#define EXPERIENCE_LENGTH_MAX 5

@interface RuleBook : CCNode

@property (nonatomic,strong) NSArray* Leveldata;
@property (nonatomic,strong) NSMutableDictionary *rules;
@property (nonatomic,strong) NSMutableDictionary *specialRules;

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data;
-(void)show:(bool)b;
@end
