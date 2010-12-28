//
//  MainWindowController.m
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "constants.h"
#import "MainWindowController.h"
#import "HttpGetViewController.h"
#import "HttpPostViewController.h"

@implementation MainWindowController

@synthesize statusLabel,progressIndicator, contentBox, httpGetViewController, httpPostViewController, getToolbarItem, postToolbarItem, managedObjectContext;

- (id) init
{
	self = [super initWithWindowNibName:@"MainWindow"];
	if (self != nil) {
	}
	return self;
}

- (void)awakeFromNib {
	[[[self window] toolbar] setSelectedItemIdentifier:@"get"];
	
	self.httpGetViewController = [[HttpGetViewController alloc] initWithNibName:@"HttpGetView" bundle:nil];
	self.httpPostViewController = [[HttpPostViewController alloc] initWithNibName:@"HttpPostView" bundle:nil];
	
	[httpGetViewController addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];
	[httpGetViewController addObserver:self forKeyPath:@"statusMessage" options:(NSKeyValueObservingOptionNew) context:NULL];
	
	self.httpGetViewController.managedObjectContext = self.managedObjectContext;
	self.httpPostViewController.managedObjectContext = self.managedObjectContext;
		
	NSView *httpGetView = [self.httpGetViewController view];
	[httpGetView setFrame:[self.contentBox bounds]];
	[httpGetView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];
	[self.contentBox addSubview:httpGetView];
	activeView = kHttpViewGet;
}

- (void)dealloc {
	
	[statusLabel release];
	[progressIndicator release];
	
    [super dealloc];
}


- (IBAction)switchView:(NSToolbarItem *)toolbarItem {
	NSString *identifier = [toolbarItem itemIdentifier];
	
	if ([identifier isEqualToString:@"get"] && (activeView != kHttpViewGet)) {
		NSView *httpGetView = [self.httpGetViewController view];
		[httpGetView setFrame:[self.contentBox bounds]];
		[httpGetView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];

		[self.httpPostViewController viewWillSwitch];
		[self.contentBox replaceSubview:[[self.contentBox subviews] objectAtIndex:0] with:httpGetView];
		[self.httpGetViewController viewDidSwitch];		

		activeView = kHttpViewGet;
		
	} else if ([identifier isEqualToString:@"post"] && (activeView != kHttpViewPost)) {
		NSView *httpPostView = [self.httpPostViewController view];
		[httpPostView setFrame:[self.contentBox bounds]];
		[httpPostView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];

		[self.httpGetViewController viewWillSwitch];
		[self.contentBox replaceSubview:[[self.contentBox subviews] objectAtIndex:0] with:httpPostView];
		[self.httpPostViewController viewDidSwitch];		
		
		activeView = kHttpViewPost;
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			[self.progressIndicator startAnimation:self];
		} else {
			[self.progressIndicator stopAnimation:self];
		}
		
		return;
	}
	
	if ([keyPath isEqual:@"statusMessage"]) {
		self.statusLabel.stringValue = [change objectForKey:NSKeyValueChangeNewKey];
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}






@end
