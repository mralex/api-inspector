//
//  HttpPostViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 12/2/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HttpPostViewController : NSViewController {
	NSTextField *urlField;
	NSButton *goButton;
	NSTextView *bodyView;
	NSTextView *resultsView;

	NSMutableData *received;
	BOOL isLoading;
	NSString *statusMessage;
}

@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSTextView *bodyView;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *statusMessage;

-(IBAction)goAction:(id)sender;

@end
