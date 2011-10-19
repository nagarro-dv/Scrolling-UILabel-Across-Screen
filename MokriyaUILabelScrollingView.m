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
        
        timeInterval = 7.5;
        currentIndex = 0;
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.repeatTitles = YES;
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
    [tapRecognizer release];
    [swipeRightGesture release];
    [swipeLeftRecognizer release];
    
    
    [titlesArray release];
    [titleLabel release];
    [super dealloc];
}

- (void)prepareAndStart
{
    
    if (![titlesArray count]>0) {
        NSLog(@"titlesArray should be filled");
    }
    swipeRightGesture = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showPreviousTitle)] autorelease];
    swipeRightGesture.direction = UISwipeGestureRecognizerDirectionRight;
	[self addGestureRecognizer:swipeRightGesture];

    
    
    swipeLeftRecognizer = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showNextTitle)] autorelease];
    swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:swipeLeftRecognizer];

    
    
    tapRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapped)] autorelease];
    tapRecognizer.numberOfTapsRequired = 1;
    [self addGestureRecognizer:tapRecognizer];
    
    
    
    [self addSubview:titleLabel];
    [self start];
}

- (void)animateTimer
{
    titleLabel.center = CGPointMake(titleLabel.center.x-1, titleLabel.center.y);

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
    
    NSString *title = [titlesArray objectAtIndex:currentIndex];
    titleLabel.text = title;
    CGRect titleFrame = titleLabel.frame;
    titleFrame.size = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
    titleFrame.origin = CGPointMake(self.frame.size.width, (self.frame.size.height/2)-(titleFrame.size.height/2));
    titleLabel.frame = titleFrame;
    [UIView beginAnimations:@"ScrollTitle" context:nil];
    CGFloat max = 0;
    if (titleFrame.size.width>self.frame.size.width) {
        max = titleFrame.size.width;
    } else {
        max = self.frame.size.width;
    }
    NSTimeInterval animationDuration = timeInterval/self.frame.size.width*max;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
    [UIView setAnimationDuration:animationDuration];
    titleFrame.origin.x =titleFrame.origin.x- titleFrame.size.width - self.frame.size.width;
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    titleLabel.frame = titleFrame;
    [UIView commitAnimations];
}


- (void)animationFinished:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if (![finished boolValue]) {
        return;
    }
    if ([animationID isEqualToString:@"ScrollTitle"])
    {
        [self showNextTitle];
    }
}



@end
