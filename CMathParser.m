/***************************************
 
         _____  _____     ___________
        /     \/     |\  |           \
       /             | | |   _____   |\
      /              | | |   |   |   | |
     /    /|    /|   | | |   |___|   | |
    /    / |___/ |   | | |   ________/\|
   /    / /\___\/|   | | |   |\______\/      
  /    / /       |   | | |   | |
 /____/ /        |___| | |___| |
 \____\/         \____\| \____\| 
 
 CMathParser (C) Johannes Wolf
 
 **************************************/

#import <Foundation/Foundation.h>

#import "CParserConverter.h"
#import "CParserEvaluator.h"
#import "CParserCFunction.h"
#import "CParserMacroFunction.h"

static void installMacro(CParserEvaluator *eval) 
{
	CParserMacroFunction * myMacro = [CParserMacroFunction macroWithExpression:@"(ARG_1 + ARG_2 + ARG_3 + ARG_4 + ARG_5 + ARG_6 + ARG_7 + ARG_8 + ARG_9)/ARG_COUNT"];
	[myMacro setMinArguments:3];
	[eval setMacro:myMacro forKey:@"durchschnitt"];
	
}

static void installFunction(CParserEvaluator *eval) 
{
	CParserCFunction * myFunction = [CParserCFunction functionWithMinArguments:1];
	[myFunction setFunction1:&sin];
	[eval setFunction:myFunction forKey:@"sin"];
	
}

static const int BufferSize = 1024;

static NSString *readLine()
{
	char buffer[BufferSize];
	char *result = fgets( buffer, BufferSize - 1, stdin );
	if (NULL == result) {
		return nil;
	}
	
	return [[NSString stringWithUTF8String: buffer] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

void evaluateExpressionString( NSString *expression, CParserConverter *conv, CParserEvaluator *eval ) 
{
	NSArray *postfixArray = [conv convertExpressionFromInfixStringToPostfixArray: expression];
	NSLog( @"postfix: %@", postfixArray );
	
	double result = [eval evaluatePostfixArray: postfixArray];
	NSLog( @"%@ --> %f", expression, result );
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	CParserConverter * conv = [[CParserConverter alloc] init];
	CParserEvaluator * eval = [[CParserEvaluator alloc] init];
	
	installMacro(eval);
	installFunction(eval);
	
	for (int i = 1; i < argc; i++) {
		NSString *expression = [[NSString stringWithUTF8String: argv[i]] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
		evaluateExpressionString( expression, conv, eval );
	}
	
	NSLog( @"Type expressions to evaluate and 'quit' to exit the program" );
	while (true) {
		NSAutoreleasePool *loopPool = [[NSAutoreleasePool alloc] init];
		
		NSString *line = readLine();
		if (nil == line || [line caseInsensitiveCompare: @"quit"] == NSOrderedSame) {
			break;
		}
		
		evaluateExpressionString(line,conv,eval);
		
		[loopPool release];
	}

	NSLog( @"Defined variables: %@", [eval variableDictionary] );
	
	[eval release];
	[conv release];
	
    [pool drain];
    return 0;
}
