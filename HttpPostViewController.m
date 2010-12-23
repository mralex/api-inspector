//
//  HttpPostViewController.m
//  API Inspector
//
//  Created by Alex Roberts on 12/2/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "HttpPostViewController.h"


@implementation HttpPostViewController
@synthesize goButton, urlField, bodyView, resultsView, isLoading, statusMessage;


- (void) loadView {
	[super loadView];
	
	[self.bodyView setFont:[NSFont userFixedPitchFontOfSize:11]];	
	[self.resultsView setFont:[NSFont userFixedPitchFontOfSize:11]];
}

-(IBAction)goAction:(id)sender {
	if (self.isLoading) return;
	
	NSLog(@"POST Go!");
	
	//	[progressIndicator startAnimation:nil];
	self.statusMessage = @"Connecting...";
	
	self.isLoading = YES;
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlField.stringValue] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[[self.bodyView string] dataUsingEncoding:NSUTF8StringEncoding]];
	
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
@end
