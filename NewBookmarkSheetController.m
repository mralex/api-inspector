//
//  NewBookmarkSheetController.m
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "NewBookmarkSheetController.h"
#import "Bookmark.h"
#import "constants.h"


@implementation NewBookmarkSheetController

@synthesize parentManagedObjectContext, managedObjectContext, parentWindow, sourceArrayController, newBookmarkController, newBookmarkSheet, delegate;

- (NSManagedObjectContext *)parentManagedObjectContext {
	return [sourceArrayController managedObjectContext];
}

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
	if (self.delegate) {
		[obj setUrl:[delegate urlForBookmark]];
		
		NSInteger action = [delegate httpActionForBookmark];
		[obj setHttpAction:[NSNumber numberWithInt:action]];
		
		if (action == kHttpViewPost) {
			NSDictionary *keysAndValues = [delegate postKeysAndValuesForBookmark];
			[obj setKeyArray:[keysAndValues objectForKey:kHttpPostKeys]];
			[obj setValueArray:[keysAndValues objectForKey:kHttpPostValues]];
		}
	}
	NSLog(@"object: %@", obj);
	
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
	
	Bookmark *sheetObj = [newBookmarkController content];
	if ([sheetObj.url length] < 1 && [sheetObj.name length] < 1) return;

	[NSApp endSheet:self.newBookmarkSheet returnCode:NSOKButton];
}

- (IBAction)cancelOperation:sender {
	[NSApp endSheet:self.newBookmarkSheet returnCode:NSCancelButton];	
}

- (void)newBookmarkSheetDidEnd:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo {
	NSManagedObject *sheetObj = [newBookmarkController content];

	if (returnCode == NSOKButton) {
		NSLog(@"changes? %d", [self.managedObjectContext hasChanges]);
		
		NSManagedObject *newObj = [self.sourceArrayController newObject];
		[newObj setValuesForKeysWithDictionary:[sheetObj dictionaryWithValuesForKeys:[NSArray arrayWithObjects:@"name", @"url", @"httpAction", @"keyArray", @"valueArray", nil]]];
		[sourceArrayController addObject:newObj];
		
		NSError *error;
		if (![self.parentManagedObjectContext save:&error]) {
			NSLog(@"Error occured saving moc");
		}
	}

	[self.managedObjectContext reset];
	[self.newBookmarkController setContent:nil];
	[newBookmarkSheet orderOut:self];
}

- (IBAction)undo:sender {
	
}

- (IBAction)redo:sender {
	
}

@end
