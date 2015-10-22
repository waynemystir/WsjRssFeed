//
//  ParseWsjItemOperation.m
//  WsjRssFeed
//
//  Created by WAYNE SMALL on 10/21/15.
//  Copyright © 2015 WES. All rights reserved.
//

#import "ParseWsjDocOperation.h"
#import "WsjRssItem.h"

NSString * const kKeyItem = @"item";
NSString * const kKeyTitle = @"title";
NSString * const kKeyLink = @"link";
NSString * const kKeyItemDescriptioin = @"description";
NSString * const kKeyMediaContent = @"media:content";
NSString * const kKeyUrl = @"url";
NSString * const kKeyMedium = @"medium";

@interface ParseWsjDocOperation () <NSXMLParserDelegate>

@property (nonatomic, strong) NSData *dataToParse;
@property (nonatomic, strong) WsjRssItem *currentWsjItem;
@property (nonatomic, strong) NSMutableString *foundCharacters;
@property (nonatomic, strong) NSMutableArray *mutableWsjItems;

@end

@implementation ParseWsjDocOperation

- (id)initWithData:(NSData *)parseData {
    if (self = [super init]) {
        _dataToParse = parseData;
        _mutableWsjItems = [@[] mutableCopy];
        _foundCharacters = [[NSMutableString alloc] init];
    }
    return self;
}

- (void)main {
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.dataToParse];
    parser.delegate = self;
    [parser parse];
}

- (NSArray *)wsjItems {
    return [self.mutableWsjItems copy];
}

#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    
    if ([elementName isEqualToString:kKeyItem])
        self.currentWsjItem = [WsjRssItem new];
    else if ([elementName isEqualToString:kKeyMediaContent]) {
        
        NSString *urlAttribute = [attributeDict valueForKey:kKeyUrl];
        NSString *mediumAttribute = [attributeDict valueForKey:kKeyMedium];
        if ([mediumAttribute isEqualToString:@"image"])
            self.currentWsjItem.imageUrlString = urlAttribute;
        
    }
    
    [self.foundCharacters setString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [self.foundCharacters appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:kKeyItem]) {
        
        [self.mutableWsjItems addObject:self.currentWsjItem];
        
    } else if ([elementName isEqualToString:kKeyTitle]) {
        
        self.currentWsjItem.title = [self.foundCharacters copy];
        
    } else if ([elementName isEqualToString:kKeyLink]) {
        
        self.currentWsjItem.urlString = [self.foundCharacters copy];
        
    } else if ([elementName isEqualToString:kKeyItemDescriptioin]) {
        
        self.currentWsjItem.itemDescription = [self.foundCharacters copy];
        
    }
    
}

@end
