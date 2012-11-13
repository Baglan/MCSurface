//
//  MyViewController.m
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "MyViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)setGreeting:(NSString *)greeting
{
    _greeting = greeting;
    _label.text = @"";
    
}

- (IBAction)hello:(id)sender
{
    _label.text = _greeting;
}

@end
