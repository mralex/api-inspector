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

static const int kHttpViewGet = 1;
static const int kHttpViewPost = 2;

@interface MainWindowController : NSWindowController {
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;
	NSView *contentBox;
	
	NSToolbarItem *getToolbarItem;
	NSToolbarItem *postToolbarItem;
	
	HttpGetViewController *httpGetViewController;
	HttpPostViewController *httpPostViewController;
	
	int activeView;
}


@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain) IBOutlet NSToolbarItem *getToolbarItem;
@property (nonatomic, retain) IBOutlet NSToolbarItem *postToolbarItem;

@property (nonatomic, retain) IBOutlet NSView *contentBox;
@property (nonatomic, retain) HttpGetViewController *httpGetViewController;
@property (nonatomic, retain) HttpPostViewController *httpPostViewController;

- (IBAction)switchView:(NSToolbarItem *)toolbarItem;

@end
