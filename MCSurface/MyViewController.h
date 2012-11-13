//
//  MyViewController.h
//  MCSurface
//
//  Created by Baglan on 11/14/12.
//
//

#import <UIKit/UIKit.h>

@interface MyViewController : UIViewController {
    __weak IBOutlet UILabel *_label;
}

@property (nonatomic, copy) NSString * greeting;

- (IBAction)hello:(id)sender;

@end
