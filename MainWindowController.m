//
//  MainWindowController.m
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "MainWindowController.h"
#import "HttpGetViewController.h"

@implementation MainWindowController

@synthesize statusLabel,progressIndicator, contentBox, httpGetViewController;

- (id) init
{
	self = [super initWithWindowNibName:@"MainWindow"];
	if (self != nil) {
	}
	return self;
}

- (void)windowDidLoad {
	NSLog(@"window did load");
	self.httpGetViewController = [[HttpGetViewController alloc] init];
	[httpGetViewController addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];
	[httpGetViewController addObserver:self forKeyPath:@"statusMessage" options:(NSKeyValueObservingOptionNew) context:NULL];
	
	NSView *httpGetView = [self.httpGetViewController view];
	[httpGetView setFrame:[self.contentBox bounds]];
	[httpGetView setAutoresizingMask:(NSViewWidthSizable| NSViewHeightSizable)];
	[self.contentBox addSubview:httpGetView];
}

- (void)dealloc {
	
	[statusLabel release];
	[progressIndicator release];
	
    [super dealloc];
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			[self.progressIndicator startAnimation:self];
		} else {
			[self.progressIndicator stopAnimation:self];
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
