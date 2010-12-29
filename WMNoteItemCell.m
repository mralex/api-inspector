//
//  WMNoteItemCell.m
//  WriteMe
//
//  Created by Alex Roberts on 9/13/10.
//  Copyright 2010 Red Process. All rights reserved.
//

#import "WMNoteItemCell.h"


@implementation WMNoteItemCell
@synthesize cellIcon;

- (id)initTextCell:(NSString *)aString {
	self = [super initTextCell:aString];
	
	if (self != nil) {
		self.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [super initWithCoder:decoder];
	
	if (self != nil) {
		self.font = [NSFont systemFontOfSize:[NSFont smallSystemFontSize]];
	}
	return self;
}

- (void) drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    if (self.cellIcon) {
		NSRect iconRect = NSInsetRect(cellFrame, 3, 2);
		
		// note - icon display is currently fixed to 16 x 16 image
		
		iconRect.origin.y += floor((NSHeight(iconRect) - 15) * 0.5);
		iconRect.size.width = iconRect.size.height = 16;
		
        if ([self drawsBackground])
		{
            [[self backgroundColor] set];
            NSRectFill(iconRect);
        }
		
		[self.cellIcon setFlipped:[controlView isFlipped]];
		[self.cellIcon drawInRect:iconRect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
		
		cellFrame.origin.x += NSWidth(iconRect) + 6;
		cellFrame.size.width -= (NSWidth(iconRect) + 6);
    }
    
	[super drawWithFrame:cellFrame inView:controlView];
}

- (NSRect) drawingRectForBounds:(NSRect)theRect
{
	// Get the parent's idea of where we should draw
	NSRect newRect = [super drawingRectForBounds:theRect];
	
	// Get our ideal size for current text
	NSSize textSize = [self cellSizeForBounds:theRect];
	
	// Center that in the proposed rect
	float heightDelta = newRect.size.height - textSize.height;	
	
	if (heightDelta > 0)
	{
		newRect.size.height -= heightDelta;
		newRect.origin.y += (heightDelta / 2);
	}
	
	return newRect;
}

- (id) copyWithZone:(NSZone*) zone
{
    WMNoteItemCell *cell = [super copyWithZone:zone];
    cell.cellIcon = [self.cellIcon retain];
    
	return cell;
}

- (void) dealloc {
	[cellIcon release];
	[super dealloc];
}
@end
