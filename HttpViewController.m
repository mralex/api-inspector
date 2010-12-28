//
//  HttpViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 12/27/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "HttpViewController.h"
#import "History.h"

@implementation HttpViewController
@synthesize urlHistory, managedObjectContext;

- (id) init
{
	self = [super init];
	if (self != nil) {
		urlHistory = [NSMutableArray array];
	}
	return self;
}

- (NSUInteger)indexOfItemInHistoryWithStringValue:(NSString *)value {
	__block NSUInteger index = -1;
	if (value == nil) return index;
	
	[self.urlHistory enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *url = [(History *)obj url];
		if ([url rangeOfString:value options:NSCaseInsensitiveSearch].location == 0) {
			index = idx;
			*stop = YES;
		}
	}];
	
	return index;
}

#pragma mark -
#pragma mark Combobox Data Source
#pragma mark -

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	History *item = [self.urlHistory objectAtIndex:index];
	return item.url;
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	return [self.urlHistory count];
}

- (NSString *)comboBox:(NSComboBox *)aComboBox completedString:(NSString *)uncompletedString {
	int index = [self indexOfItemInHistoryWithStringValue:uncompletedString];
	
	if (index == -1) {
		return nil;
	}
	
	History *history = [self.urlHistory objectAtIndex:index];
	return history.url;
}

- (NSUInteger)comboBox:(NSComboBox *)aComboBox indexOfItemWithStringValue:(NSString *)aString {
	return [self indexOfItemInHistoryWithStringValue:aString];
}

#pragma mark -

- (void)urlFieldChanged:(NSNotification *)aNotification {
	NSComboBox *urlField = [aNotification object];
	NSString *url = urlField.stringValue;
	
	if ([url length] < 6) return;
	
	if (([url rangeOfString:@"http:"].location != NSNotFound) || ([url rangeOfString:@"https:"].location != NSNotFound)) return;
	
	[urlField setStringValue:[NSString stringWithFormat:@"http://%@", url]];
}

@end
