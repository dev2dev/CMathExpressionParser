#import "CParserFunction.h"


@implementation CParserFunction

- (double) evaluateWithArguments:(NSArray *)arguments;
{
	[NSException raise: NSInvalidArgumentException format: @"%@ needs to implement 'evaluateWithArguments:'", [self class]];
	return 0.0;
}

- (void) setMinArguments:(int)args
{
	minArguments = args;
	maxArguments = args;
}

@synthesize minArguments;
@synthesize maxArguments;

@end
