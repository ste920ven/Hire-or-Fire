//
//  Resume.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Resume.h"

@implementation Resume

#define ADDRESS_NUM_SIZE 1500
#define ADDRESS_BODY_SIZE 50
#define ADDRESS_END_SIZE 3
#define FIRSTNAME_SIZE 200
#define LASTNAME_SIZE 200
#define BIRTHDAY_RANGE 60

-(id)initWithCurrentDate:(NSDateComponents*)now rootDir:(NSDictionary*)root{
    self=[super init];
    if(self){
        //generate random address
        self.address=[NSString stringWithFormat:@"%d %@ %@",arc4random()%ADDRESS_BODY_SIZE,root[@"Address1"][arc4random()%ADDRESS_BODY_SIZE]
                      ,root[@"Address2"][arc4random()%ADDRESS_END_SIZE]];
        
        //generate random name
        self.name=[NSString stringWithFormat:@"%@ %@",root[@"firstNames"][arc4random()%FIRSTNAME_SIZE]
                      ,root[@"lastNames"][arc4random()%LASTNAME_SIZE] ];
        
        //generate random gender
        int gender=arc4random()%2;
        if(gender)
            self.male=true;
        
        //generate random birthday
        NSInteger year = [now year];
         self.birthyear=year-(arc4random()%BIRTHDAY_RANGE+5);
        int month=arc4random()%12;
        switch(month){
            case 0:
                self.birthmonth=@"January";
                [self createDay:31];
            case 1:
                self.birthmonth=@"February";
                [self createDay:28];
            case 2:
                self.birthmonth=@"March";
                [self createDay:31];
            case 3:
                self.birthmonth=@"April";
                [self createDay:30];
            case 4:
                self.birthmonth=@"May";
                [self createDay:31];
            case 5:
                self.birthmonth=@"June";
                [self createDay:30];
            case 6:
                self.birthmonth=@"July";
                [self createDay:31];
            case 7:
                self.birthmonth=@"August";
                [self createDay:31];
            case 8:
                self.birthmonth=@"September";
                [self createDay:30];
            case 9:
                self.birthmonth=@"October";
                [self createDay:31];
            case 10:
                self.birthmonth=@"Novemeber";
                [self createDay:30];
            case 11:
                self.birthmonth=@"December";
                [self createDay:31];
        }
    }
    return self;
}

-(void)createDay:(int) maxDays{
    self.birthdate=arc4random()%maxDays+1;
}


@end
