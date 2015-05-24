%hook UIKeyboardImpl
- (BOOL)usesAutoDeleteWord{
	return NO;
}
%end