/*
 *  constants.h
 *  API Inspector
 *
 *  Created by Alex Roberts on 12/27/10.
 *  Copyright 2010 Red Process. All rights reserved.
 *
 */

#define kHttpViewGet 1
#define kHttpViewPost 2

#define kHttpPostKeys	@"httpPostKeys"
#define kHttpPostValues	@"httpPostValues"

#define AS_PBOARD_TYPE @"ASSourceListPBoardType"

enum ContentTypes {
	contentTypeJson,
	contentTypeXml,
	contentTypeHtml
};

enum BookmarkLaunchClicks {
	singleClickBookmark,
	doubleClickBookmark
};

enum AuthTypes {
	authTypeOAuth,
	authTypeBasic
};
