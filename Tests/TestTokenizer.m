#import <SenTestingKit/SenTestingKit.h>

#import "CPTokenizer.h"

@interface TestTokenizer : SenTestCase {
	CPTokenizer *tokenizer;
}

@end

@implementation TestTokenizer

- (void) setUp;
{
	tokenizer = [[CPTokenizer alloc] init];
}

- (void) tearDown;
{
	[tokenizer release]; tokenizer = nil;
}

- (void) runTokenizer: (NSString *)expr expectedResults: (CPTokenType) type, ...;
{
	NSLog( @"Testing %@", expr );
	
	NSArray *result = [tokenizer convertExpressionFromInfixStringToPostfixArray: expr];
	
	NSUInteger index = 0, count = [result count];
	
	va_list args;
	va_start( args, type );
	
	while (type != CPTokenNull) {
		STAssertTrue( index <= count, @"Too many results" );
		
		CPToken *token = [result objectAtIndex: index];

		STAssertTrue( [token type] == type, @"Invalid token type" );

		double number = 0.0;
		NSString *string = nil;
		CPOperator operator = CPOperatorNull;
		switch (type) {
			case CPTokenNumber:
				number = va_arg( args, double );
				STAssertTrue( [token numberValue] == number, @"Wrong number, expected %f got %f", number, [token numberValue] );
				break;
				
			case CPTokenFunction:
			case CPTokenVariable:
				string = va_arg( args, NSString * );
				STAssertEqualObjects( [token stringValue], string, @"Wrong string, expected %@ got %@", string, [token stringValue] );
				break;

			case CPTokenOperator:
				operator = va_arg( args, CPOperator );
				STAssertTrue( [token operatorValue] == operator, @"Wrong operator, expected %d got %d", operator, [token operatorValue] );
				break;
				
			default:
				STFail( @"Unexpected token type %d", type );
		}
		
		type = va_arg( args, CPTokenType );
		++index;
	}
	va_end( args );
	
}

#define Check( expr, args... ) [self runTokenizer: expr expectedResults: args, CPTokenNull]

#define VAR(x) CPTokenVariable, x
#define OP(x) CPTokenOperator, x
#define NUM( x ) CPTokenNumber, ((double)x)
#define FUNC( x ) CPTokenFunction, x

#define A VAR( @"A" )
#define B VAR( @"B" )
#define C VAR( @"C" )
#define ADD OP( CPOperatorPlus )
#define SUB OP( CPOperatorMinus )
#define MUL OP( CPOperatorTimes )
#define DIV OP( CPOperatorDiv )

- (void) testValues;
{
	Check( @"1", NUM( 1 ) );
	Check( @"A", A );
	Check( @"a", FUNC( @"a" ) );
}

#define CheckOperator( str, op ) Check( str, OP( op ) )

- (void) testSingleOperators;
{
	CheckOperator( @"+", CPOperatorPlus );
	CheckOperator( @"-", CPOperatorMinus );
	CheckOperator( @"*", CPOperatorTimes );
	CheckOperator( @"/", CPOperatorDiv );
	CheckOperator( @"%", CPOperatorModulo );
	CheckOperator( @"=", CPOperatorAssign );
	CheckOperator( @"^", CPOperatorPower );
	CheckOperator( @"<", CPOperatorLT );
	CheckOperator( @"<=", CPOperatorLE );
	CheckOperator( @">", CPOperatorGT );
	CheckOperator( @">=", CPOperatorGE );
	CheckOperator( @"!=", CPOperatorNEqual );
	CheckOperator( @"==", CPOperatorEqual );
	CheckOperator( @"!", CPOperatorFactorial );
	CheckOperator( @"&&", CPOperatorAnd );
	CheckOperator( @"||", CPOperatorOr );
}

/* TODO: new tests
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

- (void) testWhitespaceVariants;
{
	Check( @"A*B", A, B, MUL );
	Check( @" A*B", A, B, MUL );
	Check( @"A * B", A, B, MUL );
	Check( @"A*B ", A, B, MUL );
	Check( @" A *\tB ", A, B, MUL );
}
*/
@end
