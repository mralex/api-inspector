//
//  PreferencesWindowController.m
//  API Inspector
//
//  Created by Alex Roberts on 1/3/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import "PreferencesWindowController.h"

static PreferencesWindowController *_prefsController = nil;

@implementation PreferencesWindowController

+ (PreferencesWindowController *) sharedPreferencesWindowController {
	if (_prefsController == nil) {
		_prefsController = [[PreferencesWindowController alloc] initWithWindowNibName:@"PreferencesWindow"];
	}
	
	return _prefsController;
}

@end
