/*
 *  debug.h
 *  Mercury
 *
 *  Created by Alex Roberts on 3/11/09.
 *  Copyright 2009 Red Process. All rights reserved.
 *
 */

#ifdef DEBUG
	#define DLog(s, ...) NSLog( @"<%p %s:(%d)> %@", self, __PRETTY_FUNCTION__, __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
	#define DLog(s, ...)
#endif
