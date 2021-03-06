//
//  HttpGetViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "constants.h"
#import "HttpGetViewController.h"
#import "RawDataWindow.h"
#import "TreeNode.h"
#import "History.h"
#import "Bookmark.h"

@implementation HttpGetViewController
@synthesize resultsView, dataView, dataArray;

- (id) init
{
	self = [super init];
	if (self != nil) {
		parseType = -1;
	}
	return self;
}


- (void) loadView {
	[super loadView];
	
	[self.resultsView setFont:[NSFont userFixedPitchFontOfSize:11]];
	dataArray = [NSMutableArray array];
	
	[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];	
}

#pragma mark -
#pragma mark URL Handling
#pragma mark -

- (IBAction)goAction:sender {
	if (self.isLoading) return;
	
	DLog(@"Go!");

	History *historic;
	
	if (![self updateUrlSelection]) return; // FIXME: Throw an error?
	
	DLog(@"selection: %d", [self.urlHistoryController selectionIndex]);
	
	if ([self.urlHistoryController selectionIndex] == NSNotFound) {
		DLog(@"New!");
		historic = (History *)[NSEntityDescription insertNewObjectForEntityForName:@"History" inManagedObjectContext:self.managedObjectContext];
		historic.httpAction = [NSNumber numberWithInt:kHttpViewGet];
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
	
	self.isLoading = YES;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlField.stringValue] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setValue:@"API Inspector/1.0" forHTTPHeaderField:@"User-Agent"];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		received = [[NSMutableData data] retain];
	} else {
		[connection release];
		self.statusMessage = @"Connection failed";
		
		self.isLoading = NO;
	}
}

