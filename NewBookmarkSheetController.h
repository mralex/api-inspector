//
//  NewBookmarkSheetController.h
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NewBookmarkSheetController : NSObject {
	NSWindow *parentWindow;
	NSArrayController *sourceArrayController;
	NSObjectController *newBookmarkController;
	NSPanel *newBookmarkSheet;
	
	NSButton *okButton;
	
	NSManagedObjectContext *parentManagedObjectContext;
	NSManagedObjectContext *managedObjectContext;
	
	id delegate;
	
	BOOL isEditing;
}

@property (nonatomic, retain) IBOutlet NSWindow *parentWindow;
@property (nonatomic, retain) IBOutlet NSArrayController *sourceArrayController;
@property (nonatomic, retain) IBOutlet NSObjectController *newBookmarkController;
@property (nonatomic, retain) IBOutlet NSPanel *newBookmarkSheet;
@property (nonatomic, retain) IBOutlet NSButton *okButton;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *parentManagedObjectContext;

@property (nonatomic, assign) BOOL isEditing;

@property (nonatomic, retain) IBOutlet id delegate;

- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;

- (IBAction)complete:sender;
- (IBAction)cancelOperation:sender;

- (IBAction)undo:sender;
- (IBAction)redo:sender;

@end

@protocol NewBookmarkSheetControllerDelegate
- (NSInteger)httpActionForBookmark;
- (NSDictionary *)postKeysAndValuesForBookmark;
- (NSString *)urlForBookmark;
@end

