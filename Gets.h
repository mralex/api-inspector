//
//  Gets.h
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Gets :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * added_at;

@end



