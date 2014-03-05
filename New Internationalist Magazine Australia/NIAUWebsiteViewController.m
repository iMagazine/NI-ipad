//
//  NIAUWebsiteViewController.m
//  New Internationalist Magazine Australia
//
//  Created by Simon Loffler on 6/02/2014.
//  Copyright (c) 2014 New Internationalist Australia. All rights reserved.
//

#import "NIAUWebsiteViewController.h"

@interface NIAUWebsiteViewController ()

@end

@implementation NIAUWebsiteViewController

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
    
    [self.webView loadRequest:self.linkToLoad];
    self.browserURL.title = [self.linkToLoad.URL absoluteString];
    
    [self sendGoogleAnalyticsStats];
}

- (void)sendGoogleAnalyticsStats
{
    // Setup Google Analytics
    [[GAI sharedInstance].defaultTracker set:kGAIScreenName
                                       value:[NSString stringWithFormat:@"Webview - %@", [self.linkToLoad.URL absoluteString]]];
    
    // Send the screen view.
    [[GAI sharedInstance].defaultTracker
     send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button actions

- (IBAction)dismissButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButtonTapped:(id)sender
{
    // Go back
    [self.webView goBack];
}

- (IBAction)forwardButtonTapped:(id)sender
{
    // Go forward
    [self.webView goForward];
}

- (IBAction)refreshButtonTapped:(id)sender
{
    // Refresh UIWebView
    [self.webView reload];
}

- (IBAction)shareButtonTapped:(id)sender
{
    // Pop share modal
    NSString *fromLink = @"";
    NSString *fromTitle = @"";
    if (self.article) {
        fromLink = [self.article.getGuestPassURL absoluteString];
        fromTitle = self.article.title;
    } else if (self.issue) {
        fromLink = [[self.issue getWebURL] absoluteString];
        fromTitle = self.issue.title;
    }
    NSMutableArray *itemsToShare = [[NSMutableArray alloc] initWithArray:@[[NSString stringWithFormat:@"A link I found reading '%@' from New Internationalist magazine.\n%@\n\nThe link is:", fromTitle, fromLink], self.webView.request.URL.absoluteString]];
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    [activityController setValue:[NSString stringWithFormat:@"Link from New Internationalist"] forKey:@"subject"];
    [self presentViewController:activityController animated:YES completion:nil];

}

- (void)updateButtons
{
    self.browserForward.enabled = self.webView.canGoForward;
    self.browserBack.enabled = self.webView.canGoBack;
}

#pragma mark - UIWebView delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    self.browserURL.title = [[self.webView.request.URL URLByDeletingLastPathComponent] absoluteString];
    [self updateButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self updateButtons];
}

@end