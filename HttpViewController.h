//
//  HttpViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 12/27/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Bookmark;

@interface HttpViewController : NSViewController {
	NSManagedObjectContext *managedObjectContext;
	NSArrayController *urlHistoryController;
	
	NSComboBox *urlField;
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;
	NSButton *goButton;
	
	NSButton *oauthButton;
	NSPopUpButton *oauthPopup;

	BOOL isLoading;
	NSString *statusMessage;

	NSMutableData *received;

	NSString *contentType;
	int parseType;
	BOOL urlFieldHasUrl;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSComboBox *urlField;
@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;
@property (nonatomic, retain) IBOutlet NSButton *goButton;

@property (nonatomic, retain) IBOutlet NSButton *oauthButton;
@property (nonatomic, retain) IBOutlet NSPopUpButton *oauthPopup;

@property (nonatomic, retain, readonly) NSString *currentUrl;

@property (nonatomic, retain) IBOutlet NSArrayController *urlHistoryController;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL urlFieldHasUrl;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSString *contentType;

//- (NSUInteger)indexOfItemInHistoryWithStringValue:(NSString *)value;
- (BOOL)updateUrlSelection;
- (void)urlFieldChanged:(NSNotification *)aNotification;

- (void)viewWillDisappear;
- (void)viewDidDisappear;
- (void)viewWillAppear;
- (void)viewDidAppear;

- (void)loadWithBookmark:(Bookmark *)bookmark openUrl:(BOOL)opening;

@end
