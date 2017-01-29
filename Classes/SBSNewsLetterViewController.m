// SebastiaanSchool (c) 2014 by Jeroen Leenarts
//
// SebastiaanSchool is licensed under a
// Creative Commons Attribution-NonCommercial 3.0 Unported License.
//
// You should have received a copy of the license along with this
// work.  If not, see <http://creativecommons.org/licenses/by-nc/3.0/>.
//
//  SBSNewsLetterViewController.m
//  SebastiaanSchool
//
//  Created by Jeroen Leenarts on 11-01-13.
//
//
#import <Parse/Parse.h>
#import "SBSNewsLetterViewController.h"

@interface SBSNewsLetterViewController ()

@property (nonatomic, strong) SBSNewsLetter * newsLetter;
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation SBSNewsLetterViewController

- (id)initWithNewsLetter:(SBSNewsLetter *)newsLetter {
    self = [super init];
    if (self) {
        _newsLetter = newsLetter;
    }

    return self;
}

- (void)loadView{
    self.webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    self.view = self.webView;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin;
    CGRect activityFrame = self.activityIndicator.frame;
    activityFrame.origin.y = (self.view.bounds.size.height - activityFrame.size.height) / 2.0f;
    activityFrame.origin.x = (self.view.bounds.size.width - activityFrame.size.width) / 2.0f;
    self.activityIndicator.frame = CGRectIntegral(activityFrame);
    [self.view addSubview:self.activityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.newsLetter.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

#pragma mark - UIWebView delegate implementation
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    ALog(@"Error web, %@", error);
    [self.activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    DLog(@"Request: %@", request);
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    ALog(@"Finish web");
    [self.activityIndicator stopAnimating];
    @weakify(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        @strongify(self);
        [self.webView.scrollView setContentOffset:CGPointMake(0.0f,-self.topLayoutGuide.length) animated:YES];
    });
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    ALog(@"Start web");
    [self.activityIndicator startAnimating];
}

@end
