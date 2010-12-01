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
@synthesize urlField, resultsView, jsonView, goButton, jsonArray, isLoading, statusMessage;

- (id) init
{
	self = [super init];
	if (self != nil) {
		jsonArray = [[NSMutableArray array] retain];
		[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];	
	}
	return self;
}

- (NSString *)nibName {
	NSLog(@"oh hai!");
	return @"HttpGetViewController";
}

- (void)dealloc {
	
	[urlField release];
	[resultsView release];
	[goButton release];
	
	[jsonArray dealloc];
	
    [super dealloc];
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
	NSLog(@"Parsing %@, %@", key, [object className]);
	OutlineObject *oObj = [[OutlineObject alloc] init];
	oObj.name = key;
	
	if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
		oObj.children = [NSMutableArray array];
		
		if ([object isKindOfClass:[NSDictionary class]]) {
			oObj.value = [NSString stringWithFormat:@"%d items", [[object allKeys] count]];
			[object enumerateKeysAndObjectsUsingBlock:^(id key, id childObject, BOOL *stop) {
				OutlineObject *child = [self parseJsonObject:childObject withKey:key];
				
				[oObj.children addObject:child];
				[child release];
			}];
		} else {
			oObj.value = [NSString stringWithFormat:@"%d items", [object count]];;
			[object enumerateObjectsUsingBlock:^(id childObject, NSUInteger index, BOOL *stop) {
				OutlineObject *child = [self parseJsonObject:childObject withKey:@"Object"];
				
				[oObj.children addObject:child];
				[child release];
			}];
		}
	} else {
		oObj.value = object;
	}
	
	return oObj;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	//self.resultsView.string = [NSString stringWithUTF8String:[received mutableBytes]];
	
	NSError *error = nil;
	
	id json = [received yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
	self.jsonArray = nil;
	self.jsonArray = [NSMutableArray array];
	
	if ([json isKindOfClass:[NSDictionary class]]) {
		NSLog(@"Received dictionary, parsing!");
		//self.jsonArray = [NSArray arrayWithObject:json];
		[json enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			OutlineObject *oObj = [self parseJsonObject:object withKey:key];
			
//			[[OutlineObject alloc] init];
//			oObj.name = key;
//			
//			if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
//				oObj.children = [NSMutableArray array];
//				
//				if ([object isKindOfClass:[NSDictionary class]]) {
//					[object enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
//						
//					}];
//				} else {
//					[object enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
//					
//					}];
//				}
//			} else {
//				oObj.value = object;
//			}
			
			[self.jsonArray addObject:oObj];
			//[oObj release];
		}];
				
	} else {
		//self.jsonArray = json;		
		[json enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
			OutlineObject *oObj = [self parseJsonObject:object withKey:@"Object"];
			
			//			[[OutlineObject alloc] init];
			//			oObj.name = key;
			//			
			//			if ([object isKindOfClass:[NSDictionary class]] || [object isKindOfClass:[NSArray class]]) {
			//				oObj.children = [NSMutableArray array];
			//				
			//				if ([object isKindOfClass:[NSDictionary class]]) {
			//					[object enumerateKeysAndObjectsUsingBlock:^(id key, id object, BOOL *stop) {
			//						
			//					}];
			//				} else {
			//					[object enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
			//					
			//					}];
			//				}
			//			} else {
			//				oObj.value = object;
			//			}
			
			[self.jsonArray addObject:oObj];
			//[oObj release];
		}];
	}
	NSLog(@"here i am");
	if (!error && [self.jsonArray count] > 0) {
		//delegate.dataWindow.textView.string = [self.jsonArray description];
		[[[RawDataWindow sharedDataWindow] textView] setString:[self.jsonArray description]];
		
		self.statusMessage = [NSString stringWithFormat:@"%d items", [self.jsonArray count]];
		
		//		NSDictionary *o = [self.jsonArray objectAtIndex:0];
		//		o = [o objectForKey:[[o allKeys] objectAtIndex:0]];
		
		//NSLog(@"first object is type of: %@", [[jsonArray objectAtIndex:0] className]);
		//NSLog(@"first object's first object is type of: %@ (key: %@, value: %@)", [[o objectForKey:[[o allKeys] objectAtIndex:0]] className], [[o allKeys] objectAtIndex:0], [o objectForKey:[[o allKeys] objectAtIndex:0]]);
		
		[jsonView reloadData];
	} else {
		//delegate.dataWindow.textView.string = @"";
		//		self.statusLabel.stringValue = [NSString stringWithFormat:@"Error - Not JSON! (%@)", [error localizedDescription]];
		
		[[[RawDataWindow sharedDataWindow] textView] setString:@""];
	}
	
	
//	[progressIndicator stopAnimation:nil];
	
	[connection release];
	[received release];
	
	self.isLoading = NO;
}

#pragma mark -
#pragma mark Outline view data source methods
#pragma mark -

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	NSLog(@"num for %@", [item className]);
	if (item == nil) {
		NSLog(@"toplevel count: %d", [jsonArray count]);
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
	NSLog(@"does it expand? %@", [item className]);
	
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
