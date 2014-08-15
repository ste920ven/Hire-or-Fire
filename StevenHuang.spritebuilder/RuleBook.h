//
//  RuleBook.h
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"

typedef NS_ENUM(NSInteger, RuleType){
    //0-99 normal, 100-199 special yes, 200-299 special no
    
    EDUCATION,          //0
    PHONE,              //1
    EXPERIENCE_FIELD,   //2  no 3
    EXPERIENCE_JOB,     //3  no 2
    EXPERIENCE_LOCATION,//4
    ADDRESS_TYPE,       //5
    EDUCATION_LEVEL,     //6
    EXPERIENCE_LENGTH,   //7
    ACTIVITIES          //8
};

typedef NS_ENUM(NSInteger, Page){
    RULES,
    TUTORIAL,
    MINIGAME_TUTORIAL
};

#define ADDRESS_NUM_SIZE 1500
#define ADDRESS_BODY_SIZE 50
#define ADDRESS_END_SIZE 3
#define FIRSTNAME_SIZE 200
#define LASTNAME_SIZE 200
#define BIRTHDAY_RANGE 60
#define SCHOOL_SIZE 14
#define EXPERIENCE_SIZE 7
#define LOCATION_SIZE 9
#define EXPERIENCE_LENGTH_MAX 5
#define ACTIVITIES_SIZE 192

@interface RuleBook : CCSprite

@property (nonatomic,strong) NSArray* Leveldata;
@property (nonatomic,strong) NSMutableDictionary *rules;
@property (nonatomic,strong) NSMutableDictionary *specialRules;
@property (assign)int currPage;
@property (assign)bool rulesRead;

-(void)createRulesWithLevel:(int)level resumeData:(NSDictionary*)data;
-(void)show:(bool)b;
@end
