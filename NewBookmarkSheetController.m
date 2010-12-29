//
//  NewBookmarkSheetController.m
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "NewBookmarkSheetController.h"
#import "Gets.h"


@implementation NewBookmarkSheetController

@synthesize parentManagedObjectContext, managedObjectContext, parentWindow, sourceArrayController, newBookmarkController, newBookmarkSheet, delegate;

- (NSManagedObjectContext *)managedObjectContext {
	if (managedObjectContext == nil) {
		managedObjectContext = [[NSManagedObjectContext alloc] init];
		[managedObjectContext setPersistentStoreCoordinator:[self.parentManagedObjectContext persistentStoreCoordinator]];
	}
	
	return managedObjectContext;
}

- (IBAction)add:(id)sender {
	if (self.newBookmarkSheet == nil) {
		NSNib *nib = [[NSNib alloc] initWithNibNamed:@"NewBookmarkSheet" bundle:[NSBundle bundleForClass:[self class]]];
		BOOL fail = [nib instantiateNibWithOwner:self topLevelObjects:nil];
		
		if (fail != YES) {
			NSLog(@"Error instantiating sheet");
			return;
		}
	}
	
	NSUndoManager *undoManager = [self.managedObjectContext undoManager];
	[undoManager disableUndoRegistration];
	
	id obj = [newBookmarkController newObject];
	[newBookmarkController addObject:obj];
	
	[self.managedObjectContext processPendingChanges];
	[undoManager enableUndoRegistration];
	
	[NSApp beginSheet:self.newBookmarkSheet 
	   modalForWindow:self.parentWindow 
		modalDelegate:self 
	   didEndSelector:@selector(newBookmarkSheetDidEnd:returnCode:contextInfo:) 
		  contextInfo:NULL];
	
}

- (IBAction)complete:sender {
	[self.newBookmarkController commitEditing];
	
	Gets *sheetObj = [newBookmarkController content];
	if ([sheetObj.url length] < 1 && [sheetObj.name length] < 1) return;

	[NSApp endSheet:self.newBookmarkSheet returnCode:NSOKButton];
}

- (IBAction)cancelOperation:sender {
	[NSApp endSheet:self.newBookmarkSheet returnCode:NSCancelButton];	
}

- (void)newBookmarkSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	//Gets *sheetObj = [newBookmarkController content];

	if (returnCode == NSOKButton) {
		NSLog(@"changes? %d", [self.managedObjectContext hasChanges]);
		
		[[NSNotificationCenter defaultCenter] addObserverForName:NSManagedObjectContextDidSaveNotification
														  object:managedObjectContext 
														   queue:nil
													  usingBlock:^(NSNotification *saveNotification) {
														  [self.parentManagedObjectContext mergeChangesFromContextDidSaveNotification:saveNotification];
														  // Notify delegate here
													  }];
		
		NSError *error;
		if (![managedObjectContext save:&error]) {
			NSLog(@"Error occured saving moc");
		}
		[[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	} else {
		[managedObjectContext rollback];
	}
	
	[newBookmarkSheet orderOut:self];
	[self.newBookmarkController setContent:nil];
}

- (IBAction)undo:sender {
	
}

- (IBAction)redo:sender {
	
}

@end
