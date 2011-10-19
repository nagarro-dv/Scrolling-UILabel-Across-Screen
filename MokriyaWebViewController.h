//
//  MokriyaWebViewController.h
//  scrollingLabelView
//
//  Created by Mohith K M on 10/19/11.
//  Copyright 2011 Mokriya (www.mokriya.com). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MokriyaUILabelScrollingView.h"

@interface MokriyaWebViewController : UIViewController  <UIWebViewDelegate,UILabelScrollViewDelegate>{
    
}
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@end
