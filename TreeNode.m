//
//  OutlineObject.m
//  API Inspector
//
//  Created by Alex Roberts on 11/30/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "TreeNode.h"


@implementation TreeNode

@synthesize name, value, children;

- (id) init
{
	self = [super init];
	if (self != nil) {
		name = @"Object";
		value = nil;
		children = nil;
	}
	return self;
}

- (void) dealloc {
	[name release];
	[value release];
	[children release];
	
	[super dealloc];
}


@end
