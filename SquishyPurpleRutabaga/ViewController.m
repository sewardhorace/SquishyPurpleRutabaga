//
//  ViewController.m
//  SquishyPurpleRutabaga
//
//  Created by Max White on 10/13/15.
//  Copyright © 2015 Max White. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController () <AVAudioPlayerDelegate>

@property (nonatomic) AVAudioPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlString = @"https://api.voicerss.org/?key=177845dca5d24d6bbc34217efa9ba160&hl=en-au&f=44khz_16bit_mono&src=hey+dude+whats+up&";
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSError *error1;
    NSData *audioData = [[NSData alloc] initWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error1];
    
    NSError *error2;
    self.player = [[AVAudioPlayer alloc] initWithData:audioData error:&error2];
    [self.player prepareToPlay];
    [self.player play];
}

@end
