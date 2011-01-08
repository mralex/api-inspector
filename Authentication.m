// 
//  Authentication.m
//  Action Spy
//
//  Created by Alex Roberts on 1/8/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import "Authentication.h"
#import "History.h"
#import "constants.h"

@implementation Authentication 

@dynamic requestTokenUrl;
@dynamic consumerKey;
@dynamic created_at;
@dynamic authType;
@dynamic forceHttps;
@dynamic accessTokenUrl;
@dynamic token;
@dynamic consumerSecret;
@dynamic updated_at;
@dynamic username;
@dynamic authUrl;
@dynamic name;
@dynamic histories;

- (void)awakeFromInsert {
	self.created_at = self.updated_at = [NSDate date];
	self.forceHttps = [NSNumber numberWithBool:YES];
	self.authType = authTypeOAuth;
}


@end
