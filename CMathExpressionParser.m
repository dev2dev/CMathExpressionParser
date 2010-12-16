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

#import "CPTokenizer.h"
#import "CPEvaluator.h"
#import "CParserCFunction.h"
#import "CParserMacroFunction.h"

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

void evaluateExpressionString( NSString *expression, CPTokenizer *conv, CPEvaluator *eval ) 
{
	NSArray *postfixArray = [conv convertExpressionFromInfixStringToPostfixArray: expression];
	NSLog( @"postfix: %@", postfixArray );
	
	double result = [eval evaluatePostfixExpressionArray: postfixArray];
	NSLog( @"%@ --> %f", expression, result );
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	CPTokenizer * conv = [[CPTokenizer alloc] init];
	CPEvaluator * eval = [[CPEvaluator alloc] init];
	
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

	
	[eval release];
	[conv release];
	
    [pool drain];
    return 0;
}
