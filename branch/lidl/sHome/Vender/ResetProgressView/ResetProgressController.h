//
//  ResetProgressController.h
//
//

#import <UIKit/UIKit.h>



@interface ResetProgressController : UIViewController
@property (strong, nonatomic) void (^finish)(BOOL);
@property (assign, nonatomic) float timer1;
@property (copy,nonatomic) NSString *hintMessage;
@property (assign,nonatomic) BOOL success;
@property (nonatomic,copy) NSString *hintTitle;
@end

