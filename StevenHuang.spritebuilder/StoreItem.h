//
//  StoreItem.h
//  StevenHuang
//
//  Created by Steven Huang on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCNode.h"

@interface StoreItem : CCNode

@property (nonatomic,strong) NSString*title;
@property (assign) int value;

-(bool)buy;
-(void)greyOut;
-(void)check:(bool)b;

-(void)setup:(CCLabelTTF*)money selected:(CCLabelTTF*)s;

@end
