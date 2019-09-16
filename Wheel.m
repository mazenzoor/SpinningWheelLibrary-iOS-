//
//  Wheel.m
//  SpinningWheel
//
//  Created by imac on 9/16/19.
//  Copyright © 2019 imac. All rights reserved.
//

#import "Wheel.h"


@implementation Wheel

//// Synthesize values

@synthesize number_of_slices;
@synthesize current_index;
@synthesize go_to_index;
@synthesize offset;
@synthesize rotate_by_degrees;
@synthesize go_to_degrees;
@synthesize isAnimating;
@synthesize wheel;

//// Initializer

-(id) initWithData: (UIImageView *) wheelImageView
            numberOfSlice :(NSInteger *) nbOfSlices {
    

    //// Initialize variables
    
    self.wheel = [[UIImageView alloc] init];

    self.wheel = wheelImageView;
    
    self.number_of_slices = *(nbOfSlices);
    
    number_of_slices = 9;
    
    current_index = 0;
    
    go_to_index = 5;
    
    offset = 0.0;
    
    rotate_by_degrees = 0.0;
    
    isAnimating = false;
    
    return self;
}


- (void) spinTo:(NSInteger) index {
    
    
    go_to_index = index;
    
    //// If it is already animating don't continue
    
    if(isAnimating)
        return;
    
    
    //// Where the destination slice is placed in degrees (from the starting point of 0 degrees)
    
    go_to_degrees = ( 360 / number_of_slices ) * go_to_index;
    
    
    //// The amount of degrees the circle should rotate to get to our destination
    
    rotate_by_degrees = ( 360 / number_of_slices ) * (go_to_index - current_index);
    
    
    //// Make sure rotation is always clockwise
    
    if( current_index > go_to_index)
        
        rotate_by_degrees = 360 + (current_index * -1);
    
    
    //// Start the animation
    
    [CATransaction begin];
    
    CABasicAnimation* rotationAnimation;
    
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    
    rotationAnimation.fromValue = [NSNumber numberWithFloat: (offset * M_PI / 180) ];
    
    rotationAnimation.byValue = [NSNumber numberWithFloat: (rotate_by_degrees * M_PI / 180)];
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: ((go_to_degrees + (3*360)) * M_PI / 180) ];
    
    rotationAnimation.duration = 2;
    
    //rotationAnimation.cumulative = YES;
    
    CAMediaTimingFunction * tfunc = [CAMediaTimingFunction functionWithControlPoints:.67 :-.2 :.3 :1.14];
    
    rotationAnimation.timingFunction = tfunc;
    
    rotationAnimation.fillMode = kCAFillModeBoth;
    
    rotationAnimation.removedOnCompletion = NO;
    

    isAnimating = true;
    
    
    //// Update variables on animation end
    
    [CATransaction setCompletionBlock:^{
        
        self.current_index = self.go_to_index;
        
        self.offset = ( 360 / self.number_of_slices ) * self.current_index;
        
        self.isAnimating = false;
        
        
        //// Report done animating to user
        if(self.callback)
            [self.callback doneAnimating];
        
        
    }];
    
    
    [self.wheel.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    [CATransaction commit];
    
    
}


@end
