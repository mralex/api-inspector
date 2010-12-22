//
//  HttpGetViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "HttpGetViewController.h"
#import "RawDataWindow.h"
#import "OutlineObject.h"

@implementation HttpGetViewController
@synthesize urlField, resultsView, jsonView, goButton, jsonArray, isLoading, statusMessage, contentType;

- (void) loadView {
	[super loadView];
	
	parseType = -1;
	
	[self.resultsView setFont:[NSFont userFixedPitchFontOfSize:11]];
	jsonArray = [NSMutableArray array];
	[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];	

}

#pragma mark -
#pragma mark URL Handling
#pragma mark -

- (IBAction)goAction:sender {
	if (self.isLoading) return;
	
	NSLog(@"Go!");
	
//	[progressIndicator startAnimation:nil];
	self.statusMessage = @"Connecting...";
	
	self.isLoading = YES;
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlField.stringValue] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		received = [[NSMutableData data] retain];
	} else {
		[connection release];
		self.statusMessage = @"Connection failed";
		
		self.isLoading = NO;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.statusMessage = @"Loading...";
	[received setLength:0];
	
	NSLog(@"Response: %@", [[(NSHTTPURLResponse *)response allHeaderFields] description]);
	
	self.contentType = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Content-Type"];
	[[[RawDataWindow sharedDataWindow] contentTypeField] setStringValue:self.contentType];
	
	// [NSString rangeOfString:theStringYouWant] != NSMakeRange(NSNotFound,0)
	if ([self.contentType rangeOfString:@"application/xml"].location != NSNotFound) {
		parseType = contentTypeXml;
	} else if ([self.contentType rangeOfString:@"application/json"].location != NSNotFound) {
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
	
	[[[RawDataWindow sharedDataWindow] textView] setString:@""];
}

- (OutlineObject *) parseJsonObject:(id)object withKey:(id)key {
	OutlineObject *oObj = [[OutlineObject alloc] init];
	oObj.name = key;
	
	if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
		oObj.children = [NSMutableArray array];
		
		if ([object isKindOfClass:[NSDictionary class]]) {
			oObj.value = [NSString stringWithFormat:@"%d items", [[object allKeys] count]];
			[object enumerateKeysAndObjectsUsingBlock:^(id key, id childObject, BOOL *stop) {
				OutlineObject *child = [self parseJsonObject:childObject withKey:key];
				
				[oObj.children addObject:child];
			}];
		} else {
			oObj.value = [NSString stringWithFormat:@"%d items", [object count]];;
			[object enumerateObjectsUsingBlock:^(id childObject, NSUInteger index, BOOL *stop) {
				OutlineObject *child = [self parseJsonObject:childObject withKey:@"Object"];
				
				[oObj.children addObject:child];
			}];
		}
	} else {
		oObj.value = object;
	}
	
	return oObj;
}

- (void)parseDataJson {
	NSError *error = nil;
	id json = [received yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
	self.jsonArray = nil;
	self.jsonArray = [NSMutableArray array];
	
	if ([json isKindOfClass:[NSDictionary class]]) {
		[json enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			OutlineObject *oObj = [self parseJsonObject:object withKey:key];
			
			[self.jsonArray addObject:oObj];
		}];
		
	} else {
		[json enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			OutlineObject *oObj = [self parseJsonObject:object withKey:@"Object"];
			
			[self.jsonArray addObject:oObj];
		}];
	}
	
	if (!error && [self.jsonArray count] > 0) {
		self.statusMessage = [NSString stringWithFormat:@"%d items", [self.jsonArray count]];
		
	} else {
		self.statusMessage = [NSString stringWithFormat:@"Error - Not JSON! (%@)", [error localizedDescription]];
	}
	[jsonView reloadData];
	[received release];
	self.isLoading = NO;
}

- (void)parseDataXml {
	self.statusMessage = @"Got some XML!";
	NSLog(@"XML");
	
	self.jsonArray = nil;
	self.jsonArray = [NSMutableArray array];
	
	NSXMLDocument *xml;
	NSError *error = nil;
	
	NSString *xmlData = [[NSString alloc] initWithBytes:[received bytes] length:[received length] encoding:NSStringEncodingConversionAllowLossy];
	
	xml = [[NSXMLDocument alloc] initWithXMLString:xmlData options:(NSXMLNodePreserveWhitespace|NSXMLNodePreserveCDATA) error:&error];
	
	int i, count = [[xml rootElement] childCount];
	NSLog(@"children of root: %d", count);
	
	for (i = 0; i < count; i++) {
		NSXMLNode *child = [[xml rootElement] childAtIndex:i];
		OutlineObject *o = [[OutlineObject alloc] init];
		o.name = [child name];
		
		int j, childs = [child childCount];
		if (childs > 0) {
			o.children = [NSMutableArray array];
			for (j = 0; j < childs; j++) {
				NSXMLNode *sibling = [child childAtIndex:j];
				OutlineObject *sib = [[OutlineObject alloc] init];
				
				sib.name = [sibling name];
				sib.value = [sibling stringValue];
				
				[o.children addObject:sib];
				
				[sib release];
			}
		}
		
		[self.jsonArray addObject:o];
		[o release];
	}
	
	[xml release];
	[jsonView reloadData];
	[received release];
	self.isLoading = NO;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	[[[RawDataWindow sharedDataWindow] textView] setString:[NSString stringWithUTF8String:[received bytes]]];
	
	
	switch (parseType) {
		case contentTypeXml:
			[self parseDataXml];
			break;
		case contentTypeJson:
			[self parseDataJson];
			break;
		default:
			self.statusMessage = @"Error - Unknown content type";
			self.jsonArray = nil;
			[jsonView reloadData];
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
		return [jsonArray count];
	} else if ([item children] != nil) {
		return [[item children] count];
	}
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	if (item != nil) {
		return [[item children] objectAtIndex:index];
	}
	return [jsonArray objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if (item && ([item children] != nil)) {
		return YES;
	}
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([(NSString*)[tableColumn identifier] isEqual:@"key"]) {
		return [(OutlineObject *)item name];
	} 
	
	return [(OutlineObject *)item value];
}

- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
	OutlineObject *item = [jsonView itemAtRow:[jsonView selectedRow]];
	
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
		
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}
@end
