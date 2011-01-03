//
//  HttpGetViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HttpViewController.h"

@class TreeNode;

@interface HttpGetViewController : HttpViewController <NSComboBoxDelegate> {
	NSOutlineView *dataView;
	NSTextView *resultsView;
	
	NSMutableArray *dataArray;
}

@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSOutlineView *dataView;

@property (nonatomic, retain) NSMutableArray *dataArray;

- (IBAction)goAction:sender;

- (TreeNode *)parseJsonObject:(id)object withKey:(id)key;
- (TreeNode *)traverseXmlNode:(NSXMLNode *)node;

- (void)parseDataJson;
- (void)parseDataXml;
- (void)parsingDidFinishWithMessage:(NSString *)message;

@end
