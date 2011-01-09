//
//  NewAuthWindowController.h
//  Action Spy
//
//  Created by Alex Roberts on 1/9/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NewAuthWindowController : NSWindowController {
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *parentManagedObjectContext;
	NSObjectController *account;
	NSArrayController *accountsArray;

}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
