//
//  ServeIntroVC.m
//  sHome
//
//  Created by TracyHenry on 2018/9/5.
//  Copyright © 2018年 shaop. All rights reserved.
//

#import "ServeIntroVC.h"

@interface ServeIntroVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint * instructConstraint;
@end

@implementation ServeIntroVC

    
-(void)viewDidLoad{
     [super viewDidLoad];

    
    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
    NSString *languageName = [appLanguages objectAtIndex:0];
    
    if ([languageName containsString:@"en"]) {
    _instructConstraint.constant = 3200;
    }  else if ([languageName containsString:@"de"]) {
    _instructConstraint.constant = 4200;
    } else{
        _instructConstraint.constant = Main_Screen_Height;
    }
}
    
@end
