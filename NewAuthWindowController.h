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
	NSObjectController *accountController;
	NSArrayController *accountsArrayController;

}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *parentManagedObjectContext;

@property (nonatomic, retain) IBOutlet NSArrayController *accountsArrayController;
@property (nonatomic, retain) IBOutlet NSObjectController *accountController;

- (IBAction)add:(id)sender;
@end
