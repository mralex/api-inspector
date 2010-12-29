// 
//  Bookmark.m
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "Bookmark.h"


@implementation Bookmark 

@dynamic valueArray;
@dynamic created_at;
@dynamic httpAction;
@dynamic keyArray;
@dynamic updated_at;
@dynamic name;
@dynamic url;

- (void)awakeFromInsert {
	NSLog(@"Holla!");
	self.created_at = self.updated_at = [NSDate date];
}

@end
