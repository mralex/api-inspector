//
//  AuthenticationWindowController.h
//  Action Spy
//
//  Created by Alex Roberts on 1/9/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Authentication;
@class NewAuthWindowController;

@interface AuthenticationWindowController : NSWindowController {
	NSManagedObjectContext *managedObjectContext;
	NSArrayController *accountsArray;
	NSObjectController *account;
	Authentication *currentAccount;
	
	NSWindow *renameAccountWindow;
	
	NewAuthWindowController *newAuthWindowController;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet NSArrayController *accountsArray;
@property (nonatomic, retain) IBOutlet NSWindow *renameAccountWindow;

@end


