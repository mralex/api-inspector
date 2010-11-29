//
//  API_Inspector_AppDelegate.m
//  API Inspector
//
//  Created by Alex Roberts on 11/27/10.
//  Copyright Red Process 2010 . All rights reserved.
//

#import "API_Inspector_AppDelegate.h"
#import "RawDataWindow.h"

@implementation API_Inspector_AppDelegate

@synthesize window, urlField, resultsView, jsonView, statusLabel, goButton, progressIndicator, jsonArray, isLoading, dataWindow;

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.jsonArray = [NSArray array];
		self.isLoading = NO;
		
		[self addObserver:self forKeyPath:@"isLoading" options:(NSKeyValueObservingOptionNew) context:NULL];
		
		
		dataWindow = [[RawDataWindow alloc] initWithWindowNibName:@"RawData"];
	}
	return self;
}


/**
    Returns the support directory for the application, used to store the Core Data
    store file.  This code uses a directory named "API_Inspector" for
    the content, either in the NSApplicationSupportDirectory location or (if the
    former cannot be found), the system's temporary directory.
 */

- (NSString *)applicationSupportDirectory {

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : NSTemporaryDirectory();
    return [basePath stringByAppendingPathComponent:@"API_Inspector"];
}


/**
    Creates, retains, and returns the managed object model for the application 
    by merging all of the models found in the application bundle.
 */
 
- (NSManagedObjectModel *)managedObjectModel {

    if (managedObjectModel) return managedObjectModel;
	
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
    return managedObjectModel;
}


/**
    Returns the persistent store coordinator for the application.  This 
    implementation will create and return a coordinator, having added the 
    store for the application to it.  (The directory for the store is created, 
    if necessary.)
 */

- (NSPersistentStoreCoordinator *) persistentStoreCoordinator {

    if (persistentStoreCoordinator) return persistentStoreCoordinator;

    NSManagedObjectModel *mom = [self managedObjectModel];
    if (!mom) {
        NSAssert(NO, @"Managed object model is nil");
        NSLog(@"%@:%s No model to generate a store from", [self class], _cmd);
        return nil;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *applicationSupportDirectory = [self applicationSupportDirectory];
    NSError *error = nil;
    
    if ( ![fileManager fileExistsAtPath:applicationSupportDirectory isDirectory:NULL] ) {
		if (![fileManager createDirectoryAtPath:applicationSupportDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSAssert(NO, ([NSString stringWithFormat:@"Failed to create App Support directory %@ : %@", applicationSupportDirectory,error]));
            NSLog(@"Error creating application support directory at %@ : %@",applicationSupportDirectory,error);
            return nil;
		}
    }
    
    NSURL *url = [NSURL fileURLWithPath: [applicationSupportDirectory stringByAppendingPathComponent: @"storedata"]];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: mom];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSXMLStoreType 
                                                configuration:nil 
                                                URL:url 
                                                options:nil 
                                                error:&error]){
        [[NSApplication sharedApplication] presentError:error];
        [persistentStoreCoordinator release], persistentStoreCoordinator = nil;
        return nil;
    }    

    return persistentStoreCoordinator;
}

/**
    Returns the managed object context for the application (which is already
    bound to the persistent store coordinator for the application.) 
 */
 
- (NSManagedObjectContext *) managedObjectContext {

    if (managedObjectContext) return managedObjectContext;

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setValue:@"Failed to initialize the store" forKey:NSLocalizedDescriptionKey];
        [dict setValue:@"There was an error building up the data file." forKey:NSLocalizedFailureReasonErrorKey];
        NSError *error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        [[NSApplication sharedApplication] presentError:error];
        return nil;
    }
    managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator];

    return managedObjectContext;
}

/**
    Returns the NSUndoManager for the application.  In this case, the manager
    returned is that of the managed object context for the application.
 */
 
- (NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window {
    return [[self managedObjectContext] undoManager];
}


/**
    Performs the save action for the application, which is to send the save:
    message to the application's managed object context.  Any encountered errors
    are presented to the user.
 */
 
- (IBAction) saveAction:(id)sender {

    NSError *error = nil;
    
    if (![[self managedObjectContext] commitEditing]) {
        NSLog(@"%@:%s unable to commit editing before saving", [self class], _cmd);
    }

    if (![[self managedObjectContext] save:&error]) {
        [[NSApplication sharedApplication] presentError:error];
    }
}


/**
    Implementation of the applicationShouldTerminate: method, used here to
    handle the saving of changes in the application managed object context
    before the application terminates.
 */
 
- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {

    if (!managedObjectContext) return NSTerminateNow;

    if (![managedObjectContext commitEditing]) {
        NSLog(@"%@:%s unable to commit editing to terminate", [self class], _cmd);
        return NSTerminateCancel;
    }

    if (![managedObjectContext hasChanges]) return NSTerminateNow;

    NSError *error = nil;
    if (![managedObjectContext save:&error]) {
    
        // This error handling simply presents error information in a panel with an 
        // "Ok" button, which does not include any attempt at error recovery (meaning, 
        // attempting to fix the error.)  As a result, this implementation will 
        // present the information to the user and then follow up with a panel asking 
        // if the user wishes to "Quit Anyway", without saving the changes.

        // Typically, this process should be altered to include application-specific 
        // recovery steps.  
                
        BOOL result = [sender presentError:error];
        if (result) return NSTerminateCancel;

        NSString *question = NSLocalizedString(@"Could not save changes while quitting.  Quit anyway?", @"Quit without saves error question message");
        NSString *info = NSLocalizedString(@"Quitting now will lose any changes you have made since the last successful save", @"Quit without saves error question info");
        NSString *quitButton = NSLocalizedString(@"Quit anyway", @"Quit anyway button title");
        NSString *cancelButton = NSLocalizedString(@"Cancel", @"Cancel button title");
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:question];
        [alert setInformativeText:info];
        [alert addButtonWithTitle:quitButton];
        [alert addButtonWithTitle:cancelButton];

        NSInteger answer = [alert runModal];
        [alert release];
        alert = nil;
        
        if (answer == NSAlertAlternateReturn) return NSTerminateCancel;

    }

    return NSTerminateNow;
}


