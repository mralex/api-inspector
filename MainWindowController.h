//
//  MainWindowController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class HttpGetViewController;

@interface MainWindowController : NSWindowController {
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;

	NSView *contentBox;
	
	BOOL isLoading;
	
	id delegate;
	
	HttpGetViewController *httpGetViewController;
}


@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain) IBOutlet NSView *contentBox;
@property (nonatomic, retain) HttpGetViewController *httpGetViewController;

@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, retain) id delegate;


@end
