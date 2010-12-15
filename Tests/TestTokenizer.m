#import <SenTestingKit/SenTestingKit.h>

#import "CParserConverter.h"

@interface TestTokenizer : SenTestCase {
	CParserConverter *tokenizer;
}

@end

@implementation TestTokenizer

- (void) setUp;
{
	tokenizer = [[CParserConverter alloc] init];
}

- (void) tearDown;
{
	[tokenizer release]; tokenizer = nil;
}

- (void) runTokenizer: (NSString *)expr expectedResults: (CParserTokenType) type, ...;
{
	NSLog( @"Testing %@", expr );
	
	NSArray *result = [tokenizer convertExpressionFromInfixStringToPostfixArray: expr];
	
	NSUInteger index = 0, count = [result count];
	
	va_list args;
	va_start( args, type );
	
	while (type != CParserTokenNull) {
		STAssertTrue( index <= count, @"Too many results" );
		
		CParserToken *token = [result objectAtIndex: index];

		STAssertTrue( [token type] == type, @"Invalid token type" );

		double number = 0.0;
		NSString *string = nil;
		switch (type) {
			case CParserTokenNumber:
				number = va_arg( args, double );
				STAssertTrue( [token numberValue] == number, @"Wrong number, expected %f got %f", number, [token numberValue] );
				break;
				
			case CParserTokenOperator:
				string = va_arg( args, NSString * );
				STAssertEqualObjects( [token operatorValue], string, @"Wrong operator, expected %@ got %@", string, [token operatorValue] );
				break;
				
			case CParserTokenVariable:
				string = va_arg( args, NSString * );
				STAssertEqualObjects( [token variableValue], string, @"Wrong variable, expected %@ got %@", string, [token variableValue] );
				break;
				
			case CParserTokenFunction:
				string = va_arg( args, NSString * );
				STAssertEqualObjects( [token functionValue], string, @"Wrong function, expected %@ got %@", string, [token functionValue] );
				break;
				
			case CParserTokenMacro:
				string = va_arg( args, NSString * );
				STAssertEqualObjects( [token macroValue], string, @"Wrong macro, expected %@ got %@", string, [token macroValue] );
				break;
				
			default:
				STFail( @"Unexpected token type %d", type );
		}
		
		type = va_arg( args, CParserTokenType );
		++index;
	}
	va_end( args );
	
}

#define Check( expr, args... ) [self runTokenizer: expr expectedResults: args, CParserTokenNull]

#define VAR(x) CParserTokenVariable, x
#define OP(x) CParserTokenOperator, x
#define NUM( x ) CParserTokenNumber, ((double)x)
#define FUNC( x ) CParserTokenFunction, x
#define MACRO( x ) CParserTokenMacro, x

#define A VAR( @"A" )
#define B VAR( @"B" )
#define C VAR( @"C" )
#define ADD OP( @"+" )
#define SUB OP( @"-" )
#define MUL OP( @"*" )
#define DIV OP( @"/" )

- (void) testValues;
{
	Check( @"1", NUM( 1 ) );
	Check( @"A", A );
	Check( @"a", FUNC( @"a" ) );
	Check( @"#a", MACRO( @"#a" ) );
}

#define CheckOperator( op ) Check( op, OP( op ) )

- (void) testSingleOperators;
{
	CheckOperator( @"+" );
	CheckOperator( @"-" );
	CheckOperator( @"*" );
	CheckOperator( @"/" );
	CheckOperator( @"=" );
	CheckOperator( @"^" );
//	CheckOperator( @"%" );	// TODO: Fix
	CheckOperator( @"<" );
	CheckOperator( @">" );
	CheckOperator( @"==" );
	CheckOperator( @"<=" );
	CheckOperator( @">=" );
	CheckOperator( @"!=" );
	CheckOperator( @"&&" );
	CheckOperator( @"||" );

	CheckOperator( @"!" );
}

- (void) testOrdering;
{
	Check( @"A*B+C", A, B, MUL, C, ADD );
	Check( @"A+B*C", A, B, C, MUL, ADD );
	Check( @"(A+B)*C", A, B, ADD, C, MUL );
}

- (void) testFunctions;
{
	Check( @"f(A)", A, FUNC( @"f" ) );
	Check( @"f(A,B)", A, B, FUNC( @"f" ) );
	Check( @"f(A,B,C)", A, B, C, FUNC( @"f" ) );
}

- (void) testMacros;
{
	Check( @"#m(A)", A, MACRO( @"#m" ) );
	Check( @"#m(A,B)", A, B, MACRO( @"#m" ) );
	Check( @"#m(A,B,C)", A, B, C, MACRO( @"#m" ) );
}

- (void) testWhitespaceVariants;
{
	Check( @"A*B", A, B, MUL );
	Check( @" A*B", A, B, MUL );
	Check( @"A * B", A, B, MUL );
	Check( @"A*B ", A, B, MUL );
	Check( @" A *\tB ", A, B, MUL );
}

@end
