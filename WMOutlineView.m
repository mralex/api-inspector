//
//  WMTableView.m
//  WriteMe
//
//  Created by Alex Roberts on 9/11/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "WMOutlineView.h"


@implementation WMOutlineView

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	
	if (self != nil) {
		//[self setIntercellSpacing:NSMakeSize(0, 5.0)];
	}
	
	return self;
}

- (NSMenu *)menuForEvent:(NSEvent *)event {

	NSPoint mousePoint = [self convertPoint:[event locationInWindow] fromView:nil];
	
	int row = [self rowAtPoint:mousePoint];
	DLog(@"Menu? %d", row);
	[self deselectAll:nil];

	if (row >= 1) {
		[self selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
	} else {
		return nil;
	}
	
	return [self menu];
}

- (void)mouseDown:(NSEvent *)theEvent {
	NSPoint mousePoint = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	
	int row = [self rowAtPoint:mousePoint];
	if (row == -1) [self deselectAll:nil];
	
	[super mouseDown:theEvent];
}

@end
