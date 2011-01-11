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

enum NewAuthPages {
	nameAuthPage,
	passwordAuthPage,
	oauthAuthPage,
	webAuthPage,
	webPinAuthPage
};

@implementation NewAuthWindowController
@synthesize loadingLabel, loadingIndicator;
@synthesize authTypePopUpButton, accountNameField;
@synthesize accountUsernameField, accountPasswordField, useHttpsButton;
@synthesize oauthConsumerKeyField, oauthConsumerSecretField, oauthTokenRequestUrlField, oauthUserAuthUrlField, oauthAccessTokenUrlField;
@synthesize webView;
@synthesize oauthPinWebView, oauthPinField;

@synthesize pages, currentPage, authentication, managedObjectContext, parentManagedObjectContext, accountsArrayController, accountController, pageQueue;


- (id) init
{
	self = [super initWithWindowNibName:@"NewAuthWindow"];
	if (self != nil) {
	}
	return self;
}

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

- (void)pushPage:(id)item {
	[self.pageQueue addObject:item];
}
- (id)popPage {
	id p = [self.pageQueue lastObject];
	[self.pageQueue removeLastObject];
	return p;
}


- (IBAction)add:(id)sender {
	self.pageQueue = [NSMutableArray array];
	self.currentPage = [NSNumber numberWithInt:nameAuthPage];

	NSUndoManager *undoManager = [self.managedObjectContext undoManager];
	[undoManager disableUndoRegistration];

	id obj = [self.accountController newObject];
	[self.accountController addObject:obj];
	self.authentication = obj;
	
	[self.managedObjectContext processPendingChanges];
	[undoManager enableUndoRegistration];
	
	[self.window center];
	[self.window makeKeyAndOrderFront:nil];
	
	
}

- (IBAction)complete:(id)sender {
	
}
- (IBAction)cancelOperation:(id)sender {
	
}

- (IBAction)next:(id)sender {
	[self pushPage:self.currentPage];
	
	switch ([self.currentPage intValue]) {
		case nameAuthPage:
			if ([self.authTypePopUpButton indexOfSelectedItem] == 0) {
				self.currentPage = [NSNumber numberWithInt:oauthAuthPage];
				[self.pages selectTabViewItemWithIdentifier:@"oauthSettings"];
			} else {
				self.currentPage = [NSNumber numberWithInt:passwordAuthPage];
				[self.pages selectTabViewItemWithIdentifier:@"usernameAndPassword"];
			}
			break;
		default:
			break;
	}
}

- (IBAction)previous:(id)sender {
	NSNumber *prev = [self popPage];
	switch ([prev intValue]) {
		case nameAuthPage:
			[self.pages selectTabViewItemWithIdentifier:@"nameAndType"];
			self.currentPage = prev;
			break;
		default:
			break;
	}
}
@end
