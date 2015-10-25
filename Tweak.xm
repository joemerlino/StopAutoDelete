NSMutableArray *disabled_apps;

%group MOD

%hook UIKeyboardImpl
- (BOOL)usesAutoDeleteWord{
	return NO;
}
%end

%end

static void PreferencesCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
	CFPreferencesAppSynchronize(CFSTR("com.joemerlino.stopautodelete"));
}

%ctor
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesCallback, CFSTR("com.joemerlino.stopautodelete.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.joemerlino.stopautodelete.plist"];
	static BOOL enabled = ([prefs objectForKey:@"enabled"] ? [[prefs objectForKey:@"enabled"] boolValue] : YES);
	NSMutableDictionary *applist = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.joemerlino.stopautodelete.applist.plist"];
    disabled_apps = [[NSMutableArray alloc] init];
    for (NSString *key in applist) {
        static bool app_disabled = [[applist objectForKey:key] boolValue];
        if (app_disabled)
            [disabled_apps addObject:key];
    }
    NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"[STOPAUTODELETE] ENABLED %d, %@, APPLIST %@", enabled, bundleID, applist);   
    if (enabled && ![disabled_apps containsObject:bundleID])
        %init(MOD);
}