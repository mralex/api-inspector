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

- (id) init
{
	self = [super init];
	if (self != nil) {
		jsonArray = [[NSMutableArray array] retain];
		[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];	
	}
	return self;
}

- (void) loadView {
	[super loadView];
	
	[self.resultsView setFont:[NSFont userFixedPitchFontOfSize:11]];

}

- (NSString *)nibName {
	NSLog(@"oh hai!");
	return @"HttpGetViewController";
}

//- (void)dealloc {
//	
//	[urlField release];
//	[resultsView release];
//	[goButton release];
//	
//	[jsonArray dealloc];
//	
//    [super dealloc];
//}


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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
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

	[[[RawDataWindow sharedDataWindow] textView] setString:[NSString stringWithUTF8String:[received bytes]]];
	[jsonView reloadData];
	
	[connection release];
	[received release];
	
	self.isLoading = NO;
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
