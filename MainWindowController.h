//
//  MainWindowController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Folder;
@class HttpGetViewController;
@class HttpPostViewController;

@interface MainWindowController : NSWindowController {
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;
	NSView *contentBox;
	
	NSOutlineView *sourcelist;
	
	NSToolbarItem *getToolbarItem;
	NSToolbarItem *postToolbarItem;
	
	HttpGetViewController *httpGetViewController;
	HttpPostViewController *httpPostViewController;
	
	int activeView;
	NSManagedObjectContext *managedObjectContext;
	
	Folder *getBookmarks;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain) IBOutlet NSToolbarItem *getToolbarItem;
@property (nonatomic, retain) IBOutlet NSToolbarItem *postToolbarItem;

@property (nonatomic, retain) IBOutlet NSView *contentBox;
@property (nonatomic, retain) HttpGetViewController *httpGetViewController;
@property (nonatomic, retain) HttpPostViewController *httpPostViewController;

@property (nonatomic, retain) IBOutlet NSOutlineView *sourcelist;

@property (nonatomic, retain) Folder *getBookmarks;

- (IBAction)switchView:(NSToolbarItem *)toolbarItem;

- (IBAction)addBookmark:(id)sender;
@end
