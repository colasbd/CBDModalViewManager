//
//  CBDModalViewManager.m
//
//  Created by Colas on 17/10/2014.
//

#import "CBDModalViewManager.h"









//
//
/**************************************/
#pragma mark - Constants
/**************************************/

static CGFloat const kDefaultOpacity = 0.8 ;
static NSTimeInterval const kDefaultDuration = 0.3 ;
static CBDModalViewManagerTransitionType const kDefaultTransitionType = CBDModalViewManagerComesFromLeft ;









@interface CBDModalViewManager ()

/*
 Parameters
 */
@property (nonatomic, weak, readwrite) UIViewController * presentedVC ;
@property (nonatomic, weak, readwrite) UIViewController * presenterVC ;


/*
 Components
 */
@property (nonatomic, strong, readwrite) UIView * handlerForPresentedView ;


/*
 Convenience properties
 */
@property (nonatomic, readonly) UIView * presentedView ;
@property (nonatomic, readonly) UIView * presenterView ;


@end















@implementation CBDModalViewManager



/**************************************/
#pragma mark - Init
/**************************************/


- (instancetype)initWithPresentedViewController:(UIViewController *)presentedVC
                    overPresenterViewController:(UIViewController *)presenterVC
{
    self = [super init] ;
    
    if (self)
    {
        /*
         Default values
         */
        _opacity = kDefaultOpacity ;
        _durationWhenAppears = kDefaultDuration ;
        _durationWhenDisappears = kDefaultDuration ;
        _transitionType = kDefaultTransitionType ;
        
        
        
        /*
         Parameters
         */
        _presentedVC = presentedVC;
        _presenterVC = presenterVC ;

        
        
        /*
         We load the view of the VCs !
         */
        [presentedVC view] ;
        [presenterVC view] ;
    }
    
    return self ;
}


- (void)createTheHandlerView
{
    UIView * result ;
    
    /*
     The frame
     */
    CGRect frame ;
    CGSize size = CGSizeApplyAffineTransform(self.presenterView.frame.size,
                                            self.presenterView.transform) ;
    
    frame.size = CGSizeMake(ABS(size.width),
                            ABS(size.height)) ;
    frame.origin = CGPointZero ;
    
    /*
     Creating the view
     */
    result = [[UIView alloc] initWithFrame:frame] ;
    
    
    /*
     Configuring it
     */
    result.backgroundColor = [UIColor colorWithRed:0
                                             green:0
                                              blue:0
                                             alpha:self.opacity] ;
    
    /*
     Placing the presented view inside
     */
    self.presentedView.center = result.center ;
    [result addSubview:self.presentedView] ;

    
    /*
     Assigning
     */
    _handlerForPresentedView = result ;
}




//
//
/**************************************/
#pragma mark - Convenience methods
/**************************************/

- (UIView *)presentedView
{
    return self.presentedVC.view ;
}

- (UIView *)presenterView
{
    return self.presenterVC.view ;
}


//
//
/**************************************/
#pragma mark - Core methods
/**************************************/


- (void)present
{
    [self configureViewsBeforeAnimationForAppearingForType:self.transitionType] ;
    
    [UIView animateWithDuration:self.durationWhenAppears/3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [self.presenterView addSubview:self.handlerForPresentedView] ;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:self.durationWhenAppears*2/3
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              self.presentedView.alpha = 1 ;
                                              self.presentedView.transform = CGAffineTransformIdentity ;                                          }
                                          completion:nil] ;
                     }];
}


- (void)dismiss
{
    [UIView animateWithDuration:self.durationWhenAppears*2/3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         [self configureViewsInAnimationForDisappearingForType:self.transitionType] ;
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:self.durationWhenAppears*1/3
                                               delay:0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.handlerForPresentedView.alpha = 0 ;
                                          }
                                          completion:^(BOOL finished) {
                                              self.presentedView.transform = CGAffineTransformIdentity ;
                                              [self.presentedView removeFromSuperview] ;
                                              [self.handlerForPresentedView removeFromSuperview] ;
                                              self.handlerForPresentedView = nil ;
                                          }] ;
                     }];

}





/*
 Appearing animations
 */
- (void)configureViewsBeforeAnimationForAppearingForType:(CBDModalViewManagerTransitionType)transitionType
{
    /*
     First, we create the handler
     */
    [self createTheHandlerView] ;
    
    
    
    /*
     Then, we set the opacity to 0
     */
    self.presentedView.alpha = 0 ;
    
    
    
    /*
     Finally, we assign a transform to the presented view
     */
    CGAffineTransform transformBefore ;
    
    switch (transitionType) {
        case CBDModalViewManagerSplash:
            transformBefore = CGAffineTransformMakeScale(0, 0) ;
            break;
            
        case CBDModalViewManagerComesFromLeft:
        {
            CGFloat distanceForTranslation ;
            distanceForTranslation = (self.presenterView.frame.size.width + self.presentedView.frame.size.width)/2 ;
            
            transformBefore = CGAffineTransformMakeTranslation(-distanceForTranslation, 0) ;
        }
            break;
            
        default:
            transformBefore = CGAffineTransformMakeScale(0, 0) ;
            break;
    }
    
    self.presentedView.transform = transformBefore ;
}





/*
 Disappearing animations
 */
- (void)configureViewsInAnimationForDisappearingForType:(CBDModalViewManagerTransitionType)transitionType
{
    /*
     Then, we assign a transform to the presented view
     */
    CGAffineTransform transformBefore ;
    
    switch (transitionType) {
        case CBDModalViewManagerSplash:
            transformBefore = CGAffineTransformMakeScale(0, 0) ;
            break;
            
        case CBDModalViewManagerComesFromLeft:
        {
            CGFloat distanceForTranslation ;
            distanceForTranslation = (self.presenterView.frame.size.width + self.presentedView.frame.size.width)/2 ;
            
            transformBefore = CGAffineTransformMakeTranslation(+distanceForTranslation, 0) ;
        }
            break;
            
        default:
            transformBefore = CGAffineTransformMakeScale(0, 0) ;
            break;
    }
    
    self.presentedView.transform = transformBefore ;

}





@end
