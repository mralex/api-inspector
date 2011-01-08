//
//  HttpViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 12/27/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "HttpViewController.h"
#import "History.h"
#import "Bookmark.h"

@implementation HttpViewController
@synthesize managedObjectContext, urlHistoryController;
@synthesize urlField, statusLabel, progressIndicator, isLoading, statusMessage, contentType, goButton, urlFieldHasUrl, oauthButton, oauthPopup;
@dynamic currentUrl;

- (id) init
{
	self = [super init];
	if (self != nil) {
		contentType = nil;
	}
	return self;
}

- (void) awakeFromNib {
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
	self.urlHistoryController.sortDescriptors = [NSArray arrayWithObject:sort];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlFieldChanged:) name:NSControlTextDidChangeNotification object:self.urlField];

	[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];
	[self addObserver:self forKeyPath:@"statusMessage" options:(NSKeyValueObservingOptionNew) context:NULL];
	self.urlFieldHasUrl = NO;
}

//- (NSUInteger)indexOfItemInHistoryWithStringValue:(NSString *)value {
//	__block NSUInteger index = -1;
//	if (value == nil) return index;
//	
//	[self.urlHistory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//		NSString *url = [(History *)obj url];
//		if ([url rangeOfString:value options:NSCaseInsensitiveSearch].location == 0) {
//			index = idx;
//			*stop = YES;
//		}
//	}];
//	
//	return index;
//}

#pragma mark -
#pragma mark Combobox Data Source
#pragma mark -

//- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
//	History *item = [self.urlHistory objectAtIndex:index];
//	return item.url;
//}
//
//- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
//	return [self.urlHistory count];
//}
//
//- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString {
//	int index = [self indexOfItemInHistoryWithStringValue:uncompletedString];
//	
//	if (index == -1) {
//		return nil;
//	}
//	
//	History *history = [self.urlHistory objectAtIndex:index];
//	return history.url;
//}
//
//- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)aString {
//	return [self indexOfItemInHistoryWithStringValue:aString];
//}

#pragma mark -
- (BOOL)updateUrlSelection {
	NSString *url = self.urlField.stringValue;
	
	// http://a.co/
	if ([url length] < 12) {
		DLog(@"No URL entered!");
		return NO;
	}
	
	NSUInteger index = [self.urlField indexOfItemWithObjectValue:url];
	
	if (index != NSNotFound) {
		[self.urlHistoryController setSelectionIndex:index];
	}
	return YES;
}

- (void)urlFieldChanged:(NSNotification *)aNotification {
	NSString *url = self.urlField.stringValue;
	self.urlFieldHasUrl = NO;
	if ([url length] < 6) return;
	self.urlFieldHasUrl = YES;
	
	if (([url rangeOfString:@"http:"].location != NSNotFound) || ([url rangeOfString:@"https:"].location != NSNotFound)) return;
	
	[self.urlField setStringValue:[NSString stringWithFormat:@"http://%@", url]];
}
#pragma mark -
#pragma mark Combobox Delegate
#pragma mark -
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	DLog(@"New selection idx: %d", [[notification object] indexOfSelectedItem]);
	[self.urlHistoryController setSelectionIndex:[[notification object] indexOfSelectedItem]];
	self.urlFieldHasUrl = YES;
}

#pragma mark -
- (void)viewWillDisappear {
	
}
- (void)viewDidDisappear {
	
}
- (void)viewWillAppear {
	
}
- (void)viewDidAppear {
	
}


- (void)loadWithBookmark:(Bookmark *)bookmark openUrl:(BOOL)opening {
	DLog(@"Loading view with bookmark %@", bookmark.name);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			[self.progressIndicator startAnimation:self];
			DLog(@"start prog");
		} else {
			[self.progressIndicator stopAnimation:self];
			DLog(@"stop prog");
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