/**
    Implementation of dealloc, to release the retained variables.
 */
 
- (void)dealloc {

    [window release];
	
	[urlField release];
	[resultsView release];
	[statusLabel release];
	[goButton release];
	[progressIndicator release];
	
    [managedObjectContext release];
    [persistentStoreCoordinator release];
    [managedObjectModel release];
	
	[jsonArray dealloc];
	
    [super dealloc];
}

#pragma mark -
#pragma mark URL Handling
#pragma mark -

- (IBAction)goAction:sender {
	if (self.isLoading) return;
	
	NSLog(@"Go!");
	
	[progressIndicator startAnimation:nil];
	self.statusLabel.stringValue = @"Connecting...";
	
	self.isLoading = YES;
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlField.stringValue] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		received = [[NSMutableData data] retain];
	} else {
		[connection release];
		self.statusLabel.stringValue = @"Connection failed";
		
		self.isLoading = NO;
	}
}

- (IBAction)showRawData:sender {
	[dataWindow showWindow:nil];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	self.statusLabel.stringValue = @"Loading...";
	[received setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[received appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // release the connection, and the data object
    [connection release];
    // receivedData is declared as a method instance elsewhere
    [received release];
	
	self.isLoading = NO;
	
    // inform the user
    self.statusLabel.stringValue = [NSString stringWithFormat:@"Connection failed! %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
	
	self.dataWindow.textView.string = @"";
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	//self.resultsView.string = [NSString stringWithUTF8String:[received mutableBytes]];
	
	NSError *error = nil;
	
	self.jsonArray = [received yajl_JSONWithOptions:YAJLParserOptionsNone error:&error];
	
	if (!error && [self.jsonArray count] > 0) {
		self.dataWindow.textView.string = [self.jsonArray description];
		
		self.statusLabel.stringValue = [NSString stringWithFormat:@"%d items", [self.jsonArray count]];
		
//		NSDictionary *o = [self.jsonArray objectAtIndex:0];
//		o = [o objectForKey:[[o allKeys] objectAtIndex:0]];
		
		//NSLog(@"first object is type of: %@", [[jsonArray objectAtIndex:0] className]);
		//NSLog(@"first object's first object is type of: %@ (key: %@, value: %@)", [[o objectForKey:[[o allKeys] objectAtIndex:0]] className], [[o allKeys] objectAtIndex:0], [o objectForKey:[[o allKeys] objectAtIndex:0]]);
		
		[jsonView reloadData];
	} else {
		self.dataWindow.textView.string = @"";
		self.statusLabel.stringValue = [NSString stringWithFormat:@"Error - Not JSON! (%@)", [error localizedDescription]];
	}
	
		
	[progressIndicator stopAnimation:nil];
	
	[connection release];
	[received release];
	
	self.isLoading = NO;
}

#pragma mark -
#pragma mark Outline view data source methods
#pragma mark -

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if (item == nil) {
		return [jsonArray count];
	} else if ([item isKindOfClass:[NSArray class]]) {
		//NSString *key = [[item allKeys] objectAtIndex:0];
		//return [[[item objectForKey:key] allKeys] count];
		
		if ([[item objectAtIndex:1] isKindOfClass:[NSDictionary class]]) {
			return [[[item  objectAtIndex:1] allKeys] count];
		}
	} else if ([item isKindOfClass:[NSDictionary class]]) {
		return [[item allKeys] count];
	}
	
	return 0;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
	NSString *key;
	
	if ([item isKindOfClass:[NSDictionary class]]) {
		key = [[item allKeys] objectAtIndex:index];
		
//		if ([[item objectForKey:key] isKindOfClass:[NSDictionary class]]) {
//			return [item objectForKey:key];
//		}
		
		return [[NSArray arrayWithObjects:key, [item objectForKey:key], nil] retain];
	} else if ([item isKindOfClass:[NSArray class]]) {
		NSDictionary *dict = [item objectAtIndex:1];
		key = [[dict allKeys] objectAtIndex:index];
		return [[NSArray arrayWithObjects:key, [dict objectForKey:key], nil] retain];
	}
	
	return [jsonArray objectAtIndex:index];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	if (item && ([item isKindOfClass:[NSDictionary class]] || [[item objectAtIndex:1] isKindOfClass:[NSDictionary class]])) {
		return YES;
	}
	return NO;
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	if ([(NSString*)[tableColumn identifier] isEqual:@"key"]) {
		if ([item isKindOfClass:[NSArray class]]) {
			NSString *key = [item objectAtIndex:0];
			if ([key length] == 0) {
				key = @"Object";
			}
			
			return key;
		}
		return @"Object";
	} 
	
	if ([item isKindOfClass:[NSArray class]]) {
		if ([[item objectAtIndex:1] isKindOfClass:[NSDictionary class]]) {
			return nil; //[[[item objectAtIndex:1] allKeys] objectAtIndex:0];
		}
		return [item objectAtIndex:1];
	}
	
	return nil;
}


#pragma mark -

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ([keyPath isEqual:@"isLoading"]) {
		BOOL loading = [(NSNumber*)[change objectForKey:NSKeyValueChangeNewKey] boolValue];
		
		if (loading) {
			[self.goButton setEnabled:NO];
		} else {
			[self.goButton setEnabled:YES];
		}
		
		return;
	}
	
	[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

@end
