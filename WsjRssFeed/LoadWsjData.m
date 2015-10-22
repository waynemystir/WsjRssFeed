//
//  LoadWsjData.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "LoadWsjData.h"
#import "ParseWsjDocOperation.h"

NSString * const kBaseUrl = @"http://www.wsj.com/xml/rss";
NSString * const kWorldNews = @"3_7085.xml";
NSString * const kOpinion = @"3_7041.xml";
NSString * const kBusiness = @"3_7014.xml";
NSString * const kMarkets = @"3_7031.xml";
NSString * const kTech = @"3_7455.xml";
NSString * const kLife = @"3_7201.xml";

NSURL * urlRssFeed(NSString *feed) {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", kBaseUrl, feed]];
}

@implementation LoadWsjData

+ (LoadWsjData *)manager {
    static LoadWsjData *_lwd = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _lwd = [LoadWsjData new];
    });
    
    return _lwd;
}

+ (NSOperationQueue *)parseOperationQueue {
    static NSOperationQueue *_oq = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _oq = [NSOperationQueue new];
    });
    return _oq;
}

+ (void)loadWorldNews {
    [self dataTaskWithURL:urlRssFeed(kWorldNews) completionSelector:@selector(loadedWorldNews:)];
}

+ (void)loadOpinion {
    [self dataTaskWithURL:urlRssFeed(kOpinion) completionSelector:@selector(loadedOpinion:)];
}

+ (void)loadBusiness {
    [self dataTaskWithURL:urlRssFeed(kBusiness) completionSelector:@selector(loadedBusiness:)];
}

+ (void)loadMarkets {
    [self dataTaskWithURL:urlRssFeed(kMarkets) completionSelector:@selector(loadedMarkets:)];
}

+ (void)loadTech {
    [self dataTaskWithURL:urlRssFeed(kTech) completionSelector:@selector(loadedTech:)];
}

+ (void)loadLife {
    [self dataTaskWithURL:urlRssFeed(kLife) completionSelector:@selector(loadedLife:)];
}

+ (void)dataTaskWithURL:(NSURL *)url completionSelector:(SEL)selector {
    __weak LoadWsjData *lwd = [self manager];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        ParseWsjDocOperation *op = [[ParseWsjDocOperation alloc] initWithData:data];
        __weak ParseWsjDocOperation *wop = op;
        
        op.completionBlock = ^{
            
            if (lwd.wsjDelegate && [lwd.wsjDelegate respondsToSelector:selector])
                [lwd.wsjDelegate performSelectorOnMainThread:selector withObject:wop.wsjItems waitUntilDone:NO];
            
        };
        
        [[self parseOperationQueue] addOperation:op];
        
    }] resume];
}

@end
