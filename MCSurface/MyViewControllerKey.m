//
//  MyViewControllerKey.m
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "MyViewControllerKey.h"
#import "MyViewController.h"

@implementation MyViewControllerKey

- (UIViewController *)createController
{
    return [[MyViewController alloc] initWithNibName:@"MyViewController" bundle:[NSBundle mainBundle]];
}

- (void)updateController:(id)controller
{
    MyViewController * c = controller;
    
    NSArray * greetings = @[@"Hello", @"你好", @"Привет"];
    
    c.greeting = greetings[rand() % greetings.count];
}

@end
