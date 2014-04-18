//
//  FirstViewController.m
//  Bike App
//
//  Created by Christian Turkoanje on 4/16/14.
//  Copyright (c) 2014 Christian Turkoanje. All rights reserved.
//

#import "FirstViewController.h"
#import "TOWebViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        settings = [[NSMutableDictionary alloc] initWithContentsOfFile:[self dataFilePath]];
        
        NSString *email = [settings valueForKey:@"email"];
        NSString *password = [settings valueForKey:@"password"];
        
        NSURL *websiteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.bikeapp.me/app/ios/?email=%@&password=%@", email, password]];
        
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
        [_mainWebView loadRequest:urlRequest];
        
        
    }


}
-(void)viewDidAppear:(BOOL)animated
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]])
        [self openLoginPage];
}

-(void)openLoginPage
{
    NSURL *url = [NSURL URLWithString:@"http://api.bikeapp.me/app_ios/"];
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
}


- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"settings.plist"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
