//
//  History.h
//  API Inspector
//
//  Created by Alex Roberts on 12/27/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Authentication;

@interface History :  NSManagedObject  
{
}

@property (nonatomic, retain) NSDate * added_at;
@property (nonatomic, retain) NSNumber * httpAction;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * url;

@property (nonatomic, retain) Authentication *authentication;

@end



