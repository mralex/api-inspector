//
//  MainWindowController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HttpGetViewController;
@class HttpPostViewController;

@interface MainWindowController : NSWindowController {
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;
	NSView *contentBox;
	
	NSToolbarItem *getToolbarItem;
	NSToolbarItem *postToolbarItem;
	
	HttpGetViewController *httpGetViewController;
	HttpPostViewController *httpPostViewController;
	
	int activeView;
	NSManagedObjectContext *managedObjectContext;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain) IBOutlet NSToolbarItem *getToolbarItem;
@property (nonatomic, retain) IBOutlet NSToolbarItem *postToolbarItem;

@property (nonatomic, retain) IBOutlet NSView *contentBox;
@property (nonatomic, retain) HttpGetViewController *httpGetViewController;
@property (nonatomic, retain) HttpPostViewController *httpPostViewController;

- (IBAction)switchView:(NSToolbarItem *)toolbarItem;

@end
