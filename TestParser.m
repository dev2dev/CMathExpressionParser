/******************************************************************
  ____              ____   _____   _  _
 /  __|  _  |\  /| |    | |_   _| | || |
 | |    / \ | \/ | | || |   | |   |    |
 | |__  \_/ | \/ | |    |   | |   |    |
 \____|     |_||_| |_||_|   |_|   |_||_|
  ____  __  __  ____   ____    ____   ___   ___   _   ___   _   _
 |  __| \ \/ / |    \ |    \  |  __| /  _\ /  _\ | | /   \ | \ | |
 | |__   \  /  | || | | ||  | | |__  |__   |__   | | | | | |  \| |
 | |__   /  \  |  __/ |    /  | |__  ___ | ___ | | | | | | | |\  |
 |____| /_/\_\ |_|    |_|\_\  |____| \___/ \___/ |_| \___/ |_| \_|
  ____    ____   ____    ___   ____   ____  
 |    \ |    | |    \  /  _\ |  __| |    \ 
 | || | | || | | ||  | |__   | |__  | ||  |
 |  __/ |    | |    /  ___ | | |__  |    / 
 |_|    |_||_| |_|\_\  \___/ |____| |_|\_\ 
 
 ******************************************************************/

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
	
	double result = [eval evaluatePostfixExpressionArray: postfixArray];
	printf("\t\t= %f\n", result );
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	CPTokenizer * conv = [[CPTokenizer alloc] init];
	CPEvaluator * eval = [[CPEvaluator alloc] init];

	CParserMacroFunction *factorial_macro = [CParserMacroFunction macroWithExpression:@"if(ARG_1<=1){1} ifnot(ARG_1<=1){ ARG_1*fact( ARG_1-1 ) }"];
	factorial_macro.minArguments = 1;
	factorial_macro.maxArguments = 1;
	[eval setFunction:factorial_macro forKey:@"fact"];
	
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
