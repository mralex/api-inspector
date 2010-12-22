//
//  HttpGetViewController.h
//  API Inspector
//
//  Created by Alex Roberts on 11/29/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class OutlineObject;

enum ContentTypes {
	contentTypeJson,
	contentTypeXml
};

@interface HttpGetViewController : NSViewController {
	NSTextField *urlField;
	NSButton *goButton;
	NSOutlineView *jsonView;
	NSTextView *resultsView;
	
	NSMutableData *received;
	NSMutableArray *jsonArray;

	BOOL isLoading;
	NSString *statusMessage;
	NSString *contentType;
	int parseType;
}

@property (nonatomic, retain) IBOutlet NSButton *goButton;
@property (nonatomic, retain) IBOutlet NSTextField *urlField;
@property (nonatomic, retain) IBOutlet NSTextView *resultsView;
@property (nonatomic, retain) IBOutlet NSOutlineView *jsonView;

@property (nonatomic, retain) NSMutableArray *jsonArray;

@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, retain) NSString *statusMessage;
@property (nonatomic, retain) NSString *contentType;

- (IBAction)goAction:sender;

- (OutlineObject *)parseJsonObject:(id)object withKey:(id)key;
- (OutlineObject *)traverseXmlNode:(NSXMLNode *)node;

- (void)parseDataJson;
- (void)parseDataXml;
- (void)parsingDidFinishWithMessage:(NSString *)message;

@end
