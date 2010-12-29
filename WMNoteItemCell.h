//
//  WMNoteItemCell.h
//  WriteMe
//
//  Created by Alex Roberts on 9/13/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface WMNoteItemCell : NSTextFieldCell<NSCopying> {
	NSImage*		cellIcon;
}

@property (nonatomic, retain) NSImage *cellIcon;

@end
