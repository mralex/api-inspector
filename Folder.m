//
//  Folder.m
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "Folder.h"


@implementation Folder
@synthesize name, icon, items;

- (id) initWithName:(NSString *)aName
{
	self = [super init];
	if (self != nil) {
		name = aName;
		icon = nil;
		items = [NSMutableArray array];
	}
	return self;
}


@end
