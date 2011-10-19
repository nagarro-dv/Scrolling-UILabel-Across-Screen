//
//  MokriyaUILabelScrollingView.h
//  scrollingLabelView
//
//  Created by Mohith K M on 10/19/11.
//  Copyright 2011 Mokriya (www.mokriya.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@protocol UILabelScrollViewDelegate;
@interface MokriyaUILabelScrollingView : UIView <UIGestureRecognizerDelegate>{
    int currentIndex;
    BOOL repeatTitles;
    @private 
    UILabel *titleLabel;
    UISwipeGestureRecognizer *swipeRightGesture;
    UISwipeGestureRecognizer *swipeLeftRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    id <UILabelScrollViewDelegate> delegate;
}
@property (nonatomic, assign) id <UILabelScrollViewDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *titlesArray;
@property (nonatomic) NSTimeInterval timeInterval;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic) BOOL repeatTitles;

- (void)prepareAndStart;
- (void)start;
- (void)pause;
- (void)showNextTitle;
- (void)showPreviousTitle;
- (void)doAnimation;
@end

@protocol UILabelScrollViewDelegate <NSObject>

- (void)didTappedAtIndex:(int)index;

@end