//
//  HttpViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 12/27/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HttpViewController : NSViewController {
	NSManagedObjectContext *managedObjectContext;
	NSArrayController *urlHistoryController;
	
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;

	BOOL isLoading;
	NSString *statusMessage;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain, readonly) NSString *currentUrl;

@property (nonatomic, retain) IBOutlet NSArrayController *urlHistoryController;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *statusMessage;

//- (NSUInteger)indexOfItemInHistoryWithStringValue:(NSString *)value;
- (void)urlFieldChanged:(NSNotification *)aNotification;

- (void)viewWillSwitch;
- (void)viewDidSwitch;

- (void)loadWithURL:(NSString *)aUrl;

@end
