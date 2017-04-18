//
//  SUCWrapper.h
//  Sparkle
//
//  Created by Thomas Tempelmann on 21.10.16.
//
//

#ifndef SUCWrapper_h
#define SUCWrapper_h

void SUCInit(void);
void SUCCheckForUpdatesVerbosely (void);
void SUCCheckForUpdatesSilently (void);
bool SUCIsUpdateInProgress (void);

typedef NSString* (*feedURLForUpdaterFunc) (void);
typedef NSString* (*downloadPathForUpdaterFunc) (void);
typedef void (*updateStatusFunc) (int status);	// 0: no update found, 1: update found, 2: about to install update
typedef NSArray* (*feedParametersForUpdaterFunc) (bool sendingProfile);

void SUCSetStatusCallback (updateStatusFunc f);
void SUCSetFeedURLCallback (feedURLForUpdaterFunc f);
void SUCSetDownloadPathCallback (downloadPathForUpdaterFunc f);
//void SUCSetFeedParmsCallback (feedParametersForUpdaterFunc f);

#endif /* SUCWrapper_h */
