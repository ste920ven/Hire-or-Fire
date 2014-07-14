//
//  RuleBook.m
//  Project
//
//  Created by Steven Huang on 7/5/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "RuleBook.h"

@implementation RuleBook{
    CCLabelTTF *_rulesLabel;
}

-(void)createRulesWithLevel:(int)level{
#pragma mark TODO do not pass all level data
    int counter=0;
    NSMutableString *tmp =[NSMutableString string];
    self.rules=self.Leveldata[level];
    for (NSString* ruleType in self.rules){
        counter++;
        [tmp appendFormat:@"%d. ",counter];
        NSArray* rule=self.rules[ruleType];
        switch ([ruleType intValue]) {
            case MAXAGE: //0
                for(NSObject* item in rule){
                    [tmp appendFormat:@"Must be at most %@ years old\n",item];
                }break;
            case MINAGE: //1
                for(NSObject* item in rule){
                    [tmp appendFormat:@"Must be atleast %@ years old\n",item];
                }break;
            case NAME: //2
                for(NSObject* item in rule){
                    [tmp appendFormat:@""];
                }break;
            case ADDRESS: //3
                for(NSObject* item in rule){
                    [tmp appendFormat:@""];
                }break;
            case EDUCATION: //4
                for(NSObject* item in rule){
                    [tmp appendFormat:@"Must have gone to %@\n",item];
                }break;
            case PHONE: //5
                for(NSObject* item in rule){
                    [tmp appendFormat:@"Must be from this areacode (%@)\n",item];
                }break;
            case EXPERIENCE: //6
                for(NSObject* item in rule){
                    [tmp appendFormat:@""];
                }break;
        }
    }
    _rulesLabel.string=tmp;
}

@end
