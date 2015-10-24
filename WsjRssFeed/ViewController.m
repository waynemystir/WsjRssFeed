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
@property (weak, nonatomic) IBOutlet UILabel *worldL;
@property (weak, nonatomic) IBOutlet UILabel *opinesL;
@property (weak, nonatomic) IBOutlet UILabel *BizL;
@property (weak, nonatomic) IBOutlet UILabel *marketsL;
@property (weak, nonatomic) IBOutlet UILabel *techL;
@property (weak, nonatomic) IBOutlet UILabel *lifeL;

#pragma mark Various

@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, strong) UIColor *headerLblBgClr;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tblcContainerCenterXConstr;

@end

@implementation ViewController

#pragma mark Lifecycle

- (id)init {
    if (self = [super initWithNibName:@"View" bundle:nil]) {
        [LoadWsjData manager].wsjDelegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Wall Street Journal"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *tvs = [@[] mutableCopy];
    for (int j = 0; j < 6; j++) {
        WsjTableView *tv = [WsjTableView tableViewFactory:j];
        [self.tablesContainer addSubview:tv];
        [tvs addObject:tv];
    }
    
    self.tableViews = [tvs copy];
    
    CGRect s = [[UIScreen mainScreen] bounds];
    CGFloat sw = s.size.width;
    CGFloat sha = s.size.height - 108;
    
    [self.scroller removeConstraint:self.tblcContainerCenterXConstr];
    self.tablesContainer.translatesAutoresizingMaskIntoConstraints = YES;
    self.tablesContainer.frame = CGRectMake(0, 0, sw * 6, sha);
    self.scroller.contentSize = CGSizeMake(sw * 6, sha);
    
    self.scroller.delegate = self;
    
    self.worldL.backgroundColor = self.headerLblBgClr;
    
    [LoadWsjData loadWorldNews];
    [LoadWsjData loadOpinion];
    [LoadWsjData loadBusiness];
    [LoadWsjData loadMarkets];
    [LoadWsjData loadTech];
    [LoadWsjData loadLife];
}

#pragma mark Properties

- (NSArray *)tableViews {
    return _tableViews ? : (_tableViews = @[]);
}

- (UIColor *)headerLblBgClr {
    return _headerLblBgClr ? : (_headerLblBgClr = [UIColor colorWithRed:0.79f green:0.79f blue:0.79f alpha:1.0f]);
}

#pragma mark LoadWsjDataDelegate methods

- (void)loadedData:(LOAD_DATA_TYPE)dataType wsjItems:(NSArray *)wsjItems {
    WsjTableView *tv = self.tableViews[dataType];
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
    
    UILabel *nl = [[UILabel alloc] init];
    nl.numberOfLines = 0;
    nl.lineBreakMode = NSLineBreakByWordWrapping;
    nl.backgroundColor = [UIColor clearColor];
    nl.textColor = [UIColor blackColor];
    nl.textAlignment = NSTextAlignmentCenter;
    WsjTableView *tv = self.tableViews[dataType];
    nl.frame = tv.frame;
    nl.text = [NSString stringWithFormat:@"%@\n\nThe %@ could not be loaded.", message, dataTypeName(dataType)];
    
    [self.tablesContainer addSubview:nl];
}

#pragma mark Scroll View Delegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    float pageWidth = [[UIScreen mainScreen] bounds].size.width;
    float fractionalPage = scrollView.contentOffset.x / pageWidth;
    long currentPageNumber = 1 + lround(fractionalPage);
    
    UILabel *sl = nil;
    
    switch (currentPageNumber) {
        case 1:
            sl = self.worldL;
            break;
            
        case 2:
            sl = self.opinesL;
            break;
            
        case 3:
            sl = self.BizL;
            break;
            
        case 4:
            sl = self.marketsL;
            break;
            
        case 5:
            sl = self.techL;
            break;
            
        case 6:
            sl = self.lifeL;
            break;
            
        default:
            sl = self.worldL;
            break;
    }
    
    [self.headerScroller scrollRectToVisible:sl.frame animated:YES];
    [self restoreHeaderLabelBackGroundColor];
    sl.backgroundColor = [self headerLblBgClr];
}

- (void)restoreHeaderLabelBackGroundColor {
    self.worldL.backgroundColor = self.opinesL.backgroundColor = self.BizL.backgroundColor = self.marketsL.backgroundColor = self.techL.backgroundColor = self.lifeL.backgroundColor = [UIColor clearColor];
}

#pragma mark Tap Gestures

- (IBAction)tapWorld:(id)sender {
    WsjTableView *tv = self.tableViews[0];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

- (IBAction)tapOpinion:(id)sender {
    WsjTableView *tv = self.tableViews[1];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

- (IBAction)tapBusiness:(id)sender {
    WsjTableView *tv = self.tableViews[2];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

- (IBAction)tapMarkets:(id)sender {
    WsjTableView *tv = self.tableViews[3];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

- (IBAction)tapTech:(id)sender {
    WsjTableView *tv = self.tableViews[4];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

- (IBAction)tapLife:(id)sender {
    WsjTableView *tv = self.tableViews[5];
    [self.scroller scrollRectToVisible:tv.frame animated:YES];
}

@end
