// 
//  Gets.m
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "Gets.h"


@implementation Gets 

@dynamic name;
@dynamic url;
@dynamic added_at;

- (void)awakeFromInsert {
	NSLog(@"Holla!");
	self.added_at = [NSDate date];
}

@end
