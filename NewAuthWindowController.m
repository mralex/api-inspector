//
//  NewAuthWindowController.m
//  Action Spy
//
//  Created by Alex Roberts on 1/9/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import "NewAuthWindowController.h"
#import "Authentication.h"
#import "constants.h"

@implementation NewAuthWindowController
@synthesize managedObjectContext, parentManagedObjectContext, accountsArrayController, accountController;

- (NSManagedObjectContext *)parentManagedObjectContext {
	return [self.accountsArrayController managedObjectContext];
}

- (NSManagedObjectContext *)managedObjectContext {
	if (managedObjectContext == nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:[self.parentManagedObjectContext persistentStoreCoordinator]];
	}
	
	return managedObjectContext;
}

- (IBAction)add:(id)sender {
	if (self.window == nil) {
		NSNib *nib = [[NSNib alloc] initWithNibNamed:@"NewAuthWindow" bundle:[NSBundle bundleForClass:[self class]]];
		BOOL fail = [nib instantiateNibWithOwner:self topLevelObjects:nil];
		
		if (fail != YES) {
			DLog(@"Error instantiating sheet");
			return;
		}
	}
	
	[self.window center];
	[self.window makeKeyAndOrderFront:nil];
}


@end
