//
//  OutlineObject.h
//  API Inspector
//
//  Created by Alex Roberts on 11/30/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TreeNode : NSObject {
	NSString *name;
	id value;
	
	NSMutableArray *children;
}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) id value;
@property (nonatomic, retain) NSMutableArray *children;

@end
