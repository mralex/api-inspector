//
//  Authentication.h
//  Action Spy
//
//  Created by Alex Roberts on 1/8/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import <CoreData/CoreData.h>

@class History;

@interface Authentication :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * requestTokenUrl;
@property (nonatomic, retain) NSString * consumerKey;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * authType;
@property (nonatomic, retain) NSNumber * forceHttps;
@property (nonatomic, retain) NSString * accessTokenUrl;
@property (nonatomic, retain) NSString * token;
@property (nonatomic, retain) NSString * consumerSecret;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * authUrl;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet* histories;

@end


@interface Authentication (CoreDataGeneratedAccessors)
- (void)addHistoriesObject:(History *)value;
- (void)removeHistoriesObject:(History *)value;
- (void)addHistories:(NSSet *)value;
- (void)removeHistories:(NSSet *)value;

@end

