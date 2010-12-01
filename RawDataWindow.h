//
//  RawDataWindow.h
//  API Inspector
//
//  Created by Alex Roberts on 11/28/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface RawDataWindow : NSWindowController {
	NSTextView *textView;
	NSTextField *contentTypeField;
}

@property (nonatomic, retain) IBOutlet NSTextView *textView;
@property (nonatomic, retain) IBOutlet NSTextField *contentTypeField;

+(RawDataWindow *)sharedDataWindow;

@end
