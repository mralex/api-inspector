//
//  API_Inspector_AppDelegate.h
//  API Inspector
//
//  Created by Alex Roberts on 11/27/10.
//  Copyright Red Process 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface API_Inspector_AppDelegate : NSObject 
{
    NSWindow *window;
	
	NSTextField *urlField;
	NSButton *goButton;
	
	NSOutlineView *jsonView;
	NSTextView *resultsView;
	NSTextField *statusLabel;
	NSProgressIndicator *progressIndicator;
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	
	NSMutableData *received;
	NSArray *jsonArray;
	//NSURLConnection *urlConnection;
	
	BOOL isLoading;
}

@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSOutlineView *jsonView;
@property (nonatomic, retain) IBOutlet NSTextField *statusLabel;
@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSProgressIndicator *progressIndicator;

@property (nonatomic, retain) NSArray *jsonArray;

@property (nonatomic, assign) BOOL isLoading;

//- (IBAction)saveAction:sender;

- (IBAction)goAction:sender;

@end
