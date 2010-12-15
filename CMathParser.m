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

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	CParserConverter * conv = [[CParserConverter alloc] init];
	CParserEvaluator * eval = [[CParserEvaluator alloc] init];
	
	//convert
	
	NSArray * postfixArray = [conv convertExpressionFromInfixStringToPostfixArray:@"A=1;B=3;C=A+B*10;C*2"];
	
	NSLog(@"Converted Array: %@", postfixArray);
	
	//macros
	
	CParserMacroFunction * myMacro = [CParserMacroFunction macroWithExpression:@"(ARG_1 + ARG_2 + ARG_3 + ARG_4 + ARG_5 + ARG_6 + ARG_7 + ARG_8 + ARG_9)/ARG_COUNT"];
	[myMacro setMinArguments:3];
	[myMacro updatePostfixExpression];
	
	//functions
	
	CParserCFunction * myFunction = [CParserCFunction functionWithMinArguments:1];
	[myFunction setFunction1:&sin];
	
	//add
	
	[eval setMacro:myMacro forKey:@"durchschnitt"];
	[eval setFunction:myFunction forKey:@"sin"];
	
	//evaluate
	
	//double result = [eval evaluatePostfixArray:postfixArray];
	double result = [eval evaluatePostfixArray:postfixArray];

	//print
	
	printf("Result = %.12f\n", result);
	
	//eval vars
	
	NSLog(@"Evaluator Variables: %@", [eval variableDictionary]);
	
	[eval release];
	[conv release];
	
    [pool drain];
    return 0;
}
