//
//  MokriyaWebViewController.m
//  scrollingLabelView
//
//  Created by Mohith K M on 10/19/11.
//  Copyright 2011 Mokriya (www.mokriya.com). All rights reserved.
//

#import "MokriyaWebViewController.h"
#import "MokriyaUILabelScrollingView.h"

@implementation MokriyaWebViewController
@synthesize webView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle




- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSURL *url = [NSURL URLWithString:@"http://www.mokriya.com"];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    
    
    
    
    
    
    MokriyaUILabelScrollingView *scrollingView = [[MokriyaUILabelScrollingView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    scrollingView.backgroundColor = [UIColor grayColor];
    
    scrollingView.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    scrollingView.titlesArray = [[NSMutableArray alloc] initWithObjects:
                                 @"Hipster iOS App",
                                 @"HomeRun iOS & Android App.",
                                 @"SimpleGeo",
                                 @"Path",
                                 @"ThinkAha",
                                 @"HeyWire",
                                 @"BottomLine",
                                 @"MySizeFinder", nil];  
    [scrollingView prepareAndStart];
    scrollingView.delegate = self;
    [self.view addSubview:scrollingView];
    
    [scrollingView release];
    
    
    
    
}

#pragma Delegate Methods
- (void)didTappedAtIndex:(int)index
{
    NSLog(@"Tapped at index %d",index);
}

-(void)webViewDidStartLoad:(UIWebView *) portal
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)portal{
    
} 
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",[error localizedDescription]);
	NSString *msg=@"Please try again after some time";
	UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Request failed" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[alert show];	
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        return NO;
	}
	return YES;
}


@end
