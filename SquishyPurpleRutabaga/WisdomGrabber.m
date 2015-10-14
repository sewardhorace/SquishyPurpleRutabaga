//
//  WisdomGrabber.m
//  SquishyPurpleRutabaga
//
//  Created by Max White on 10/13/15.
//  Copyright © 2015 Max White. All rights reserved.
//

#import "WisdomGrabber.h"
#import <AFNetworking/AFNetworking.h>
#import "TFHpple.h"

@interface WisdomGrabber ()

@end

@implementation WisdomGrabber

-(NSArray *)getQuotesFromText:(NSString *)text{
    
    NSString *queryString = [text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSString *urlRootString = @"http://www.brainyquote.com/search_results.json?q=";
    NSString *urlString = [NSString stringWithFormat:@"%@%@", urlRootString, queryString];
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    TFHpple *parser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *nodes = [parser searchWithXPathQuery:@"//span[@class='bqQuoteLink']/a"];
    
    NSMutableArray *quoteArray = [[NSMutableArray alloc]initWithCapacity:0];
    for (TFHppleElement *element in nodes) {
        [quoteArray addObject:[[element firstChild]content]];
    }
    
    return quoteArray;
}

@end
