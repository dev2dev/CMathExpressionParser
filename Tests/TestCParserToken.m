#import <SenTestingKit/SenTestingKit.h>

#import "CParserToken.h"

@interface TestCParserToken : SenTestCase {
	
}

@end


@implementation TestCParserToken

static const double TestNumber = 42.0;
static NSString * const TestOperator = @"+";
static NSString * const TestFunction = @"sin";
static NSString * const TestVariable = @"VAR";
static NSString * const TestMacro = @"#macro";

- (void) testNumberToken;
{
	CParserToken *token = [CParserToken tokenWithNumber: TestNumber];
	STAssertEquals( [token type], CParserTokenNumber, @"Wrong type" );
	STAssertEquals( [token numberValue], TestNumber, @"Wrong number" );
}

- (void) testOperatorToken;
{
	CParserToken *token = [CParserToken tokenWithOperator: TestOperator];
	STAssertEquals( [token type], CParserTokenOperator, @"Wrong type" );
	STAssertEqualObjects( [token operatorValue], TestOperator, @"Wrong operator" );
}

- (void) testFunctionToken;
{
	CParserToken *token = [CParserToken tokenWithFunction: TestFunction];
	STAssertEquals( [token type], CParserTokenFunction, @"Wrong type" );
	STAssertEqualObjects( [token functionValue], TestFunction, @"Wrong function" );
}

- (void) testVariableToken;
{
	CParserToken *token = [CParserToken tokenWithVariable: TestVariable];
	STAssertEquals( [token type], CParserTokenVariable, @"Wrong type" );
	STAssertEqualObjects( [token variableValue], TestVariable, @"Wrong variable" );
}

- (void) testMacroToken;
{
	CParserToken *token = [CParserToken tokenWithMacro: TestMacro];
	STAssertEquals( [token type], CParserTokenMacro, @"Wrong type" );
	STAssertEqualObjects( [token macroValue], TestMacro, @"Wrong macro" );
}

@end
