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
@class HttpViewController;
@class HttpGetViewController;
@class HttpPostViewController;

@interface MainWindowController : NSWindowController <NewBookmarkSheetControllerDelegate> {
	NSView *contentBox;
	
	NSOutlineView *sourcelist;
	
	NSToolbarItem *getToolbarItem;
	NSToolbarItem *postToolbarItem;
	
	HttpViewController *currentHttpViewController;
	HttpGetViewController *httpGetViewController;
	HttpPostViewController *httpPostViewController;
	
	int activeView;
	NSManagedObjectContext *managedObjectContext;
	
	NSArrayController *bookmarksController;
	
	Folder *bookmarks;
	
	NewBookmarkSheetController *newBookmarkSheetController;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSToolbarItem *getToolbarItem;
@property (nonatomic, retain) IBOutlet NSToolbarItem *postToolbarItem;

@property (nonatomic, retain) IBOutlet NSView *contentBox;
@property (nonatomic, retain) HttpViewController *currentHttpViewController;
@property (nonatomic, retain) HttpGetViewController *httpGetViewController;
@property (nonatomic, retain) HttpPostViewController *httpPostViewController;

@property (nonatomic, retain) IBOutlet NSOutlineView *sourcelist;

@property (nonatomic, retain) Folder *bookmarks;
@property (nonatomic, retain) IBOutlet NSArrayController *bookmarksController;

@property (nonatomic, retain) IBOutlet NewBookmarkSheetController *newBookmarkSheetController;

- (IBAction)switchViewAction:(NSToolbarItem *)toolbarItem;

- (IBAction)editBookmark:(id)sender;
- (IBAction)addBookmark:(id)sender;

- (void)handleSelectedBookmarkAndLoad:(BOOL)load;
- (IBAction)bookmarksClicked:(id)sender;
- (IBAction)bookmarksDoubleClicked:(id)sender;
@end
