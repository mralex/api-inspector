//
//  NewAuthWindowController.h
//  Action Spy
//
//  Created by Alex Roberts on 1/9/11.
//  Copyright 2011 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Authentication;

@interface NewAuthWindowController : NSWindowController {
	NSManagedObjectContext *managedObjectContext;
	NSManagedObjectContext *parentManagedObjectContext;
	NSObjectController *accountController;
	NSArrayController *accountsArrayController;

	Authentication *authentication;
	
	NSMutableArray *pageQueue;
	NSNumber *currentPage;
	
	NSProgressIndicator *loadingIndicator;
	NSTextField *loadingLabel;
	
	NSTabView *pages;
	
	NSTextField *accountNameField;
	NSPopUpButton *authTypePopUpButton;
	
	NSTextField *accountUsernameField;
	NSTextField *accountPasswordField;
	NSButton *useHttpsButton;
	
	NSTextField *oauthConsumerKeyField;
	NSTextField *oauthConsumerSecretField;
	NSTextField *oauthTokenRequestUrlField;
	NSTextField *oauthUserAuthUrlField;
	NSTextField *oauthAccessTokenUrlField;
	
	WebView *webView;
	
	WebView *oauthPinWebView;
	NSTextField *oauthPinField;
}
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) IBOutlet NSManagedObjectContext *parentManagedObjectContext;

@property (nonatomic, retain) IBOutlet NSArrayController *accountsArrayController;
@property (nonatomic, retain) IBOutlet NSObjectController *accountController;

@property (nonatomic, retain) Authentication *authentication;

@property (nonatomic, retain) NSMutableArray *pageQueue;
@property (nonatomic, retain) NSNumber *currentPage;

@property (nonatomic, retain) IBOutlet NSTabView *pages;

@property (nonatomic, retain) IBOutlet NSProgressIndicator *loadingIndicator;
@property (nonatomic, retain) IBOutlet NSTextField *loadingLabel;

@property (nonatomic, retain) IBOutlet NSPopUpButton *authTypePopUpButton;
@property (nonatomic, retain) IBOutlet NSTextField *accountNameField;

@property (nonatomic, retain) IBOutlet NSTextField *accountUsernameField;
@property (nonatomic, retain) IBOutlet NSTextField *accountPasswordField;
@property (nonatomic, retain) IBOutlet NSButton *useHttpsButton;

@property (nonatomic, retain) IBOutlet NSTextField *oauthConsumerKeyField;
@property (nonatomic, retain) IBOutlet NSTextField *oauthConsumerSecretField;
@property (nonatomic, retain) IBOutlet NSTextField *oauthTokenRequestUrlField;
@property (nonatomic, retain) IBOutlet NSTextField *oauthUserAuthUrlField;
@property (nonatomic, retain) IBOutlet NSTextField *oauthAccessTokenUrlField;

@property (nonatomic, retain) IBOutlet WebView *webView;

@property (nonatomic, retain) IBOutlet WebView *oauthPinWebView;
@property (nonatomic, retain) IBOutlet NSTextField *oauthPinField;

- (void)pushPage:(id)item;
- (id)popPage;

- (IBAction)add:(id)sender;

- (IBAction)complete:(id)sender;
- (IBAction)cancelOperation:(id)sender;

- (IBAction)next:(id)sender;
- (IBAction)previous:(id)sender;
@end
