//
//  GameplayManager.m
//  StevenHuang
//
//  Created by Steven Huang on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameplayManager.h"

@implementation GameplayManager

static GameplayManager *sharedInstance = nil;

+(instancetype)sharedInstance{
    if(sharedInstance==nil){
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}

-(id)init{
    if(self=[super init ]){
        
        
        
        
    }
    return self;
}

@end
