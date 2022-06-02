//
//  DimmingView.m
//  PresentKit
//
//  Created by zengxiang on 2022/6/2.
//

#import "DimmingView.h"

@implementation DimmingView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithColor:(UIColor *)color {
    self = [super init];
    if (self) {
        self.color = color;
        [self setup];
    }
    return self;
}

- (void)setup {
    if (self.color == nil) {
        self.color = [[UIColor blackColor] colorWithAlphaComponent:0.7];
    }
    self.alpha = 0.0;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dimmingViewTapped:)] ];
}

- (void)dimmingViewTapped:(UIGestureRecognizer *)recognizer {
    if (self.didTap) {
        self.didTap(recognizer);
    }
}

- (void)setColor:(UIColor *)color {
    _color = color;
    self.backgroundColor = color;
}

- (void)setOff {
    self.alpha = 0.0;
}

- (void)setMax {
    self.alpha = 1.0;
}

- (void)setPercent:(CGFloat)percent {
    self.alpha = MAX(0.0, MIN(1.0, percent));
}

@end
