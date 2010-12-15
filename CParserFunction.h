@interface CParserFunction : NSObject {

  int minArguments;
  int maxArguments;
}


// methods for instance variable 'minArguments'
- (int) minArguments;

// methods for instance variable 'maxArguments'
- (int) maxArguments;
- (void) setMinArguments:(int)args;

- (double) evaluateWithArguments:(NSArray *)arguments;


@end
