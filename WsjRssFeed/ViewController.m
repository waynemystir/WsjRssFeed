//
//  ViewController.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "ViewController.h"
#import "LoadWsjData.h"
#import "WsjTableView.h"

@interface ViewController () <LoadWsjDataDelegate, UIScrollViewDelegate>

#pragma mark Outlets

@property (weak, nonatomic) IBOutlet UIScrollView *headerScroller;
@property (weak, nonatomic) IBOutlet UIView *headersContainer;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;
@property (weak, nonatomic) IBOutlet UIView *tablesContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblcContainerCenterXConstr;

#pragma mark Various

@property (nonatomic, strong) UIColor *headerLblBgClr;

@end

@implementation ViewController

#pragma mark Lifecycle

- (id)init {
    if (self = [super initWithNibName:@"View" bundle:nil])
        [LoadWsjData manager].wsjDelegate = self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Wall Street Journal"];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int j = 0; j < 6; j++)
        [self.tablesContainer addSubview:[WsjTableView tableViewFactory:j]];
    
    CGRect s = [[UIScreen mainScreen] bounds];
    CGFloat sw = s.size.width;
    CGFloat sha = s.size.height - 108;
    
    [self.scroller removeConstraint:self.tblcContainerCenterXConstr];
    self.tablesContainer.translatesAutoresizingMaskIntoConstraints = YES;
    self.tablesContainer.frame = CGRectMake(0, 0, sw * 6, sha);
    self.scroller.contentSize = CGSizeMake(sw * 6, sha);
    self.scroller.delegate = self;
    
    [LoadWsjData loadWorldNews];
    [LoadWsjData loadOpinion];
    [LoadWsjData loadBusiness];
    [LoadWsjData loadMarkets];
    [LoadWsjData loadTech];
    [LoadWsjData loadLife];
}

#pragma mark Properties

- (UIColor *)headerLblBgClr {
    return _headerLblBgClr ? : (_headerLblBgClr = [UIColor colorWithRed:0.79f green:0.79f blue:0.79f alpha:1.0f]);
}

#pragma mark LoadWsjDataDelegate methods

- (void)loadedData:(LOAD_DATA_TYPE)dataType wsjItems:(NSArray *)wsjItems {
    WsjTableView *tv = [self.tablesContainer viewWithTag:(kWsjTblVwStartTag + dataType)];
    tv.tableViewData = wsjItems;
}

- (void)requestTimedOut:(LOAD_DATA_TYPE)dataType {
    [self displayFailMessage:dataType message:@"The request timed out."];
}

- (void)requestFailedOffline:(LOAD_DATA_TYPE)dataType {
    [self displayFailMessage:dataType message:@"Your device is not connected to the internet."];
}

- (void)requestFailed:(LOAD_DATA_TYPE)dataType {
    [self displayFailMessage:dataType message:@"A problem occurred."];
}

- (void)displayFailMessage:(LOAD_DATA_TYPE)dataType message:(NSString *)message {
    UILabel *nl = [[UILabel alloc] initWithFrame:[self.tablesContainer viewWithTag:(kWsjTblVwStartTag + dataType)].frame];
    nl.numberOfLines = 0;
    nl.lineBreakMode = NSLineBreakByWordWrapping;
    nl.backgroundColor = [UIColor clearColor];
    nl.textColor = [UIColor blackColor];
    nl.textAlignment = NSTextAlignmentCenter;
    nl.text = [NSString stringWithFormat:@"%@\n\nThe %@ could not be loaded.", message, dataTypeName(dataType)];
    [self.tablesContainer addSubview:nl];
}

#pragma mark Scroll View Delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float pageWidth = [[UIScreen mainScreen] bounds].size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    long currentPageNumber = lround(fractionalPage);
    
    UILabel *sl = (UILabel *) [self.headersContainer viewWithTag:(19000 + currentPageNumber)];
    [self.headerScroller scrollRectToVisible:sl.frame animated:YES];
    
    [self.headersContainer.subviews makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:(id)[UIColor clearColor]];
    sl.backgroundColor = self.headerLblBgClr;
}

#pragma mark Tap Gestures

- (IBAction)tapHeaderLbl:(id)sender {
    UIView *sv = ((UITapGestureRecognizer *)sender).view;
    WsjTableView *tv = [self.tablesContainer viewWithTag:(sv.tag - 19000 + kWsjTblVwStartTag)];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

@end
