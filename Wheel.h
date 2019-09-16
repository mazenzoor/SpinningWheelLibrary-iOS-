//
//  Wheel.h
//  SpinningWheel
//
//  Created by imac on 9/16/19.
//  Copyright © 2019 imac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#import "DoneAnimating.h"

NS_ASSUME_NONNULL_BEGIN

@interface Wheel : UIImageView


//// The actual wheel
@property (strong, nonatomic)  UIImageView *wheel;


//// Number of slices on the wheel
@property (nonatomic, assign) NSInteger number_of_slices;


//// The current slice index where the wheel rests
@property (nonatomic, assign) NSInteger current_index;


//// The index the wheel should spin to
@property (nonatomic, assign) NSInteger go_to_index;


//// The amount of offset the wheel is on in degrees
@property (nonatomic, assign) float offset;


//// The amount of degrees must spin to get to destination
@property (nonatomic, assign) float rotate_by_degrees;


//// The degree value of the go to index
@property (nonatomic, assign) float go_to_degrees;


//// BLock spin button during animation
@property (nonatomic, assign) BOOL isAnimating;


//// Call when done animating
@property (nonatomic, retain) id<DoneAnimating> _Nullable callback;



-(id) initWithData:(UIImageView *) wheelImageView
      numberOfSlice :(NSInteger *) nbOfSlices ;

-(void) spinTo:(NSInteger) index;




@end

NS_ASSUME_NONNULL_END
