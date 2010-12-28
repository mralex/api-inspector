//
//  HttpViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 12/27/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HttpViewController : NSViewController {
	NSMutableArray *urlHistory;
	NSManagedObjectContext *managedObjectContext;

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *urlHistory;

- (NSUInteger)indexOfItemInHistoryWithStringValue:(NSString *)value;
- (void)urlFieldChanged:(NSNotification *)aNotification;

@end
