//
//  LYNavigationVC.m
//  CustomNavAnimation
//
//  Created by liyang on 16/3/23.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYNavigationController.h"
#import "FirstVC.h"

typedef enum {
    AnimationTypePush,
    AnimationTypePop
} AnimationType;

@interface ShadowView : UIView

@end

@implementation ShadowView

@end

@interface NavigationAnimation : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) AnimationType animationType;

@end

@implementation NavigationAnimation

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    /**
     *  获取来自哪个控制器
     */
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    /**
     *  获取跳转到哪个控制器
     */
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    /**
     *  获取控制两个转场的视图
     */
    UIView *containerView = [transitionContext containerView];
    
    CGRect bounds = [UIScreen mainScreen].bounds;

    if (self.animationType == AnimationTypePush)
    {
        [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
        ShadowView *shadowView = [[ShadowView alloc] initWithFrame:bounds];
        shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        shadowView.userInteractionEnabled = NO;
        
        [fromVC.view addSubview:shadowView];
        
        toVC.view.frame = CGRectMake(bounds.size.width, 0, 
                                     bounds.size.width, bounds.size.height);
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            shadowView.backgroundColor = [[UIColor blackColor] 
                                          colorWithAlphaComponent:0.7f];
            fromVC.view.frame = CGRectMake(15, 15, bounds.size.width-15, 
                                                   bounds.size.height-30);
            toVC.view.frame = CGRectMake(0, 0, bounds.size.width, 
                                               bounds.size.height);
            
        } 
                         completion:^(BOOL finished)
        {
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
    else if (self.animationType == AnimationTypePop)
    {
        [containerView insertSubview:toVC.view belowSubview:fromVC.view];
        
        ShadowView *shadowView = nil;
        for (UIView *view in toVC.view.subviews)
        {
            if ([view isKindOfClass:[ShadowView class]])
            {
                shadowView = (ShadowView *)view;
            }
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^
        {
            shadowView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0f];
            
            fromVC.view.frame = CGRectMake(bounds.size.width, 0,
                                           bounds.size.width,bounds.size.height);
            toVC.view.frame = CGRectMake(0, 0, bounds.size.width,
                                         bounds.size.height);
        }
                         completion:^(BOOL finished)
        {
            if (![transitionContext transitionWasCancelled])
            {
                [shadowView removeFromSuperview];
            }
            
            [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        }];
    }
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

@end


@interface LYNavigationController ()
 <UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NavigationAnimation *navAnimation;

@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *drivenInteractiveTransition;

@end

@implementation LYNavigationController

#pragma mark - customer Method

- (void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture
{
    CGPoint point = [gesture translationInView:gesture.view];
    
    CGFloat progress = point.x / gesture.view.bounds.size.width;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        self.drivenInteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        /**
         *  point.x > 0 --- 向右滑动
         *  point.x < 0 --- 向左滑动
         */
        if (self.viewControllers.count > 0 && point.x < 0)
        {
            [self pushViewController:[FirstVC new] animated:YES];
        }
        else if (self.viewControllers.count > 1 && point.x > 0)
        {
            [self popViewControllerAnimated:YES];
        }
    }
    else if (gesture.state == UIGestureRecognizerStateChanged)
    {
        /**
         *  updateInteractiveTransition:progress 中的progress必须为正数
         */
        progress = point.x < 0 ? -progress : progress;
        [self.drivenInteractiveTransition updateInteractiveTransition:progress];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded ||
             gesture.state == UIGestureRecognizerStateCancelled)
    {
        /**
         *  判断滑动的比例是否大于0.5
         */
        if (fabs(progress) > 0.5f)
        {
            [self.drivenInteractiveTransition finishInteractiveTransition];
        }
        else
        {
            [self.drivenInteractiveTransition cancelInteractiveTransition];
        }
        self.drivenInteractiveTransition = nil;
    }
}

#pragma mark - UINavigationControllerDelegate

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation 
                                               fromViewController:(UIViewController *)fromVC 
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush)
    {
        self.navAnimation.animationType = AnimationTypePush;
    }
    else if (operation == UINavigationControllerOperationPop)
    {
        self.navAnimation.animationType = AnimationTypePop;
    }
    
    return (id)self.navAnimation;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[NavigationAnimation class]])
    {
        NSLog(@"UIPercentDrivenInteractiveTransition:%@",self.drivenInteractiveTransition);
        return self.drivenInteractiveTransition;
    }
    
    return nil;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBarHidden = YES;
    self.delegate = self;
    
    self.interactivePopGestureRecognizer.enabled = NO;
    
    UIView *gestureView = self.interactivePopGestureRecognizer.view;
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] 
                                          initWithTarget:self
                                          action:@selector(panGestureRecognizer:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;
    [gestureView addGestureRecognizer:panGesture];
}

#pragma mark - Lazy loading

- (NavigationAnimation *)navAnimation
{
    if (!_navAnimation) {
        _navAnimation = [[NavigationAnimation alloc] init];
    }
    
    return _navAnimation;
}

@end
