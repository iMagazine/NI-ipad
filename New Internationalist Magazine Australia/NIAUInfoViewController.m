//
//  NIAUInfoViewController.m
//  New Internationalist Magazine Australia
//
//  Created by Simon Loffler on 21/02/2014.
//  Copyright (c) 2014 New Internationalist Australia. All rights reserved.
//

#import "NIAUInfoViewController.h"

@interface NIAUInfoViewController ()

@property (nonatomic, weak) NSString *version;
@property (nonatomic, weak) NSString *build;

@end

@implementation NIAUInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self setupView];
    [self sendGoogleAnalyticsStats];
}

- (void)setupView
{
    // Update the version number
    self.version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    self.build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    self.versionNumber.text = [NSString stringWithFormat:@"Version %@ (%@)", self.version, self.build];
    self.versionNumber.editable = false;
    self.versionNumberHeight.constant = [self.versionNumber sizeThatFits:CGSizeMake(self.versionNumber.frame.size.width, CGFLOAT_MAX)].height + 1.0;
    
    // Add the about text
    NSString *aboutFile = [[NSBundle mainBundle] pathForResource:@"about" ofType:@"html"];
    NSString *aboutString = [NSString stringWithContentsOfFile:aboutFile encoding:NSUTF8StringEncoding error:nil];
    [self.aboutWebView loadHTMLString:aboutString baseURL:nil];
    
    // Set the Analytics setting from user preferences
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"googleAnalytics"]) {
        [self.analyticsSwitch setOn:TRUE animated:TRUE];
    } else {
        [self.analyticsSwitch setOn:FALSE animated:TRUE];
    }
    
    // Prevent webview from scrolling
    if ([self.aboutWebView respondsToSelector:@selector(scrollView)]) {
        self.aboutWebView.scrollView.scrollEnabled = NO;
    }
    self.scrollView.scrollsToTop = YES;
}

- (void)updateWebViewHeight
{
    // Set the webview size
    CGSize size = [self.aboutWebView sizeThatFits: CGSizeMake(320., 1.)];
    CGRect frame = self.aboutWebView.frame;
    frame.size.height = size.height;
    self.aboutWebView.frame = frame;
    
    // Update the constraints.
    CGFloat contentHeight = self.aboutWebView.frame.size.height;
    
    self.aboutWebViewHightConstraint.constant = contentHeight;
    [self.aboutWebView setNeedsUpdateConstraints];
    [self.aboutWebView setNeedsLayout];
    NSLog(@"Updated webview height: %f", self.aboutWebView.frame.size.height);
}

- (void)updateScrollViewContentHeight
{
    CGRect contentRect = CGRectZero;
    for (UIView *view in self.scrollView.subviews) {
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    self.scrollView.contentSize = contentRect.size;
    [self.scrollView setNeedsLayout];
    NSLog(@"Scrollview height: %f",self.scrollView.contentSize.height);
}

- (void)sendGoogleAnalyticsStats
{
    // Setup Google Analytics
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName
                                       value:@"About"];
    
    // Send the screen view.
    [[GAI sharedInstance].defaultTracker
     send:[[GAIDictionaryBuilder createAppView] build]];
}

- (IBAction)switchChanged: (id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([self.analyticsSwitch isOn]) {
        [userDefaults setBool:TRUE forKey:@"googleAnalytics"];
        [[GAI sharedInstance] setOptOut:NO];
    } else {
        [userDefaults setBool:FALSE forKey:@"googleAnalytics"];
        [[GAI sharedInstance] setOptOut:YES];
    }
    [userDefaults synchronize];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        
        if (!([[request.URL absoluteString] rangeOfString:@"feedback"].location == NSNotFound)) {
            // Feedback link in HTML tapped
            [self feedbackButtonTapped:request];
            return NO;
        } else {
            // A web link was tapped
            // Segue to NIAUWebsiteViewController so users don't leave the app.
            [self performSegueWithIdentifier:@"infoToWebsite" sender:request];
            return NO;
        }
    } else {
        // Normal request, so load the UIWebView
        return YES;
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateWebViewHeight];
    [self updateScrollViewContentHeight];
}

#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"infoToWebsite"]) {
        // Send the weblink
        NIAUWebsiteViewController *websiteViewController = [segue destinationViewController];
        websiteViewController.linkToLoad = sender;
    }
}

#pragma mark - Button actions

- (IBAction)dismissButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)feedbackButtonTapped:(id)sender
{
    // Prepare email;
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"I'm using the @ni_australia app version %@ (%@), and my feedback/suggestions are:",self.version, self.build]]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [activityController setValue:[NSString stringWithFormat:@"NI App feedback - %@ (%@)", self.version, self.build] forKey:@"subject"];
    [self presentViewController:activityController animated:YES completion:nil];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self updateWebViewHeight];
    [self updateScrollViewContentHeight];
}

@end
