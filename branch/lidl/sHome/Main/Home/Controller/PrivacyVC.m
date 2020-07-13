//
//  PrivacyVC.m
//  sHome
//
//  Created by Ryan Hsueh on 2018/11/13.
//  Copyright © 2018 shaop. All rights reserved.
//

#import "PrivacyVC.h"

@interface PrivacyVC ()

@end

@implementation PrivacyVC {
    WKWebView *webView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"隐私政策", nil);
    
    webView = [WKWebView new];
    webView.autoresizesSubviews = YES;

    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
//    NSLog(@"[RYAN] +++++++ languageName = %@", languageName);
    
    NSString* path = @"privacy_english";
    if ([languageName containsString:@"cs"]) {
        path = @"privacy_czech";
    } else if ([languageName containsString:@"de"]) {
        path = @"privacy_german";
    } else if ([languageName containsString:@"es"]) {
        path = @"privacy_spanish";
    } else if ([languageName containsString:@"nl"]) {
        path = @"privacy_dutch";
    } else if ([languageName containsString:@"fr"]) {
        path = @"privacy_french";
    } else if ([languageName containsString:@"it"]) {
        path = @"privacy_italian";
    } else if ([languageName containsString:@"sl"]) {
        path = @"privacy_slovenian";
    } else if ([languageName containsString:@"fi"]) {
        path = @"privacy_finnish";
    }
    
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:path ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [webView loadHTMLString:htmlString baseURL: [[NSBundle mainBundle] bundleURL]];
    
    [self.view addSubview:webView];
    
}

- (void)viewDidLayoutSubviews {
    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
