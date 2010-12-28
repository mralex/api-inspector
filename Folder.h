//
//  Folder.h
//  API Inspector
//
//  Created by Alex Roberts on 12/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Folder : NSObject {
	NSString *name;
	NSImage *icon;
	
	NSMutableArray *items;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, retain) NSMutableArray *items;

- (id) initWithName:(NSString *)aName;

@end
