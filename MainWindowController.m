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
#import "WMNoteItemCell.h"
#import "ImageAndTextCell.h"

@interface MainWindowController ()
- (void)managedObjectContextDidChange:(NSNotification *)notification;

@end


@implementation MainWindowController

@synthesize contentBox, currentHttpViewController, httpGetViewController, httpPostViewController, getToolbarItem, postToolbarItem, managedObjectContext, sourcelist, bookmarks;
@synthesize bookmarksController, newBookmarkSheetController, editBookmarkMenuItem;

- (id) init
{
	self = [super initWithWindowNibName:@"MainWindow"];
	if (self != nil) {
	}
	return self;
}

- (void)awakeFromNib {
	[[[self window] toolbar] setSelectedItemIdentifier:@"get"];
	
	//[self.editBookmarkMenuItem isEnabled:NO];
	
	self.bookmarks = [[Folder alloc] initWithName:@"BOOKMARKS"];
	
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
	self.bookmarksController.sortDescriptors = [NSArray arrayWithObject:sort];

	[self.bookmarksController addObserver:self
							   forKeyPath:@"arrangedObjects"
								  options:NSKeyValueObservingOptionNew context:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(managedObjectContextDidChange:) 
												 name:NSManagedObjectContextObjectsDidChangeNotification
											   object:nil];
	
	self.httpGetViewController = [[HttpGetViewController alloc] initWithNibName:@"HttpGetView" bundle:nil];
	self.httpPostViewController = [[HttpPostViewController alloc] initWithNibName:@"HttpPostView" bundle:nil];
	
	self.httpGetViewController.managedObjectContext = self.managedObjectContext;
	self.httpPostViewController.managedObjectContext = self.managedObjectContext;
		
	NSView *httpGetView = [self.httpGetViewController view];
	[httpGetView setFrame:[self.contentBox bounds]];
	[httpGetView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];
	[self.contentBox addSubview:httpGetView];
	activeView = kHttpViewGet;
	self.currentHttpViewController = self.httpGetViewController;
	
	[self.sourcelist expandItem:[self.sourcelist itemAtRow:0]];
	[self.sourcelist setDoubleAction:@selector(bookmarksDoubleClicked:)];
}

- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
	return [self.managedObjectContext undoManager];
}

- (IBAction)close:(id)sender {
	[self.window close];
}

- (void)switchView:(NSInteger)viewType {
	if ((viewType == kHttpViewGet) && (activeView != kHttpViewGet)) {
		NSView *httpGetView = [self.httpGetViewController view];
		[httpGetView setFrame:[self.contentBox bounds]];
		[httpGetView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];
		
		[self.httpPostViewController viewWillSwitch];
		[self.contentBox replaceSubview:[[self.contentBox subviews] objectAtIndex:0] with:httpGetView];
		[self.httpGetViewController viewDidSwitch];		
		
		self.currentHttpViewController = self.httpGetViewController;
		activeView = kHttpViewGet;
		[[[self window] toolbar] setSelectedItemIdentifier:@"get"];

	} else if ((viewType == kHttpViewPost) && (activeView != kHttpViewPost)) {
		NSView *httpPostView = [self.httpPostViewController view];
		[httpPostView setFrame:[self.contentBox bounds]];
		[httpPostView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];
		
		[self.httpGetViewController viewWillSwitch];
		[self.contentBox replaceSubview:[[self.contentBox subviews] objectAtIndex:0] with:httpPostView];
		[self.httpPostViewController viewDidSwitch];		
		
		self.currentHttpViewController = self.httpPostViewController;
		activeView = kHttpViewPost;
		[[[self window] toolbar] setSelectedItemIdentifier:@"post"];
	}
}

