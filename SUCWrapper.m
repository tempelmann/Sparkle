//
//  SUCWrapper.m
//  Sparkle
//
//  Created by Thomas Tempelmann on 21.10.16.
//
//	A plain C wrapper for users that like to avoid the ObjC runtime to handle these calls.
//

#import "SUCWrapper.h"
#import "SUUpdater.h"

@interface SUCWrapperDelegate : NSObject {}
@end

static SUUpdater *updater = nil;
static SUCWrapperDelegate *ourDelegate = nil;

void SUCInit(void)
{
	updater = [SUUpdater sharedUpdater];
	if (!ourDelegate) {
		ourDelegate = [SUCWrapperDelegate new];
		updater.delegate = ourDelegate;
	}
}

void SUCCheckForUpdatesVerbosely (void)
{
	[updater checkForUpdates:nil];
}

void SUCCheckForUpdatesSilently (void)
{
	[updater checkForUpdatesSilently:nil];
}

bool SUCIsUpdateInProgress (void)
{
	return [updater updateInProgress];
}

//static feedParametersForUpdaterFunc feedParametersForUpdater = nil;
static updateStatusFunc updateStatus = nil;
static feedURLForUpdaterFunc feedURLForUpdater = nil;

void SUCSetStatusCallback (updateStatusFunc f)
{
	updateStatus = f;
}

void SUCSetFeedURLCallback (feedURLForUpdaterFunc f)
{
	feedURLForUpdater = f;
}

/*
void SUCSetFeedParmsCallback (feedParametersForUpdaterFunc f)
{
	feedParametersForUpdater = f;
}
*/

@implementation SUCWrapperDelegate
	// Use this to keep Sparkle from popping up e.g. while your setup assistant is showing:
	//- (BOOL)updaterMayCheckForUpdates:(SUUpdater *)bundle { }

	// This method allows you to add extra parameters to the appcast URL, potentially based on whether or not Sparkle will also be sending along the system profile. This method should return an array of dictionaries with keys: "key", "value", "displayKey", "displayValue", the latter two being specifically for display to the user.
	//- (NSArray *)feedParametersForUpdater:(SUUpdater *)updater sendingSystemProfile:(BOOL)sendingProfile { }

	// Override this to dynamically specify the entire URL.
	- (NSString*)feedURLStringForUpdater:(SUUpdater*)updater {
		if (feedURLForUpdater) {
			return feedURLForUpdater();
		}
		return nil;
	}

	// Use this to override the default behavior for Sparkle prompting the user about automatic update checks.
	//- (BOOL)updaterShouldPromptForPermissionToCheckForUpdates:(SUUpdater *)bundle { }

	// Implement this if you want to do some special handling with the appcast once it finishes loading.
	//- (void)updater:(SUUpdater *)updater didFinishLoadingAppcast:(SUAppcast *)appcast { }

	// If you're using special logic or extensions in your appcast, implement this to use your own logic for finding
	// a valid update, if any, in the given appcast.
	//- (SUAppcastItem *)bestValidUpdateInAppcast:(SUAppcast *)appcast forUpdater:(SUUpdater *)bundle { }

	// Sent when a valid update is found by the update driver.
	- (void)updater:(SUUpdater *)updater didFindValidUpdate:(SUAppcastItem *)update {
		if (updateStatus) {
			updateStatus (1);
		}
	}

	// Sent when a valid update is not found.
	- (void)updaterDidNotFindUpdate:(SUUpdater *)update {
		if (updateStatus) {
			updateStatus (0);
		}
	}

	// Sent immediately before installing the specified update.
	- (void)updater:(SUUpdater *)updater willInstallUpdate:(SUAppcastItem *)update {
		if (updateStatus) {
			updateStatus (2);
		}
	}

	// Return YES to delay the relaunch until you do some processing; invoke the given NSInvocation to continue.
	//	This is not called if the user didn't relaunch on the previous update, in that case it will immediately
	//	restart.
	//- (BOOL)updater:(SUUpdater *)updater shouldPostponeRelaunchForUpdate:(SUAppcastItem *)update untilInvoking:(NSInvocation *)invocation { }

	// Some apps *can not* be relaunched in certain circumstances. They can use this method
	//	to prevent a relaunch "hard":
	//- (BOOL)updaterShouldRelaunchApplication:(SUUpdater *)updater {	}

	// Called immediately before relaunching.
	//- (void)updaterWillRelaunchApplication:(SUUpdater *)updater { }

	// This method allows you to provide a custom version comparator.
	// If you don't implement this method or return nil, the standard version comparator will be used.
	//- (id <SUVersionComparison>)versionComparatorForUpdater:(SUUpdater *)updater { }

	// This method allows you to provide a custom version comparator.
	// If you don't implement this method or return nil, the standard version displayer will be used.
	//- (id <SUVersionDisplay>)versionDisplayerForUpdater:(SUUpdater *)updater { }

	// Returns the path which is used to relaunch the client after the update is installed. By default, the path of the host bundle.
	//- (NSString *)pathToRelaunchForUpdater:(SUUpdater *)updater { }

	// Called before and after, respectively, an updater shows a modal alert window, to give the host
	//	the opportunity to hide attached windows etc. that may get in the way:
	//-(void)	updaterWillShowModalAlert:(SUUpdater *)updater { }
	//-(void)	updaterDidShowModalAlert:(SUUpdater *)updater { }

	// Called when an update is scheduled to be silently installed on quit.
	// The invocation can be used to trigger an immediate silent install and relaunch.
	//- (void)updater:(SUUpdater *)updater willInstallUpdateOnQuit:(SUAppcastItem *)update immediateInstallationInvocation:(NSInvocation *)invocation { }
	//- (void)updater:(SUUpdater *)updater didCancelInstallUpdateOnQuit:(SUAppcastItem *)update { }

@end

// EOF
