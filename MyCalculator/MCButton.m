//
//  MCButton.m
//  MyCalculator
//
//  Created by noark on 2/10/14.
//  Copyright (c) 2014 noark. All rights reserved.
//

#import "MCButton.h"

@implementation MCButton

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addObserver:self forKeyPath:@"highlighted" options:NSKeyValueObservingOptionNew context:Nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"highlighted"]) {
        for (UIView *view in [self.superview subviews]) {
            [self.superview.layer insertSublayer:self.layer below:view.layer];
        }
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.highlighted) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        animation.duration = 0.2;
        animation.fromValue = [NSNumber numberWithFloat:1.0];
        animation.toValue = [NSNumber numberWithFloat:1.3];
        animation.autoreverses = YES;
        animation.repeatCount = 1;
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [self.layer addAnimation:animation forKey:@"buttonScaleAnimation"];
    }
}

@end
