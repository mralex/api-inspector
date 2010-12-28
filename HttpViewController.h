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

}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) IBOutlet NSArrayController *urlHistoryController;

//- (NSUInteger)indexOfItemInHistoryWithStringValue:(NSString *)value;
- (void)urlFieldChanged:(NSNotification *)aNotification;

- (void)viewWillSwitch;
- (void)viewDidSwitch;

@end
