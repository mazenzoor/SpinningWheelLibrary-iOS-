# SpinningWheelLibrary (iOS) Documentation

### Implementation

1. Create the Wheel Object <br>
```objective-c

  //// Create the wheel object
  @property (nonatomic, retain) Wheel * wheel;
  
  wheel = [[Wheel alloc] initWithData: yourWheelImageView numberOfSlice: nbOfSlices];
  
  ```
  
2. Spin the wheel to index
    ```objective-c

    wheel spinTo: 4];

    ```
  


### Optional

Implement the callback that allows you to be notified when the animation is **done**

  ```objective-c
  
  //// Callback Done Animating
  @property (nonatomic, retain) id <DoneAnimating> callback;
  
  
  //// In ViewDidLoad
  wheel.callback = self;
  
  
  //// Method
  - (void) doneAnimating {
    
    // Code After Animation Done
    
  }
  
  ```
