//
//  PreferencesWindowController.m
//  API Inspector
//
//  Created by Alex Roberts on 1/3/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import "PreferencesWindowController.h"

@implementation PreferencesWindowController

- (id) init
{
	self = [super initWithWindowNibName:@"PreferencesWindow"];
	if (self != nil) {
		
	}
	return self;
}

- (void)showWindow:(id)sender {
	if (![self.window isVisible])
		[self.window center];
	
	[self.window makeKeyAndOrderFront:self];
	[self.window makeFirstResponder:self.window];
}

@end
