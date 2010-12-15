#import "CParserFunction.h"


@implementation CParserFunction

- (double) evaluateWithArguments:(NSArray *)arguments;
{
	[NSException raise: NSInvalidArgumentException format: @"%@ needs to implement 'evaluateWithArguments:'", [self class]];
	return 0.0;
}

- (int) minArguments
{
	return minArguments;
}
- (int) maxArguments
{
	return maxArguments;
}
- (void) setMinArguments:(int)args
{
	minArguments = args;
	maxArguments = args;
}
@end
