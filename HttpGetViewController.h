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

enum ContentTypes {
	contentTypeJson,
	contentTypeXml
};

@interface HttpGetViewController : HttpViewController <NSComboBoxDelegate> {
	NSComboBox *urlField;
	NSButton *goButton;
	NSOutlineView *dataView;
	NSTextView *resultsView;
	
	NSMutableData *received;
	NSMutableArray *dataArray;

	NSString *contentType;
	int parseType;
}

@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSComboBox *urlField;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSOutlineView *dataView;

@property (nonatomic, retain) NSMutableArray *dataArray;

@property (nonatomic, retain) NSString *contentType;

- (IBAction)goAction:sender;

- (TreeNode *)parseJsonObject:(id)object withKey:(id)key;
- (TreeNode *)traverseXmlNode:(NSXMLNode *)node;

- (void)parseDataJson;
- (void)parseDataXml;
- (void)parsingDidFinishWithMessage:(NSString *)message;

@end
