//
//  MCCalculatorCore.m
//  MyCalculator
//
//  Created by noark on 2/9/14.
//  Copyright (c) 2014 noark. All rights reserved.
//

#import "MCCalculatorCore.h"

@implementation MCCalculatorCore

+ (MCCalculatorCore *)sharedCalculatorCore
{
    static dispatch_once_t once;
    static id calculatorCoreInstance = nil;
    dispatch_once(&once, ^{
        calculatorCoreInstance = [[MCCalculatorCore alloc] init];
    });
    
    return calculatorCoreInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self clean];
    }

    return self;
}

- (void)clean
{
    self.holdNumber = 0.0;
    self.currentOperator = nil;
}

- (void)enterNumber:(double)number
{
    self.holdNumber = number;
}

- (void)enterNumberOperator:(NSString *)numberOperator
{
    self.currentOperator = numberOperator;
}

- (double)percentage
{
    self.holdNumber = self.holdNumber / 100.0;
    return self.holdNumber;
}

- (double)calculateWithNumber:(double)number withError:(NSError **)errorPtr
{
    if (!self.currentOperator) {
        self.holdNumber = number;
        return self.holdNumber;
    }
    double result = self.holdNumber;
    if ([self.currentOperator isEqualToString:MC_OPERATOR_PLUS]) {
        result = self.holdNumber + number;
    } else if ([self.currentOperator isEqualToString:MC_OPERATOR_MINUS]) {
        result = self.holdNumber - number;
    } else if ([self.currentOperator isEqualToString:MC_OPERATOR_MULTIPLY]) {
        result = self.holdNumber * number;
    } else if ([self.currentOperator isEqualToString:MC_OPERATOR_DIVIDE]) {
        if (fabs(number - 0.0) < 1e-8) {
            NSError *error = [[NSError alloc] initWithDomain:@"MCCalculatorError"
                                                        code:100
                                                    userInfo:@{@"message" : @"divide by zero",
                                                               @"result" : @"Infinity"}];
            result = 0.0;
            self.holdNumber = 0.0;
            *errorPtr = error;
        } else {
            result = self.holdNumber / number;
        }
    }
    self.holdNumber = result;
    self.currentOperator = nil;
    
    return result;
}

@end
