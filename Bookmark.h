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

@property (nonatomic, retain) id valueArray;
@property (nonatomic, retain) NSDate * created_at;
@property (nonatomic, retain) NSNumber * httpAction;
@property (nonatomic, retain) id keyArray;
@property (nonatomic, retain) NSDate * updated_at;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * position;

@end



