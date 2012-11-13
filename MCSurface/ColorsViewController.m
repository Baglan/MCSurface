//
//  ColorsViewController.m
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import "ColorsViewController.h"

@interface ColorsViewController ()

@end

@implementation ColorsViewController

- (void)setColor:(UIColor *)color
{
    self.view.backgroundColor = [UIColor clearColor];
    _color = color;
}

- (IBAction)color:(id)sender
{
    self.view.backgroundColor = _color;
}

@end
