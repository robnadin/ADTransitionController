# ADTransitionController - 3D transitions for your apps

ADTransitionController brings all the power of the Core Animation framework to your apps with nice pre-defined transitions.

* For apps supporting iOS 7 and beyond, we have a very generic API that uses the new `UIViewControllerTransitioningDelegate` protocol, making it usable for any transition (navigation, modal, tab bar).

## Installation

### Basic
1. Add the content of the `ADTransitionController` folder to your iOS project
2. Link against the `QuartzCore` Framework if you don't already
3. Import `ADTransitionController.h` in your project

### CocoaPods

1. Add `pod 'ADTransitionController'` to your `Podfile`
2. In your terminal run `$ pod install` and open your workspace `$ open yourApp.xcworkspace`
3. Import `<ADTransitionController.h>` in your project

## Example

Your project is now ready to take advantage of `ADTransitionController`. We're making use of the new `UIViewControllerTransitioningDelegate` protocol. The API provided by Apple is quite complex, but we made it very simple to use.

#### In short:
1. Set the delegate of your navigation controller to the one that we give you.
2. Make your view controller inherit from `ADTransitioningViewController` (if this is not an option for you, see below).
3. Set the `transition` property of your view controller to your favorite transition.

#### In details:

First of all, create your `UINavigationController` and set its delegate to a `ADNavigationControllerDelegate` instance. 

```objective-c
#import "ADNavigationControllerDelegate.h"
...
UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
ADNavigationControllerDelegate * navigationDelegate = [[ADNavigationControllerDelegate alloc] init];
navigationController.delegate = navigationDelegate;
self.window.rootViewController = navigationController;
[navigationController release];
```

Then create your new controller (that inherits from `ADTransitioningViewController`), set its transition and push it onto the stack. In this example, this will animate the transition with a cube effect.

```objective-c
UIViewController * newViewController = [[UIViewController alloc] init];
ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
newViewController.transition = transition;
[self.navigationController pushViewController:newViewController animated:YES];
[transition release];
[newViewController release];
```

If your view controller can't inherit from `ADTransitioningViewController`, you can use directly an `ADTransitioningDelegate` object to control the transition.

```objective-c
UIViewController * newViewController = [[UIViewController alloc] init];
ADTransition * transition = [[ADCubeTransition alloc] initWithDuration:0.25f orientation:ADTransitionRightToLeft sourceRect:self.view.frame];
ADTransitioningDelegate * transitioningDelegate = [[ADTransitioningDelegate alloc] initWithTransition:transition];
newViewController.transitioningDelegate = transitioningDelegate;
[self.navigationController pushViewController:newViewController animated:YES];
[transition release];
[newViewController release];
```

#### Under the hood

To create a custom animation, Apple provides different protocols we have implemented for you : `UIViewControllerTransitioningDelegate`, `UIViewControllerAnimatedTransitioning`, `UIViewControllerContextTransitioning`. That way, you shouldn't bother to dig into these APIs. 

As we have just seen it, in practice, what you only have to do on iOS7 is to create a `UINavigationController`, and a `ADTransition`.

To sum up, we provide three different classes you may want to use : 

* `ADNavigationControllerDelegate` : used when you setup your navigation controller to perform custom animations
* `ADTransitioningViewController` : used for your view controllers to control their transitions
* `ADTransitioningDelegate` : used only if you can't inherit from `ADTransitioningViewController` and need to specify the transitioning delegate for the view controller

### Delegate

Like a `UINavigationController`, an `ADTransitionController` informs its delegate that a viewController is going to be presented or was presented. The delegate implements the `ADTransitionControllerDelegate` protocol.

```objective-c
@property (nonatomic, assign) id<ADTransitionControllerDelegate> delegate;
```

```objective-c
@protocol ADTransitionControllerDelegate <NSObject>
- (void)transitionController:(ADTransitionController *)transitionController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)transitionController:(ADTransitionController *)transitionController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
@end
```


## Going Further

If you want to totally take control of the `ADTransitionController` API, feel free to create your own transitions and animations!
All you need to do is to subclass `ADDualTransition` or `ADTransformTransition` and implement a `init` method.

The simplest example of a custom transition is the `ADFadeTransition` class. The effect is simple: the inViewController fades in. For this the inViewController changes its opacity from 0 to 1 and the outViewController from 1 to 0.

```objective-c
@interface ADFadeTransition : ADDualTransition
@end
@implementation ADFadeTransition
- (id)initWithDuration:(CFTimeInterval)duration {
    CABasicAnimation * inFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    inFadeAnimation.fromValue = @0.0f;
    inFadeAnimation.toValue = @1.0f;
    inFadeAnimation.duration = duration;
    
    CABasicAnimation * outFadeAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    outFadeAnimation.fromValue = @1.0f;
    outFadeAnimation.toValue = @0.0f;
    outFadeAnimation.duration = duration;
    
    self = [super initWithInAnimation:inFadeAnimation andOutAnimation:outFadeAnimation];
    return self;
}
@end
```

This example is really basic and if you want to create more funky effects, just have a look to the following API and the examples we provided.

### ADTransition API

The `ADTransition` class is an abstract class that has two abstract subclasses: `ADDualTransition` and `ADTransformTransition`.

Instances of `ADDualTransition` have two importants properties: 

```objective-c
@property (nonatomic, readonly) CAAnimation * inAnimation;
@property (nonatomic, readonly) CAAnimation * outAnimation;
```

The `inAnimation` is the `CAAnimation` that will be applied to the layer of the viewController that is going to be presented during the transition.
The `outAnimation` is the `CAAnimation` that will be applied to the layer of the viewController that is going to be dismissed during the transition.

Instance of `ADTransformTransition` have three importants properties:

```objective-c
@property (readonly) CAAnimation * animation;
@property (readonly) CATransform3D inLayerTransform;
@property (readonly) CATransform3D outLayerTransform;
```

The `inLayerTransform` is the `CATransform3D` that will be applied to the layer of the viewController that is going to be presented during the transition.
The `outLayerTransform` is the `CATransform3D` that will be applied to the layer of the viewController that is going to be dismissed during the transition.
The `animation` is the `CAAnimation` that will be applied to the content layer of the ADTransitionController (i.e. the parent layer of the two former viewController layers).

## Future Work

There are a couple of improvements that could be done. Feel free to send us pull requests if you want to contribute!

- Add new custom transitions
- Add support for non plane transitions (Fold transition for instance)
- More?
