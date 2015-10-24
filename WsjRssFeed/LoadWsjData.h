//
//  LoadWsjData.h
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LOAD_DATA_TYPE) {
    WORLD = 0,
    OPINION = 1,
    BUSINESS = 2,
    MARKETS = 3,
    TECH = 4,
    LIFE = 5
};

extern NSString * dataTypeName(LOAD_DATA_TYPE ldt);

@protocol LoadWsjDataDelegate <NSObject>

@required

- (void)loadedData:(LOAD_DATA_TYPE)dataType wsjItems:(NSArray *)wsjItems;
- (void)requestTimedOut:(LOAD_DATA_TYPE)dataType;
- (void)requestFailedOffline:(LOAD_DATA_TYPE)dataType;
- (void)requestFailed:(LOAD_DATA_TYPE)dataType;

@end

@interface LoadWsjData : NSObject

@property (nonatomic, weak) NSObject<LoadWsjDataDelegate> *wsjDelegate;

+ (LoadWsjData *)manager;
+ (void)loadWorldNews;
+ (void)loadOpinion;
+ (void)loadBusiness;
+ (void)loadMarkets;
+ (void)loadTech;
+ (void)loadLife;

@end
