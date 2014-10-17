//
//  CBDModalViewManager.h
//
//  Created by Colas on 17/10/2014.
//

#import <Foundation/Foundation.h>

@interface CBDModalViewManager : NSObject


#pragma mark - Parameters
@property (nonatomic, assign, readwrite) CGFloat opacity ;
@property (nonatomic, assign, readwrite) NSTimeInterval durationWhenAppears ;
@property (nonatomic, assign, readwrite) NSTimeInterval durationWhenDisappears ;


#pragma mark - Init

- (instancetype)initWithPresentedViewController:(UIViewController *)presentedVC
                    overPresenterViewController:(UIViewController *)presenterVC ;


#pragma mark - Core methods

- (void)present ;
- (void)dismiss ;


@end
