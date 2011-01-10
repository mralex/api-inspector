//
//  AuthenticationWindowController.m
//  Action Spy
//
//  Created by Alex Roberts on 1/9/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import "AuthenticationWindowController.h"
#import "NewAuthWindowController.h"
#import "Authentication.h"
#import "constants.h"

@interface AuthenticationWindowController ()
- (void)renameAuthSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;

@end


@implementation AuthenticationWindowController
@synthesize managedObjectContext, accountsArray, account, renameAccountWindow;

- (id) init
{
	self = [super initWithWindowNibName:@"AuthManagementWindow"];
	if (self != nil) {
		
	}
	return self;
}

- (void)showWindow:(id)sender {
	if (![self.window isVisible])
		[self.window center];
	
	[self.window makeKeyAndOrderFront:self];
}

- (IBAction)add:(id)sender {
	
}

- (IBAction)remove:(id)sender {
	
}

- (IBAction)rename:(id)sender {
	[[self.managedObjectContext undoManager] disableUndoRegistration];
	
	id obj = [[self.accountsArray selectedObjects] objectAtIndex:0];
	[self.account addObject:obj];
	
	[[self.managedObjectContext undoManager] enableUndoRegistration];
	
	[NSApp beginSheet:self.renameAccountWindow 
	   modalForWindow:self.window 
		modalDelegate:self 
	   didEndSelector:@selector(renameAuthSheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:NULL];
}

- (IBAction)complete:sender {
	[NSApp endSheet:self.renameAccountWindow returnCode:NSOKButton];
}

- (IBAction)cancelOperation:sender {
	[NSApp endSheet:self.renameAccountWindow returnCode:NSCancelButton];	
}

- (void)renameAuthSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	NSError *error;
	[self.managedObjectContext save:&error];
	
	[self.account setContent:nil];
	[self.renameAccountWindow orderOut:nil];
}

@end
