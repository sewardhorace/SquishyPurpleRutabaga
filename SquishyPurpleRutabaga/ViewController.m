//
//  ViewController.m
//  SquishyPurpleRutabaga
//
//  Created by Max White on 10/13/15.
//  Copyright © 2015 Max White. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "WisdomGrabber.h"

@interface ViewController ()
<
AVAudioPlayerDelegate,
UITextFieldDelegate
>

@property (nonatomic) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.textField.delegate = self;
}

- (NSString*)prepareStringForURLQuery:(NSString*)string{
    NSString *queryString = [string stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    return queryString;
}

-(void)speakWithText:(NSString *)text{
    NSLog(@"fetching audio data");
    NSString *urlRootString = @"https://api.voicerss.org/?key=177845dca5d24d6bbc34217efa9ba160&hl=en-us&f=44khz_16bit_mono&src=";
    
    NSString *queryString = [self prepareStringForURLQuery:text];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", urlRootString, queryString];
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSError *error1;
    NSData *audioData = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error1];
    NSError *error2;
    self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error2];
    NSLog(@"preparing to play audio");
    [self.player prepareToPlay];
    [self.player play];
    NSLog(@"audio should begin playing");
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    WisdomGrabber *grabber = [[WisdomGrabber alloc] init];
    
    NSString *wisdom = [grabber fetchWisdom:textField.text];
    
    [self speakWithText:wisdom];
    
    [textField resignFirstResponder];
    return TRUE;
}

@end
