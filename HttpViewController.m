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
@synthesize managedObjectContext, urlHistoryController, currentUrl;
@synthesize urlField, statusLabel, progressIndicator, isLoading, statusMessage;

- (id) init
{
	self = [super init];
	if (self != nil) {
	
	}
	return self;
}

- (void) awakeFromNib {
	NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"updated_at" ascending:NO];
	self.urlHistoryController.sortDescriptors = [NSArray arrayWithObject:sort];
	
	[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];
	[self addObserver:self forKeyPath:@"statusMessage" options:(NSKeyValueObservingOptionNew) context:NULL];
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
- (void)updateUrlSelection {
	NSString *url = self.urlField.stringValue;
	NSUInteger index = [self.urlField indexOfItemWithObjectValue:url];
	
	if (index != NSNotFound) {
		[self.urlHistoryController setSelectionIndex:index];
	}
}

- (void)urlFieldChanged:(NSNotification *)aNotification {
	NSString *url = self.urlField.stringValue;
	
	if ([url length] < 6) return;
	
	if (([url rangeOfString:@"http:"].location != NSNotFound) || ([url rangeOfString:@"https:"].location != NSNotFound)) return;
	
	[self.urlField setStringValue:[NSString stringWithFormat:@"http://%@", url]];
}
#pragma mark -
#pragma mark Combobox Delegate
#pragma mark -
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	NSLog(@"New selection idx: %d", [[notification object] indexOfSelectedItem]);
	[self.urlHistoryController setSelectionIndex:[[notification object] indexOfSelectedItem]];
}

#pragma mark -
- (void)viewWillSwitch {
	
}

- (void)viewDidSwitch {
	
}

- (void)loadWithBookmark:(Bookmark *)bookmark {
	NSLog(@"Loading with bookmark %@", bookmark.name);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			[self.progressIndicator startAnimation:self];
			NSLog(@"start prog");
		} else {
			[self.progressIndicator stopAnimation:self];
			NSLog(@"stop prog");
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
