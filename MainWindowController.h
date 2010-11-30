//
//  MainWindowController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface MainWindowController : NSWindowController {
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;

	NSTextField *urlField;
	NSButton *goButton;
	NSOutlineView *jsonView;
	NSTextView *resultsView;

	NSMutableData *received;
	NSArray *jsonArray;
	
	BOOL isLoading;
	
	id delegate;
}

@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSOutlineView *jsonView;

@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain) NSArray *jsonArray;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, retain) id delegate;

- (IBAction)goAction:sender;

@end
