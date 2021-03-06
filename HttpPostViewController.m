//
//  HttpPostViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 12/2/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "constants.h"
#import "HttpPostViewController.h"
#import "History.h"
#import "Bookmark.h"
#import "RawDataWindow.h"

@implementation HttpPostViewController
@synthesize addButton, removeButton, bodyView, resultsView, valuesTable, keysArray, valuesArray, resultsWebView;


- (void) loadView {
	[super loadView];
	
	[self.bodyView setFont:[NSFont userFixedPitchFontOfSize:11]];	
	[self.resultsView setFont:[NSFont userFixedPitchFontOfSize:11]];
	
	self.keysArray = [NSMutableArray array];
	self.valuesArray = [NSMutableArray array];
}

- (void)loadWithBookmark:(Bookmark *)bookmark openUrl:(BOOL)opening {
	DLog(@"hai!");
	
	[self.urlField setStringValue:bookmark.url];
	self.keysArray = [NSMutableArray arrayWithArray:bookmark.keyArray];
	self.valuesArray = [NSMutableArray arrayWithArray:bookmark.valueArray];
	[self.valuesTable reloadData];
	
	if (opening) [self goAction:nil];
}

-(IBAction)goAction:(id)sender {
	if (self.isLoading) return;
	
	DLog(@"POST Go!");
	
	if (![self updateUrlSelection]) return; // FIXME: Throw an error?

	// Create url history item here
	History *historic;
	if ([self.urlHistoryController selectionIndex] == NSNotFound) {
		DLog(@"New!");
		historic = (History *)[NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:self.managedObjectContext];
		historic.httpAction = [NSNumber numberWithInt:kHttpViewPost];
		historic.url = self.urlField.stringValue;
	} else {
		historic = (History *)[[self.urlHistoryController selectedObjects] objectAtIndex:0];
		historic.updated_at = [NSDate date];
	}
	
	NSError *error = nil;
	[self.managedObjectContext save:&error];
	if (error == nil) {
		[self.urlHistoryController rearrangeObjects];
	}

	//	[progressIndicator startAnimation:nil];
	self.statusMessage = @"Connecting...";
	
	
	int i;
	NSString *body = [NSString string];
	
	for (i = 0; i < [self.keysArray count]; i++) {
		NSString *key = [self.keysArray objectAtIndex:i];
		NSString *value = [self.valuesArray objectAtIndex:i];
		
		body = [NSString stringWithFormat:@"%@%@=%@&", body, key, value];
	}
	
	
	self.isLoading = YES;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlField.stringValue] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		received = [[NSMutableData data] retain];
	} else {
		[connection release];
		self.statusMessage = @"Connection failed";
		
		self.isLoading = NO;
	}
	
}

-(IBAction)addAction:(id)sender {
	[self.keysArray addObject:@""];
	[self.valuesArray addObject:@""];
	
	[valuesTable reloadData];
	[valuesTable selectRowIndexes:[NSIndexSet indexSetWithIndex:[self.keysArray count] - 1] byExtendingSelection:NO];
}

-(IBAction)removeAction:(id)sender {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.contentType = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Type"];
	[[[RawDataWindow sharedDataWindow] contentTypeField] setStringValue:self.contentType];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[received appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	NSString *rawString = [[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionAllowLossy];
	[[[RawDataWindow sharedDataWindow] textView] setString:rawString];
	
	//[self.resultsView setString:rawString];
	[[self.resultsWebView mainFrame] loadHTMLString:rawString baseURL:[NSURL URLWithString:[self.urlField stringValue]]];
	
	[connection release];
	self.isLoading = NO;

}


#pragma mark -
#pragma mark Table View Data Source
#pragma mark -

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [self.keysArray count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if ([[aTableColumn identifier] isEqualToString:@"keys"]) {
		return [self.keysArray objectAtIndex:rowIndex];
	}
		
	return [self.valuesArray objectAtIndex:rowIndex];
}

-  (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
	if ([[aTableColumn identifier] isEqualToString:@"keys"]) {
		[self.keysArray replaceObjectAtIndex:rowIndex withObject:anObject];
	} else {
		[self.valuesArray replaceObjectAtIndex:rowIndex withObject:anObject];
	}
}

#pragma mark -

- (NSString *)currentUrl {
	return self.urlField.stringValue;
}

#pragma mark -
- (void)viewWillDisappear {
	[[[RawDataWindow sharedDataWindow] textView] setString:@""];
	[[[RawDataWindow sharedDataWindow] contentTypeField] setStringValue:@""];
}

- (void)viewWillAppear {
	if ((received == nil) || ([received length] < 1) || self.isLoading) return;
	
	NSString *rawString = [[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionAllowLossy];
	[[[RawDataWindow sharedDataWindow] textView] setString:rawString];
	[[[RawDataWindow sharedDataWindow] contentTypeField] setStringValue:self.contentType];
}


@end
