static BOOL enabled=YES;
#define setin_domain CFSTR("com.joemerlino.stopautodelete")

%hook UIKeyboardImpl
- (BOOL)usesAutoDeleteWord{
	if(enabled)
		return NO;
	else return YES;
}
%end

static void LoadSettings()
{
	CFPreferencesAppSynchronize(CFSTR("com.joemerlino.stopautodelete"));
	NSString *n=(NSString*)CFPreferencesCopyAppValue(CFSTR("enabled"), setin_domain);
	enabled = (n)? [n boolValue]:YES;
 	NSLog(@"ENABLED STOPAUTODELETE: %d",enabled);
}

%ctor
{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)LoadSettings, CFSTR("com.joemerlino.stopautodelete.preferencechanged"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	LoadSettings();
}