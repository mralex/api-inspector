//
//  HttpGetViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HttpGetViewController : NSViewController {
	NSTextField *urlField;
	NSButton *goButton;
	NSOutlineView *jsonView;
	NSTextView *resultsView;
	
	NSMutableData *received;
	NSArray *jsonArray;

	BOOL isLoading;
	NSString *statusMessage;
}

@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSOutlineView *jsonView;

@property (nonatomic, retain) NSArray *jsonArray;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *statusMessage;

- (IBAction)goAction:sender;

@end
