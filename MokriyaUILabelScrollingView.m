//
//  MokriyaUILabelScrollingView.m
//  scrollingLabelView
//
//  Created by Mohith K M on 10/19/11.
//  Copyright 2011 Mokriya (www.mokriya.com). All rights reserved.
//

#import "MokriyaUILabelScrollingView.h"


@implementation MokriyaUILabelScrollingView
@synthesize titlesArray;
@synthesize timeInterval;
@synthesize titleLabel;
@synthesize repeatTitles;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        timeInterval = 5.0;
        currentIndex = 0;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.repeatTitles = YES;
        triggerLeftSwipeGestureWhenTouchUP = NO;
        triggerRightSwipeGestureWhenTouchUP = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc
{
    if (animationTimer!=nil) {
        [animationTimer invalidate];
        animationTimer = nil;
    }
    
    [tapRecognizer release];
    [titlesArray release];
    [titleLabel release];
    [super dealloc];
}

- (void)prepareAndStart
{
    
    if (![titlesArray count]>0) {
        NSLog(@"titlesArray should be filled");
    }
    
    tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped)] autorelease];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    
    
    
    [self addSubview:titleLabel];
    [self start];
}



- (void)start
{
    currentIndex = -1;
    [self showNextTitle];
}

- (void)pause
{
    
}

- (void)showNextTitle
{
    if (currentIndex>=[titlesArray count]- 1) {
        
        if (self.repeatTitles) {
            currentIndex = -1;
        } else {
            return;
        }
        
    }
    currentIndex ++;
    [self doAnimation];
}

- (void)showPreviousTitle
{
    if (currentIndex<=0) {
        
        if (self.repeatTitles) {
            currentIndex = [titlesArray count];
        } else {
            return;
        }
        
    }
    currentIndex --;
    [self doAnimation];
}

- (void)didTapped
{
    [delegate didTappedAtIndex:currentIndex];
    
}

#pragma mark-Animation
- (void)doAnimation
{
    if (animationTimer!=nil) {
        [animationTimer invalidate];
        animationTimer = nil;
    }
    
    NSString *title = [titlesArray objectAtIndex:currentIndex];
    titleLabel.text = title;
    CGRect titleFrame = titleLabel.frame;
    titleFrame.size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    titleFrame.origin = CGPointMake(self.frame.size.width, (self.frame.size.height/2)-(titleFrame.size.height/2));
    titleLabel.frame = titleFrame;
    currentAnimationDuration = 0;
    currentAnimationDurationLimit = timeInterval/self.frame.size.width*(self.frame.size.width+titleFrame.size.width);
    animationTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval/self.frame.size.width target:self selector:@selector(animateFunction) userInfo:nil repeats:YES];
    [animationTimer fire];
}

- (void)animateFunction
{
    // NSLog(@"%@",titleLabel);
    currentAnimationDuration += timeInterval/self.frame.size.width;
    if (currentAnimationDuration>=currentAnimationDurationLimit) {
        [self animationDidFinished];
        if (animationTimer!=nil) {
            [animationTimer invalidate];
            animationTimer = nil;
        }
        return;
    }
    
    titleLabel.center = CGPointMake(titleLabel.center.x-1, titleLabel.center.y);
    
}

- (void)animationDidFinished
{
    
    [self showNextTitle];
}



#pragma mark- Touch and SwipeGesture 

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (animationTimer!=nil) {
        [animationTimer invalidate];
        animationTimer = nil;
    }

    titleLabelRecentRect = titleLabel.frame;
    CGPoint tappedPt = [[touches anyObject] locationInView:self];
    CGRect  titleLabelRect = titleLabel.frame;
     titleLabelRect.origin.x = titleLabelRecentRect.origin.x - (tappedPt.x-touchDownPoint.x);
    touchDownPoint.x = tappedPt.x;
    touchDownPoint.y = tappedPt.y;
    gestureTouchDownPoint =touchDownPoint;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    CGPoint currentPosition = [[touches anyObject] locationInView:self];
    CGRect  titleLabelRect = titleLabel.frame;
    if (currentPosition.x>touchDownPoint.x) {
        titleLabelRect.origin.x = titleLabelRecentRect.origin.x - (touchDownPoint.x - currentPosition.x);
    } else {
        titleLabelRect.origin.x = titleLabelRecentRect.origin.x + (currentPosition.x-touchDownPoint.x);
    }

    titleLabel.frame = titleLabelRect;

    
    CGFloat deltaXX = (gestureTouchDownPoint.x - currentPosition.x); 
    CGFloat deltaX = fabsf(gestureTouchDownPoint.x - currentPosition.x); 
    CGFloat deltaY = fabsf(gestureTouchDownPoint.y - currentPosition.y); 
    
    if (deltaX >= 30 && deltaY <= self.frame.size.height) {
        if (deltaXX > 0) {
            triggerLeftSwipeGestureWhenTouchUP = YES;
            triggerRightSwipeGestureWhenTouchUP = NO;
            gestureTouchDownPoint = currentPosition;
        }
        else {

            triggerRightSwipeGestureWhenTouchUP = YES;
            triggerLeftSwipeGestureWhenTouchUP = NO;
            gestureTouchDownPoint = currentPosition;
           
        }
        
    }
    
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (triggerLeftSwipeGestureWhenTouchUP) {
        [self leftSwipeGesture];
    } else if (triggerRightSwipeGestureWhenTouchUP)
    {
        [self rightSwipeGesture];
    }
    triggerLeftSwipeGestureWhenTouchUP = NO;
    triggerRightSwipeGestureWhenTouchUP = NO;
} 


- (void)leftSwipeGesture
{
    CGRect titleFrame = titleLabel.frame;
    [UIView beginAnimations:@"DoneWithLeftSwipe" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationDuration:0.50];
    titleFrame.origin.x =-320;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    titleLabel.frame = titleFrame;
    [UIView commitAnimations];
    
    
}

- (void)rightSwipeGesture
{
    CGRect titleFrame = titleLabel.frame;
    [UIView beginAnimations:@"DoneWithRightSwipe" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationDuration:0.50];
    titleFrame.origin.x =640;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    titleLabel.frame = titleFrame;
    [UIView commitAnimations];
}

- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if (![finished boolValue]) {
        return;
    }
    if ([animationID isEqualToString:@"DoneWithLeftSwipe"])
    {
        [self showNextTitle];
    } else if ([animationID isEqualToString:@"DoneWithRightSwipe"])
    {
        [self showPreviousTitle];
    } 
}



@end
