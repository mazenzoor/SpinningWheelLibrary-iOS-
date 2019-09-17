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
@synthesize needle;
@synthesize duration;
@synthesize spin_factor;

//// Initializer

-(id) initWithData: (UIImageView *) wheelImageView
            numberOfSlice :(NSInteger *) nbOfSlices
            needle: (UIImageView *) needle {
    

    //// Initialize variables
    
    self.wheel = [[UIImageView alloc] init];

    self.wheel = wheelImageView;
    
    self.number_of_slices = *(nbOfSlices);
    
    self.needle = needle;
    
    number_of_slices = 9;
    
    current_index = 0;
    
    go_to_index = 5;
    
    offset = 0.0;
    
    rotate_by_degrees = 0.0;
    
    isAnimating = false;
    
    duration = 4;
    
    spin_factor = 6;
    
    //// Change anchor point of needle
    [self setAnchorPoint:CGPointMake(0.5f, 0) forView:needle];
    
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
    
    rotationAnimation.toValue = [NSNumber numberWithFloat: ( (go_to_degrees + ((int) spin_factor * 360) ) * M_PI / 180) ];
    
    rotationAnimation.duration = duration;
    
    //rotationAnimation.cumulative = YES;
    
    CAMediaTimingFunction * tfunc = [CAMediaTimingFunction functionWithControlPoints:.67 :-.1 :.3 :1.1];
    
    rotationAnimation.timingFunction = tfunc;
    
    rotationAnimation.fillMode = kCAFillModeBoth;
    
    rotationAnimation.removedOnCompletion = NO;
    

    isAnimating = true;
    

    
    //// Call animate needle
    
    [self animateNeedle];
    
    
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


-(void) animateNeedle {
    
    if(needle == nil)
        return;
    
    //// Start the animation
    
    
    double totalNbOfSlices = number_of_slices * ( ((int) rotate_by_degrees / 360) + (int) spin_factor );
    
    
    NSMutableArray* values = [NSMutableArray array];
    
    [values addObject: @0.0f];
    
    int direction = -1;
    
    for (int i = 1; i <= totalNbOfSlices; i += 1, direction *= -1) { // alternate directions
        
        if(direction > 0)
            
            [values addObject: @(0)];
        
        else if(i <= totalNbOfSlices / 4)
                
                [values addObject: @(direction*M_PI/(float)24)];
            
        
        else if (i <=  ( 2 * (int) totalNbOfSlices) / 3 )
            
            [values addObject: @(direction*M_PI/(float)16)];
        
        else {
            
            if( i%2 == 0)
                
                [values addObject: @(direction*M_PI/(float)(i*2))];
            
        }
        
        
    
    }
    
    
    [values addObject: @0.0f];
    
    NSLog(@"%@", values);
    
    CAKeyframeAnimation* anim =
    
    [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    anim.values = values;
    
    anim.beginTime = CACurrentMediaTime() + 0.5;
    
    anim.additive = YES;
    
    anim.duration = (duration - 0.4);
    
    anim.valueFunction =
    
    [CAValueFunction functionWithName: kCAValueFunctionRotateZ];
    
    [self.needle.layer addAnimation:anim forKey:nil];
    
    
}


-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}


@end
