#import <Foundation/Foundation.h>

#import "CPTokenizer.h"
#import "CPEvaluator.h"

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	CPTokenizer *t = [CPTokenizer tokenizer];
	CPEvaluator *e = [CPEvaluator evaluator];
	NSArray *a = [t convertExpressionFromInfixStringToPostfixArray:@"(0-2)"];
	double r = [e evaluatePostfixExpressionArray:a];
	
	NSLog(@"Array: %@", a);
	NSLog(@"Result: %.8f", r);
	
    [pool drain];
    return 0;
}
