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
	
	STAssertThrows( [token operatorValue], @"No operator" );
	STAssertThrows( [token functionValue], @"No function" );
	STAssertThrows( [token variableValue], @"No variable" );
	STAssertThrows( [token macroValue], @"No macro" );
}

- (void) testOperatorToken;
{
	CParserToken *token = [CParserToken tokenWithOperator: TestOperator];
	STAssertEquals( [token type], CParserTokenOperator, @"Wrong type" );
	STAssertEqualObjects( [token operatorValue], TestOperator, @"Wrong operator" );

	STAssertThrows( [token numberValue], @"No number" );
	STAssertThrows( [token functionValue], @"No function" );
	STAssertThrows( [token variableValue], @"No variable" );
	STAssertThrows( [token macroValue], @"No macro" );
}

- (void) testFunctionToken;
{
	CParserToken *token = [CParserToken tokenWithFunction: TestFunction];
	STAssertEquals( [token type], CParserTokenFunction, @"Wrong type" );
	STAssertEqualObjects( [token functionValue], TestFunction, @"Wrong function" );

	STAssertThrows( [token numberValue], @"No number" );
	STAssertThrows( [token operatorValue], @"No operator" );
	STAssertThrows( [token variableValue], @"No variable" );
	STAssertThrows( [token macroValue], @"No macro" );
}

- (void) testVariableToken;
{
	CParserToken *token = [CParserToken tokenWithVariable: TestVariable];
	STAssertEquals( [token type], CParserTokenVariable, @"Wrong type" );
	STAssertEqualObjects( [token variableValue], TestVariable, @"Wrong variable" );
	
	STAssertTrueNoThrow( [token numberValue] == 0.0, @"Should have number 0" );
	
	[token setNumberValue: TestNumber];
	STAssertEquals( [token type], CParserTokenVariable, @"Wrong type" );
	STAssertEqualObjects( [token variableValue], TestVariable, @"Wrong variable" );
	STAssertEquals( [token numberValue], TestNumber, @"Wrong number" );

	STAssertThrows( [token operatorValue], @"No operator" );
	STAssertThrows( [token functionValue], @"No function" );
	STAssertThrows( [token macroValue], @"No macro" );
	
}

- (void) testMacroToken;
{
	CParserToken *token = [CParserToken tokenWithMacro: TestMacro];
	STAssertEquals( [token type], CParserTokenMacro, @"Wrong type" );
	STAssertEqualObjects( [token macroValue], TestMacro, @"Wrong macro" );

	STAssertThrows( [token numberValue], @"No number" );
	STAssertThrows( [token operatorValue], @"No operator" );
	STAssertThrows( [token functionValue], @"No function" );
	STAssertThrows( [token variableValue], @"No variable" );
}

- (void) testNullToken;
{
	CParserToken *token = [CParserToken token];
	STAssertEquals( [token type], CParserTokenNull, @"Wrong type" );
	
	STAssertThrows( [token numberValue], @"No number" );
	STAssertThrows( [token operatorValue], @"No operator" );
	STAssertThrows( [token functionValue], @"No function" );
	STAssertThrows( [token variableValue], @"No variable" );
	STAssertThrows( [token macroValue], @"No macro" );
}

@end