- (void)loadWithBookmark:(Bookmark *)bookmark openUrl:(BOOL)opening{
	[self.urlField setStringValue:bookmark.url];
	
	if (opening) [self goAction:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.statusMessage = @"Loading...";
	[received setLength:0];
	
	DLog(@"Response: %@", [[(NSHTTPURLResponse *)response allHeaderFields] description]);
	
	self.contentType = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Type"];
	[[[RawDataWindow sharedDataWindow] contentTypeField] setStringValue:self.contentType];
	
	// [NSString rangeOfString:theStringYouWant] != NSMakeRange(NSNotFound,0)
	if ([self.contentType rangeOfString:@"xml"].location != NSNotFound) {
		parseType = contentTypeXml;
	} else if (([self.contentType rangeOfString:@"json"].location != NSNotFound) || ([self.contentType rangeOfString:@"javascript"].location != NSNotFound)) {
		parseType = contentTypeJson;		
	} else {
		parseType = -1;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[received appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [received release];
	
	self.isLoading = NO;
	
    // inform the user
	self.statusMessage = [NSString stringWithFormat:@"Connection failed! %@ %@",
									[error localizedDescription],
									[[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
	
	[[[RawDataWindow sharedDataWindow] textView] setString:@""];
}

- (TreeNode *)parseJsonObject:(id)object withKey:(id)key {
	TreeNode *oObj = [[TreeNode alloc] init];
	oObj.name = key;
	
	if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
		oObj.children = [NSMutableArray array];
		
		if ([object isKindOfClass:[NSDictionary class]]) {
			oObj.value = [NSString stringWithFormat:@"%d items", [[object allKeys] count]];
			[object enumerateKeysAndObjectsUsingBlock:^(id key, id childObject, BOOL *stop) {
				TreeNode *child = [self parseJsonObject:childObject withKey:key];
				
				[oObj.children addObject:child];
			}];
		} else {
			oObj.value = [NSString stringWithFormat:@"%d items", [object count]];;
			[object enumerateObjectsUsingBlock:^(id childObject, NSUInteger index, BOOL *stop) {
				TreeNode *child = [self parseJsonObject:childObject withKey:@"Object"];
				
				[oObj.children addObject:child];
			}];
		}
	} else {
		oObj.value = object;
	}
	
	return oObj;
}

- (TreeNode *)traverseXmlNode:(NSXMLNode *)node {
	TreeNode *o = [[TreeNode alloc] init];
	
	o.name = [node name];
	
	int i, count = [node childCount];
	
	if (count < 2) {
		o.value = [node stringValue];
	} else {
		o.children = [NSMutableArray arrayWithCapacity:count];
		
		for (i = 0; i < count; i++) {
			NSXMLNode *child = [node childAtIndex:i];
			
			[o.children addObject:[self traverseXmlNode:child]];
		}
	}
	
	return o;
}

- (void)parseDataJson {
	NSError *error = nil;
	id json = [received yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
	self.dataArray = nil;
	self.dataArray = [NSMutableArray array];
	
	if ([json isKindOfClass:[NSDictionary class]]) {
		[json enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			TreeNode *oObj = [self parseJsonObject:object withKey:key];
			
			[self.dataArray addObject:oObj];
		}];
		
	} else {
		[json enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			TreeNode *oObj = [self parseJsonObject:object withKey:@"Object"];
			
			[self.dataArray addObject:oObj];
		}];
	}
	
	if (!error && [self.dataArray count] > 0) {
		[self performSelectorOnMainThread:@selector(parsingDidFinishWithMessage:) withObject:[NSString stringWithFormat:@"%d items", [self.dataArray count]] waitUntilDone:NO];
		
	} else {
		[self performSelectorOnMainThread:@selector(parsingDidFinishWithMessage:) withObject:[NSString stringWithFormat:@"Error - Not JSON! (%@)", [error localizedDescription]] waitUntilDone:NO];
	}
}

- (void)parseDataXml {
	self.statusMessage = @"Got some XML!";
	DLog(@"XML");
	
	self.dataArray = nil;
	self.dataArray = [NSMutableArray array];
	
	NSXMLDocument *xml;
	NSError *error = nil;
	
	NSString *xmlData = [[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionAllowLossy];
	
	xml = [[NSXMLDocument alloc] initWithXMLString:xmlData options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA) error:&error];
	
	int i, count = [[xml rootElement] childCount];
	DLog(@"children of root: %d", count);
	
	for (i = 0; i < count; i++) {
		NSXMLNode *child = [[xml rootElement] childAtIndex:i];
		[self.dataArray addObject:[self traverseXmlNode:child]];
	}
	
	[xml release];
	[self performSelectorOnMainThread:@selector(parsingDidFinishWithMessage:) withObject:[NSString stringWithFormat:@"%d items", count] waitUntilDone:NO];
}

- (void)parsingDidFinishWithMessage:(NSString *)message {
	self.statusMessage = message;
	[dataView reloadData];
	[received release];
	self.isLoading = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	NSString *rawString = [[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionAllowLossy];
	[[[RawDataWindow sharedDataWindow] textView] setString:rawString];
	
	NSOperationQueue *queue = [[NSOperationQueue alloc] init];
	NSInvocationOperation *op;
	
	switch (parseType) {
		case contentTypeXml:
			op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseDataXml) object:nil];
			[queue addOperation:op];
			break;
		case contentTypeJson:
			op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(parseDataJson) object:nil];
			[queue addOperation:op];
			break;
		default:
			self.statusMessage = @"Error - Unknown content type";
			self.dataArray = nil;
			[dataView reloadData];
			[received release];
			self.isLoading = NO;
			break;
	}
	
	[connection release];
	
}

#pragma mark -
#pragma mark Outline view data source methods
#pragma mark -

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (item == nil) {
		return [dataArray count];
	} else if ([item children] != nil) {
		return [[item children] count];
	}
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (item != nil) {
		return [[item children] objectAtIndex:index];
	}
	return [dataArray objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if (item && ([item children] != nil)) {
		return YES;
	}
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([(NSString*)[tableColumn identifier] isEqual:@"key"]) {
		return [(TreeNode *)item name];
	} 
	
	return [(TreeNode *)item value];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
	TreeNode *item = [dataView itemAtRow:[dataView selectedRow]];
	
	self.resultsView.string = [NSString stringWithFormat:@"%@", item.value];
}

#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			[self.goButton setEnabled:NO];
		} else {
			[self.goButton setEnabled:YES];
		}
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

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
	
	NSString *rawString = [[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionExternalRepresentation];
	[[[RawDataWindow sharedDataWindow] textView] setString:rawString];
	[[[RawDataWindow sharedDataWindow] contentTypeField] setStringValue:self.contentType];
}

@end
