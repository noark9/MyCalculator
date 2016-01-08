//
//  MCViewController.m
//  MyCalculator
//
//  Created by noark on 2/9/14.
//  Copyright (c) 2014 noark. All rights reserved.
//

#import "MCViewController.h"
#import "MCCalculatorCore.h"
#import <NotificationCenter/NotificationCenter.h>

@interface MCViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (weak, nonatomic) IBOutlet UIButton *numberButton1;
@property (weak, nonatomic) IBOutlet UIButton *numberButton2;
@property (weak, nonatomic) IBOutlet UIButton *numberButton3;
@property (weak, nonatomic) IBOutlet UIButton *numberButton4;
@property (weak, nonatomic) IBOutlet UIButton *numberButton5;
@property (weak, nonatomic) IBOutlet UIButton *numberButton6;
@property (weak, nonatomic) IBOutlet UIButton *numberButton7;
@property (weak, nonatomic) IBOutlet UIButton *numberButton8;
@property (weak, nonatomic) IBOutlet UIButton *numberButton9;
@property (weak, nonatomic) IBOutlet UIButton *numberButton0;
@property (weak, nonatomic) IBOutlet UIButton *pointButton;

@property (weak, nonatomic) IBOutlet UIButton *clearButton;
@property (weak, nonatomic) IBOutlet UIButton *invertButton;
@property (weak, nonatomic) IBOutlet UIButton *percentageButton;
@property (weak, nonatomic) IBOutlet UIButton *divideButton;
@property (weak, nonatomic) IBOutlet UIButton *multiplyButton;
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;
@property (weak, nonatomic) IBOutlet UIButton *equalButton;

@property (strong, nonatomic) MCCalculatorCore *calculatorCore;

@property BOOL havePoint;
@property BOOL needReplaceResultLabel;
@property BOOL needCalculator;

@end

@implementation MCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.calculatorCore = [MCCalculatorCore sharedCalculatorCore];
    self.needReplaceResultLabel = YES;
    self.needCalculator = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)displayNumber:(double)number
{
    NSString *result = [NSString stringWithFormat:@"%.9g", number];
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.type = kCATransitionFade;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.resultLabel.layer addAnimation:animation forKey:@"resultLabelAnimation"];

    self.resultLabel.text = result;
}

- (IBAction)clean:(id)sender {
    [self.resultLabel setText:@"0"];
    [self.calculatorCore clean];
    self.needReplaceResultLabel = YES;
    self.needCalculator = YES;
}

- (IBAction)numberButtonPushed:(UIButton *)sender {
    if (!self.needReplaceResultLabel && self.resultLabel.text.length >= 13) {
        return;
    }
    if (self.needReplaceResultLabel) {
        self.resultLabel.text = sender.titleLabel.text;
    } else {
        self.resultLabel.text = [self.resultLabel.text stringByAppendingString:sender.titleLabel.text];
    }
    self.needReplaceResultLabel = NO;
    self.needCalculator = YES;
}

- (IBAction)pointButtonPushed:(id)sender {
    NSRange pointAtRange = [self.resultLabel.text rangeOfString:@"."];
    if (!self.needReplaceResultLabel && pointAtRange.location != NSNotFound) {
        return;
    }
    if (self.needReplaceResultLabel) {
        self.resultLabel.text = @"0.";
    } else {
        self.resultLabel.text = [self.resultLabel.text stringByAppendingString:@"."];
    }
    self.needReplaceResultLabel = NO;
}

- (IBAction)invertButtonPushed:(id)sender {
    if ([[self.resultLabel.text substringToIndex:1] isEqualToString:@"-"]) {
        self.resultLabel.text = [self.resultLabel.text substringFromIndex:1];
    } else {
        self.resultLabel.text = [@"-" stringByAppendingString:self.resultLabel.text];
    }
}

- (IBAction)percentageButtonPushed:(id)sender {
    [self.calculatorCore enterNumber:self.resultLabel.text.doubleValue];
    double result = [self.calculatorCore percentage];
    [self displayNumber:result];
    self.needReplaceResultLabel = YES;
    self.needCalculator = YES;
}

- (IBAction)operatorButtonPushed:(UIButton *)sender {
    if (self.needCalculator) {
        [self equalButtonPushed:sender];
    }
    
    [self.calculatorCore enterNumberOperator:sender.titleLabel.text];
    self.needCalculator = NO;
}

- (IBAction)equalButtonPushed:(id)sender {
    NSError *error = nil;
    double result = [self.calculatorCore calculateWithNumber:self.resultLabel.text.doubleValue withError:&error];
    [self displayNumber:result];
    if (error) {
        self.resultLabel.text = error.userInfo[@"result"];
    }
    self.needReplaceResultLabel = YES;
}

#pragma mark - Today Extension
- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData
    
    completionHandler(NCUpdateResultNewData);
}

@end
