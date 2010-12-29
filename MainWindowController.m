//
//  MainWindowController.m
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "constants.h"
#import "Folder.h"
#import "Bookmark.h"
#import "MainWindowController.h"
#import "HttpViewController.h"
#import "HttpGetViewController.h"
#import "HttpPostViewController.h"
#import "NewBookmarkSheetController.h"

@implementation MainWindowController

@synthesize statusLabel,progressIndicator, contentBox, currentHttpViewController, httpGetViewController, httpPostViewController, getToolbarItem, postToolbarItem, managedObjectContext, sourcelist, bookmarks;
@synthesize getBookmarksController, newBookmarkSheetController;

- (id) init
{
	self = [super initWithWindowNibName:@"MainWindow"];
	if (self != nil) {
	}
	return self;
}

- (void)awakeFromNib {
	[[[self window] toolbar] setSelectedItemIdentifier:@"get"];
	
	self.bookmarks = [[Folder alloc] initWithName:@"Bookmarks"];
	self.newBookmarkSheetController.parentManagedObjectContext = self.managedObjectContext;
	[self loadBookmarks];
	
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
	self.currentHttpViewController = self.httpGetViewController;
}

- (void)dealloc {
	
	[statusLabel release];
	[progressIndicator release];
	
    [super dealloc];
}

- (void)loadBookmarks {
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bookmark" inManagedObjectContext:self.managedObjectContext];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	request.entity = entity;
	
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"httpAction == %d", kHttpViewGet];
//	request.predicate = predicate;
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
	request.sortDescriptors = [NSArray arrayWithObject:sort];
	
	NSError *error = nil;
	NSArray *results = [managedObjectContext executeFetchRequest:request error:&error];
	if (results == nil) {
		NSLog(@"Error fetching history (%@)", [error description]);
		return;
	}
	
	self.bookmarks.items = [NSMutableArray arrayWithArray:results];
	NSLog(@"Loaded %d bookmarks", [self.bookmarks.items count]);
	
	[self.sourcelist reloadData];
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
		
		self.currentHttpViewController = self.httpGetViewController;
		activeView = kHttpViewGet;
		
	} else if ([identifier isEqualToString:@"post"] && (activeView != kHttpViewPost)) {
		NSView *httpPostView = [self.httpPostViewController view];
		[httpPostView setFrame:[self.contentBox bounds]];
		[httpPostView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];

		[self.httpGetViewController viewWillSwitch];
		[self.contentBox replaceSubview:[[self.contentBox subviews] objectAtIndex:0] with:httpPostView];
		[self.httpPostViewController viewDidSwitch];		

		self.currentHttpViewController = self.httpPostViewController;
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

#pragma mark -
#pragma mark outlineview datasource methods
#pragma mark -

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (item == nil) {
		return bookmarks;
	} else {
		return [[(Folder *)item items] objectAtIndex:index];
		//return [[self.getBookmarksController arrangedObjects] objectAtIndex:index];
	}
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if ([item class] == [Folder class]) return YES;
	
	return NO;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (item == nil) {
		return 1;
	} else if ([item class] == [Folder class]) {
		return [[(Folder *)item items] count];	
		//return [[self.getBookmarksController arrangedObjects] count];
	} 
	
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([item class] == [Folder class]) {
		return [(Folder *)item name];
	}
	return [(Bookmark *)item name];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item {
	return (([item class] == [Folder class]) ? YES : NO);
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item {
	return (([item class] == [Folder class]) ? NO : YES);
}

#pragma mark -
#pragma mark Bookmark handling
#pragma mark -

- (IBAction)addBookmark:(id)sender {
	NSLog(@"hai!");
}



@end
