//
//  Resume.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Resume.h"
#import "RuleBook.h"

@implementation Resume{
    NSString *phoneNumber;
    NSString *education;
    NSDictionary *experience;
    NSInteger age;
    NSString *name;
    NSInteger birthdate;
    NSString *birthmonth;
    NSInteger birthyear;
    NSString * address;
    
    int correctFactor;
    RuleBook * rulebook;
    NSDictionary* root;
    NSDateComponents* now;
    CCLabelTTF *_nameLabel,*_addressLabel,*_birthdateLabel,*_phoneNumberLabel,*_experiencesLabel,*_educationLabel;
}

#define ADDRESS_NUM_SIZE 1500
#define ADDRESS_BODY_SIZE 50
#define ADDRESS_END_SIZE 3
#define FIRSTNAME_SIZE 200
#define LASTNAME_SIZE 200
#define BIRTHDAY_RANGE 60
#define SCHOOL_SIZE 14

-(void)setup:(NSDateComponents*)_now rootDir:(NSDictionary*)_root rules:(CCNode *)_rules{
    
#pragma mark TODO temp
    correctFactor=10000;
    
    self.correctCount=0;
    self.totalCount=0;
    now=_now;
    root=_root;
    rulebook=(RuleBook*)_rules;
}

-(void)createDay:(int) maxDays{
    birthdate=arc4random_uniform(maxDays+1);
}

-(void)createNew{
    self.zOrder=1;
    
    //increment total counter
    ++self.totalCount;
    
    //generate random school
    education=[NSString stringWithFormat:@"%@ Univeristy",root[@"Schools"][arc4random_uniform(SCHOOL_SIZE) ]];
    
    //generate random phone number
    
    phoneNumber=[NSString stringWithFormat:@"%.3d-%.3d-%.4d",arc4random_uniform(1000),arc4random_uniform(1000),arc4random_uniform(10000)];
    
    //generate random address
    address=[NSString stringWithFormat:@"%d %@ %@",arc4random_uniform(ADDRESS_NUM_SIZE+1),root[@"Address1"][arc4random_uniform(ADDRESS_BODY_SIZE)]
             ,root[@"Address2"][arc4random_uniform(ADDRESS_END_SIZE)]];
    
    //generate random name
    name=[NSString stringWithFormat:@"%@ %@",root[@"firstNames"][arc4random_uniform(FIRSTNAME_SIZE)]
          ,root[@"lastNames"][arc4random_uniform(LASTNAME_SIZE)] ];
    
    //    //generate random gender
    //    int gender=arc4random_uniform()%2;
    //    if(gender)
    //        self.male=true;
    
    //generate random birthday
    NSInteger year = [now year];
    birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE+5));
    int month=arc4random_uniform(12);
    switch(month){
        case 0:
            birthmonth=@"January";
            [self createDay:31];
            break;
        case 1:
            birthmonth=@"February";
            [self createDay:28];
            break;
        case 2:
            birthmonth=@"March";
            [self createDay:31];
            break;
        case 3:
            birthmonth=@"April";
            [self createDay:30];
            break;
        case 4:
            birthmonth=@"May";
            [self createDay:31];
            break;
        case 5:
            birthmonth=@"June";
            [self createDay:30];
            break;
        case 6:
            birthmonth=@"July";
            [self createDay:31];
            break;
        case 7:
            birthmonth=@"August";
            [self createDay:31];
            break;
        case 8:
            birthmonth=@"September";
            [self createDay:30];
            break;
        case 9:
            birthmonth=@"October";
            [self createDay:31];
            break;
        case 10:
            birthmonth=@"Novemeber";
            [self createDay:30];
            break;
        case 11:
            birthmonth=@"December";
            [self createDay:31];
            break;
    }
    
    //calculate age
    age=year-birthyear;
    if([now month]==month+1){
        if([now day]<birthdate)
            --age;
    }else if([now month]<month)
        --age;
    
    //choose if resume will be correct or incorrect
    if(arc4random_uniform(10000)>correctFactor){
        self.correct=false;
    }else{
        self.correct=true;
        ++self.correctCount;
    }
    
    //apply rules
    int wrongRuleIndex;
    if(self.correct)
        wrongRuleIndex=INT_MAX;
    else{
        int numRules = [rulebook.rules count];
        wrongRuleIndex = arc4random_uniform(numRules);
    }
    int i=0;
    for(NSString* rule in rulebook.rules){
        bool wrong=false;
        if(i==wrongRuleIndex)
            wrong=true;
        switch ([rulebook.rules[rule] intValue]) {
            case MAXAGE:
                if(wrong){
                    if(age>[rule intValue])
                        birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE-[rule intValue]-5)+[rule intValue]);
                }else if(age>[rule intValue])
                    birthyear=year-(arc4random_uniform([rule intValue]-5)+5);
                break;
            case MINAGE:
                if(wrong){
                    if(age>[rule intValue])
                        birthyear=year-(arc4random_uniform([rule intValue]-5)+5);
                }else if(age>[rule intValue])
                    birthyear=year-(arc4random_uniform(BIRTHDAY_RANGE-[rule intValue]-5)+[rule intValue]);
                break;
            case NAME:
                break;
            case ADDRESS:
                break  ;
            case EDUCATION:
                if(wrong){
                    while([education rangeOfString:rule].location != NSNotFound)
                        education=[NSString stringWithFormat:@"%@ Univeristy",root[@"Schools"][arc4random_uniform(SCHOOL_SIZE) ]];
                }else if([education rangeOfString:rule].location == NSNotFound)
                    education=[NSString stringWithFormat:@"%@ Univeristy",rule];
                break;
            case PHONE:
                if(wrong){
                    while([phoneNumber rangeOfString:rule].location == 0)
                        phoneNumber=[NSString stringWithFormat:@"%.3d-%.3d-%.4d",arc4random_uniform(1000),arc4random_uniform(1000),arc4random_uniform(10000)];
                }else if([phoneNumber rangeOfString:rule].location != 0)
                    phoneNumber=[NSString stringWithFormat:@"%@-%.3d-%.4d",rule,arc4random_uniform(1000),arc4random_uniform(10000)];
                break;
            case EXPERIENCE:
                break;
        }
        ++i;
    }
    
    //display all info
    _birthdateLabel.string=[NSString stringWithFormat:@"%@ %d, %d",birthmonth,birthdate,birthyear];
    _nameLabel.string=name;
    _addressLabel.string=address;
    _phoneNumberLabel.string=phoneNumber;
    _educationLabel.string=education;
    
    _experiencesLabel.string=[NSString stringWithFormat:@"%d",self.correct];
    
    //move new resume to position
    self.position=ccp(.6,.5);
    
}



@end
