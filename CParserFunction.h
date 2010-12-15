@interface CParserFunction : NSObject {

  int minArguments;
  int maxArguments;
}

@property (readwrite, assign, nonatomic) int minArguments;
@property (readwrite, assign, nonatomic) int maxArguments;

- (double) evaluateWithArguments:(NSArray *)arguments;


@end
