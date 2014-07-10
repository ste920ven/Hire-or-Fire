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
    NSDictionary *rules;
}

-(void)createRulesWithLevel:(int)level{
    int counter=0;
    NSMutableString *tmp=[NSMutableString string];
    rules=self.Leveldata[level];
    for (NSString* rule in rules){
        counter++;
        [tmp appendFormat:@"%d. ",counter];
        switch ([rules[rule] intValue]) {
            case YOUNGAGE: //0
                [tmp appendFormat:@"Must be younger than %@\n",rule];
                break;
            case OLDAGE: //1
                [tmp appendFormat:@"Must be older than %@\n",rule];
                break;
            case NAME: //2
                [tmp appendFormat:@""];
                break;
            case ADDRESS: //3
                [tmp appendFormat:@""];
                break;
            case EDUCATION: //4
                [tmp appendFormat:@"Must have gone to %@\n",rule];
                break;
            case PHONE: //5
                [tmp appendFormat:@"Must be from this areacode (%@)\n",rule];
                break;
            case EXPERIENCE: //6
                [tmp appendFormat:@""];
                break;
        }
    }
    _rulesLabel.string=tmp;
}

@end
