//
//  MainWindowController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NewBookmarkSheetController.h"

@class Folder;
@class Bookmark;
@class HttpViewController;
@class HttpGetViewController;
@class HttpPostViewController;
@class AuthenticationWindowController;

@interface MainWindowController : NSWindowController <NewBookmarkSheetControllerDelegate> {
	NSView *contentBox;
	
	NSOutlineView *sourcelist;
	
	NSToolbarItem *getToolbarItem;
	NSToolbarItem *postToolbarItem;
	
	NSMenuItem *editBookmarkMenuItem;
	
	BWSplitView *splitView;
	
	HttpViewController *currentHttpViewController;
	HttpGetViewController *httpGetViewController;
	HttpPostViewController *httpPostViewController;
	
	int activeView;
	NSManagedObjectContext *managedObjectContext;
	
	NSArrayController *bookmarksController;
	
	Folder *bookmarks;
	Bookmark *draggedBookmark;
	
	NewBookmarkSheetController *newBookmarkSheetController;
	AuthenticationWindowController *authenticationWindowController;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSToolbarItem *getToolbarItem;
@property (nonatomic, retain) IBOutlet NSToolbarItem *postToolbarItem;
@property (nonatomic, retain) IBOutlet NSMenuItem *editBookmarkMenuItem;
@property (nonatomic, retain) IBOutlet BWSplitView *splitView;
@property (nonatomic, retain) IBOutlet NSView *contentBox;
@property (nonatomic, retain) HttpViewController *currentHttpViewController;
@property (nonatomic, retain) HttpGetViewController *httpGetViewController;
@property (nonatomic, retain) HttpPostViewController *httpPostViewController;

@property (nonatomic, retain) IBOutlet NSOutlineView *sourcelist;

@property (nonatomic, retain) Folder *bookmarks;
@property (nonatomic, retain) IBOutlet NSArrayController *bookmarksController;

@property (nonatomic, retain) IBOutlet NewBookmarkSheetController *newBookmarkSheetController;
@property (nonatomic, retain) AuthenticationWindowController *authenticationWindowController;

- (IBAction)switchViewAction:(NSToolbarItem *)toolbarItem;

- (IBAction)close:(id)sender;

- (IBAction)editBookmark:(id)sender;
- (IBAction)addBookmark:(id)sender;
- (IBAction)deleteBookmark:(id)sender;
- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

- (void)handleSelectedBookmarkAndLoad:(BOOL)load;
- (IBAction)bookmarksClicked:(id)sender;
- (IBAction)bookmarksDoubleClicked:(id)sender;

- (IBAction)showAuthenticationManager:(id)sender;

@end
