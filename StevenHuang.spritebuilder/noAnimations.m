//
//  noAnimations.m
//  StevenHuang
//
//  Created by Steven Huang on 8/14/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "noAnimations.h"

@implementation noAnimations

-(void)runAnimation:(NSString *)str{
    [self.animationManager runAnimationsForSequenceNamed:str];
}

@end
