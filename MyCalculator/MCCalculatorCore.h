//
//  MCCalculatorCore.h
//  MyCalculator
//
//  Created by noark on 2/9/14.
//  Copyright (c) 2014 noark. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MC_OPERATOR_PLUS                    @"+"
#define MC_OPERATOR_MINUS                   @"-"
#define MC_OPERATOR_MULTIPLY                @"×"
#define MC_OPERATOR_DIVIDE                  @"÷"

@interface MCCalculatorCore : NSObject

@property double holdNumber;
@property (strong, nonatomic) NSString *currentOperator;

+ (MCCalculatorCore *)sharedCalculatorCore;
- (void)enterNumber:(double)number;
- (void)enterNumberOperator:(NSString *)numberOperator;
- (void)clean;
- (double)percentage;
- (double)calculateWithNumber:(double)number withError:(NSError **)error;

@end
