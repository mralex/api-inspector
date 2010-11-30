//
//  HttpGetViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "HttpGetViewController.h"
#import "RawDataWindow.h"


@implementation HttpGetViewController
@synthesize urlField, resultsView, jsonView, goButton, jsonArray, isLoading, statusMessage;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.jsonArray = [NSArray array];
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	//self.resultsView.string = [NSString stringWithUTF8String:[received mutableBytes]];
	
	NSError *error = nil;
	
	self.jsonArray = [received yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
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
	if (item == nil) {
		return [jsonArray count];
	} else if ([item isKindOfClass:[NSArray class]]) {
		//NSString *key = [[item allKeys] objectAtIndex:0];
		//return [[[item objectForKey:key] allKeys] count];
		
		if ([[item objectAtIndex:1] isKindOfClass:[NSDictionary class]]) {
			return [[[item  objectAtIndex:1] allKeys] count];
		}
	} else if ([item isKindOfClass:[NSDictionary class]]) {
		return [[item allKeys] count];
	}
	
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	NSString *key;
	
	if ([item isKindOfClass:[NSDictionary class]]) {
		key = [[item allKeys] objectAtIndex:index];
		
		//		if ([[item objectForKey:key] isKindOfClass:[NSDictionary class]]) {
		//			return [item objectForKey:key];
		//		}
		
		return [[NSArray arrayWithObjects:key, [item objectForKey:key], nil] retain];
	} else if ([item isKindOfClass:[NSArray class]]) {
		NSDictionary *dict = [item objectAtIndex:1];
		key = [[dict allKeys] objectAtIndex:index];
		return [[NSArray arrayWithObjects:key, [dict objectForKey:key], nil] retain];
	}
	
	return [jsonArray objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if (item && ([item isKindOfClass:[NSDictionary class]] || [[item objectAtIndex:1] isKindOfClass:[NSDictionary class]])) {
		return YES;
	}
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([(NSString*)[tableColumn identifier] isEqual:@"key"]) {
		if ([item isKindOfClass:[NSArray class]]) {
			NSString *key = [item objectAtIndex:0];
			if ([key length] == 0) {
				key = @"Object";
			}
			
			return key;
		}
		return @"Object";
	} 
	
	if ([item isKindOfClass:[NSArray class]]) {
		if ([[item objectAtIndex:1] isKindOfClass:[NSDictionary class]]) {
			return nil; //[[[item objectAtIndex:1] allKeys] objectAtIndex:0];
		}
		return [item objectAtIndex:1];
	}
	
	return nil;
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
