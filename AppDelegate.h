//
//  API_Inspector_AppDelegate.h
//  API Inspector
//
//  Created by Alex Roberts on 11/27/10.
//  Copyright Red Process 2010 . All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class MainWindowController;
@class RawDataWindow;

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    //NSWindow *window;
	
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
	

	//NSURLConnection *urlConnection;
	
	MainWindowController *mainWindow;
	RawDataWindow *dataWindow;
	
}

//@property (nonatomic, retain) IBOutlet NSWindow *window;

@property (nonatomic, retain) MainWindowController *mainWindow;

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet RawDataWindow *dataWindow;

//- (IBAction)saveAction:sender;

- (IBAction)showRawData:sender;

- (void)showMainWindow;

@end
