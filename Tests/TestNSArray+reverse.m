#import <SenTestingKit/SenTestingKit.h>

#import "NSArray+reverse.h"

@interface TestNSArray_reverse : SenTestCase {
	NSMutableArray *array;
}

@end


@implementation TestNSArray_reverse

static NSString * const first = @"first";
static NSString * const second = @"second";
static NSString * const third = @"third";

#define NORMAL_ARRAY	[NSArray arrayWithObjects: first, second, third, nil]	
#define REVERSED_ARRAY	[NSArray arrayWithObjects: third, second, first, nil]

- (void) setUp;
{
	[super setUp];
	
	array = [NORMAL_ARRAY mutableCopy];
}

- (void) tearDown;
{
	[array release]; 
	array = nil;
	
	[super tearDown];
}

- (void) testReverse;
{
	NSArray *reversed = [array reversedArray];
	STAssertEqualObjects( reversed, REVERSED_ARRAY, @"Must reverse the array" );
}

- (void) testReverseInPlace;
{
	[array reverse];
	STAssertEqualObjects( array, REVERSED_ARRAY, @"Must reverse the array" );
}

@end
