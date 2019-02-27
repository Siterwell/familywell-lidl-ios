//
//  JhDownProgressController.h
//  JhDownProgressView
//
//

#import <UIKit/UIKit.h>



@interface JhDownProgressController : UIViewController
@property (strong, nonatomic) void (^finish)(BOOL);
@property (strong, nonatomic) void (^getApi)();
@property (assign, nonatomic) float timer1;
@property (assign, nonatomic) float timerApi;
@property (copy,nonatomic) NSString *hintMessage;
@property (assign,nonatomic) BOOL success;
@end

