//
//  ArticleViewController.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/22/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "ArticleViewController.h"

@interface ArticleViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSString *urlString;

@end

@implementation ArticleViewController

- (id)initWithUrl:(NSString *)urlString {
    if (self = [super initWithNibName:@"ArticleViewController" bundle:nil]) {
        _urlString = urlString;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [self.webView loadRequest:req];
}

@end
