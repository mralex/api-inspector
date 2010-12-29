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

@implementation HttpPostViewController
@synthesize goButton, addButton, removeButton, urlField, bodyView, resultsView, valuesTable, keysArray, valuesArray;


- (void) loadView {
	[super loadView];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(urlFieldChanged:) name:NSControlTextDidChangeNotification object:self.urlField];
	
	[self.bodyView setFont:[NSFont userFixedPitchFontOfSize:11]];	
	[self.resultsView setFont:[NSFont userFixedPitchFontOfSize:11]];
	
	self.keysArray = [NSMutableArray array];
	self.valuesArray = [NSMutableArray array];
}

-(IBAction)goAction:(id)sender {
	if (self.isLoading) return;
	
	NSLog(@"POST Go!");
	
	// Create url history item here
	History *historic;
	if ([self.urlHistoryController selectionIndex] == NSNotFound) {
		NSLog(@"New!");
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

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[received appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

	[self.resultsView setString:[[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionAllowLossy]];
	
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
@end