- (IBAction)switchViewAction:(NSToolbarItem *)toolbarItem {
	NSString *identifier = [toolbarItem itemIdentifier];
	
	if ([identifier isEqualToString:@"get"]) {
		[self switchView:kHttpViewGet];
		
	} else if ([identifier isEqualToString:@"post"]) {
		[self switchView:kHttpViewPost];
	}
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			//[self.progressIndicator startAnimation:self];
		} else {
			//[self.progressIndicator stopAnimation:self];
		}
		
		return;
	}
	
	if ([keyPath isEqual:@"statusMessage"]) {
		//self.statusLabel.stringValue = [change objectForKey:NSKeyValueChangeNewKey];
		return;
	}
	
	if ([keyPath isEqual:@"arrangedObjects"]) {
		DLog(@"Change observered in bookmarks array controller! %@", change);
		[sourcelist reloadData];
		
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
		//return [[(Folder *)item items] objectAtIndex:index];
		return [[self.bookmarksController arrangedObjects] objectAtIndex:index];
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
		//return [[(Folder *)item items] count];	
		return [[self.bookmarksController arrangedObjects] count];
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

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	if (tableColumn == nil) return nil;
	
	if ([item class] == [Folder class]) {
		return [tableColumn dataCell];
	} else {
		return [[ImageAndTextCell alloc] init];
	}
}

- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	if ([item class] == [Folder class]) return;
	
	NSImage *icon;
	switch ([[item httpAction] intValue]) {
		case kHttpViewGet:
			icon = [NSImage imageNamed:@"bookmark-get.png"];
			break;
		case kHttpViewPost:
			icon = [NSImage imageNamed:@"bookmark-post.png"];
			break;
			
		default:
			break;
	}
	[(ImageAndTextCell *)cell setImage:icon];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
	Bookmark *selected = [self.sourcelist itemAtRow:[self.sourcelist selectedRow]];
	[self.bookmarksController setSelectedObjects:[NSArray arrayWithObject:selected]];
	//[self.editBookmarkMenuItem isEnabled:YES];
	DLog(@"Selection changed");
	[self handleSelectedBookmarkAndLoad:NO];

}

- (void)handleSelectedBookmarkAndLoad:(BOOL)load {
	Bookmark *selected = [self.sourcelist itemAtRow:[self.sourcelist selectedRow]];
	
	switch ([selected.httpAction intValue]) {
		case kHttpViewPost:
			[self switchView:kHttpViewPost];
			break;
		case kHttpViewGet:
			[self switchView:kHttpViewGet];
			break;
		default:
			break;
	}
	
	[currentHttpViewController loadWithBookmark:selected openUrl:load];
}

- (IBAction)bookmarksClicked:(id)sender {
}

- (IBAction)bookmarksDoubleClicked:(id)sender {
	[self handleSelectedBookmarkAndLoad:YES];
}

- (void)managedObjectContextDidChange:(NSNotification *)notification {
	DLog(@"context changed!");
	[self.sourcelist reloadData];
}

#pragma mark -
#pragma mark Bookmark handling
#pragma mark -

- (IBAction)addBookmark:(id)sender {
	[self.newBookmarkSheetController add:nil];
}

- (IBAction)editBookmark:(id)sender {
	if ([self.bookmarksController selection]) [self.newBookmarkSheetController edit:nil];
}

- (IBAction)deleteBookmark:(id)sender {
	DLog(@"deletebookmark");
	if (![self.bookmarksController selection]) return;
	Bookmark *selected = [self.sourcelist itemAtRow:[self.sourcelist selectedRow]];

	DLog(@"selected objects!");
	
	NSAlert *alert = [NSAlert alertWithMessageText:[NSString stringWithFormat:@"Are you sure you want to delete bookmark '%@'?",  selected.name]
									 defaultButton:@"Yes" alternateButton:@"No" otherButton:nil 
						 informativeTextWithFormat:@"Deleting bookmarks can be undone."];
	
	[alert setAlertStyle:NSWarningAlertStyle];
	[alert setIcon:[NSImage imageNamed:NSImageNameCaution]];
	[alert setShowsSuppressionButton:YES];
	[alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
	return;

	//[self.sourcelist deselectAll:nil];
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
	if (returnCode == NSOKButton) {
		[self.bookmarksController removeObjects:[self.bookmarksController selectedObjects]];
		[self handleSelectedBookmarkAndLoad:NO];
	}
}

- (NSString *)urlForBookmark {
	return currentHttpViewController.currentUrl;
}

- (NSInteger)httpActionForBookmark {
	return activeView;
}
- (NSDictionary *)postKeysAndValuesForBookmark {
	NSDictionary *keysAndValues = [NSDictionary dictionaryWithObjectsAndKeys:self.httpPostViewController.keysArray, kHttpPostKeys,
																			self.httpPostViewController.valuesArray, kHttpPostValues, nil];
	
	return keysAndValues;
}

@end
