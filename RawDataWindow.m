//
//  RawDataWindow.m
//  API Inspector
//
//  Created by Alex Roberts on 11/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "RawDataWindow.h"


@implementation RawDataWindow

@synthesize textView;

+ (RawDataWindow *)sharedDataWindow {
	static RawDataWindow *dataWindow = nil;
	
	if (dataWindow == nil) {
		dataWindow = [[RawDataWindow alloc] init];
	}
	
	return dataWindow;
}

- (id) init
{
	self = [super initWithWindowNibName:@"RawData" owner:self];
	if (self != nil) {

	}
	return self;
}

- (void)windowDidLoad {
	[self.textView setFont:[NSFont fontWithName:@"Menlo" size:11]];

}

@end
