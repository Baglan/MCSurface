//
//  ColorViewControllerKey.m
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "ColorViewControllerKey.h"
#import "ColorsViewController.h"

@implementation ColorViewControllerKey

- (UIViewController *)createController
{
    return [[ColorsViewController alloc] initWithNibName:@"ColorsViewController" bundle:[NSBundle mainBundle]];
}

- (void)updateController:(id)controller
{
    ColorsViewController * c = controller;
    
    NSArray * colors = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor]];
    
    c.color = colors[rand() % colors.count];
}

@end
