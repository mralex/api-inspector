//
//  HttpPostViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 12/2/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HttpViewController.h"


@interface HttpPostViewController : HttpViewController {
	NSTextField *urlField;
	NSTextView *bodyView;
	NSTextView *resultsView;
	NSTableView *valuesTable;

	NSButton *goButton;
	NSButton *addButton;
	NSButton *removeButton;
	
	NSMutableData *received;
	BOOL isLoading;
	NSString *statusMessage;
	
	NSMutableArray *keysArray;
	NSMutableArray *valuesArray;
}

@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSTextView *bodyView;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSTableView *valuesTable;
@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSButton *addButton;
@property (nonatomic, retain) IBOutlet NSButton *removeButton;
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *statusMessage;

@property (nonatomic, retain) NSMutableArray *keysArray;
@property (nonatomic, retain) NSMutableArray *valuesArray;

-(IBAction)goAction:(id)sender;

-(IBAction)addAction:(id)sender;
-(IBAction)removeAction:(id)sender;

@end
