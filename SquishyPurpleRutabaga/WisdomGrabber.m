//
//  WisdomGrabber.m
//  SquishyPurpleRutabaga
//
//  Created by Max White on 10/13/15.
//  Copyright © 2015 Max White. All rights reserved.
//

#import "WisdomGrabber.h"
#import "TFHpple.h"
#import <Foundation/Foundation.h>

@interface WisdomGrabber ()

@property (nonatomic) NSString *queryBody;

@end

@implementation WisdomGrabber

-(NSMutableArray *)getSubjectMatterFromText:(NSString *)text{
    
    NSRange stringRange = NSMakeRange(0, text.length);
    
    NSArray *language = [NSArray arrayWithObjects:@"en",@"de",@"fr",nil];
    NSDictionary* languageMap = [NSDictionary dictionaryWithObject:language forKey:@"Latn"];
    
    NSMutableArray *subjectMatterArray = [[NSMutableArray alloc]initWithCapacity:0];
    
    [text enumerateLinguisticTagsInRange:stringRange scheme:NSLinguisticTagSchemeLexicalClass options:0 orthography:[NSOrthography orthographyWithDominantScript:@"Latn" languageMap:languageMap] usingBlock:^(NSString * _Nonnull tag, NSRange tokenRange, NSRange sentenceRange, BOOL * _Nonnull stop) {
        
        if ([tag isEqualToString:@"Noun"] || [tag isEqualToString:@"Verb"] || [tag isEqualToString:@"Adjective"] || [tag isEqualToString:@"Pronoun"] || [tag isEqualToString:@"PlaceName"] || [tag isEqualToString:@"PersonalName"]) {
            [subjectMatterArray addObject:[text substringWithRange:tokenRange]];
        }
    }];
    
    if (subjectMatterArray.count > 0) {
        return subjectMatterArray;
    } else {
        NSString *trimmedText = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *originalTextAsArray = [trimmedText componentsSeparatedByString:@" "];
        NSMutableArray *mutie = [NSMutableArray arrayWithArray:originalTextAsArray];
        return mutie;
    }
}

-(NSString *)getSubjectFromSubjectMatterArray:(NSMutableArray *)subjectMatterArray{
    
    NSString *queryBody = [[NSString alloc] init];
    if ([subjectMatterArray count] > 1) {
        
        NSInteger loopCount = [subjectMatterArray count]-2;
        for (int i = 0; i < loopCount; i++){
            NSUInteger randomIndex = arc4random() % [subjectMatterArray count];
            [subjectMatterArray removeObjectAtIndex:randomIndex];
        }
        queryBody = [subjectMatterArray componentsJoinedByString:@" "];
    } else {
        queryBody = [subjectMatterArray objectAtIndex:0];
    }
    
    return queryBody;
}

-(NSString *)createQueryStringFromSubjectMatter:(NSString *)subjectMatter{
    NSArray *queryPrefixes = @[@"I think ",
                               @"I feel ",
                               @"I hate ",
                               @"I love ",
                               @"I wish ",
                               @"I want ",
                               @"I know ",
                               @"I find ",
                               @"The best ",
                               @"The worst ",
                               @"I once ",
                               ];
    NSUInteger randomIndex = arc4random() % [queryPrefixes count];
    NSString *queryPrefix = [queryPrefixes objectAtIndex:randomIndex];
    
    NSString *query = [NSString stringWithFormat:@"%@%@",queryPrefix, subjectMatter];
    
    NSString *queryString = [query stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return queryString;
}


-(NSMutableArray *)fetchQuotesFromQuery:(NSString *)queryString{
    
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


-(NSArray *)getRandomQuoteStringsFromQuoteArray:(NSArray *)quotes{
//    shuffle the array first?
    NSString *giantString = [quotes componentsJoinedByString:@" "];
    NSArray *sentences = [giantString componentsSeparatedByString:@"."];
    
    return sentences;
}
-(NSString *)findRelevantQuoteFromArray:(NSArray *)quotes{
    NSArray *sentences = [self getRandomQuoteStringsFromQuoteArray:quotes];
    
    NSArray *subjectParts = [self.queryBody componentsSeparatedByString:@" "];
    
    for (NSString *subject in subjectParts){
        for (NSString *sentence in sentences){
            if ([sentence containsString:subject]){
                return [sentence stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];;
            }
        }
    }
    NSUInteger randomIndex = arc4random() % [sentences count];
    return [[sentences objectAtIndex:randomIndex] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}


-(NSString *)fetchWisdom:(NSString *)text{
    
    NSLog(@"recieved text");
    NSMutableArray *subjectMatterArray = [self getSubjectMatterFromText:text];
    
    self.queryBody = [[NSString alloc] init];
    
    self.queryBody = [self getSubjectFromSubjectMatterArray:subjectMatterArray];
    NSString *queryString = [self createQueryStringFromSubjectMatter:self.queryBody];
    NSLog(@"constructed query string :%@", queryString);
    
    NSMutableArray *quoteArray = [self fetchQuotesFromQuery:queryString];
    NSLog(@"fetched quotes");
    
    NSString *wisdom = [self findRelevantQuoteFromArray:quoteArray];
    NSLog(@"got wisdom: %@", wisdom);
    
    return wisdom;
}



@end
