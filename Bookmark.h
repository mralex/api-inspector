//
//  Bookmark.h
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Bookmark :  NSManagedObject  
{
}

@property (nonatomic, retain) NSData * valueArray;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * httpAction;
@property (nonatomic, retain) NSData * keyArray;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;

@end



