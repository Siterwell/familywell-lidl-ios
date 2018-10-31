#define RGB(a, b, c) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:1.0f]
#define RGBA(a, b, c, d) [UIColor colorWithRed:(a / 255.0f) green:(b / 255.0f) blue:(c / 255.0f) alpha:d]

#import <UIKit/UIKit.h>
@class AJComboBox;

@protocol AJComboBoxDelegate

@required

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex;

@end

@interface AJComboBox : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *button;
    UIControl *viewControl;
    UITableView *_table;
    NSInteger selectedIndex;
    id<AJComboBoxDelegate> delegate;
}
@property () CGFloat dropDownHeight;
@property (nonatomic, retain) NSArray *arrayData;
@property (nonatomic,retain) id<AJComboBoxDelegate> delegate;
@property (nonatomic, retain) NSString *labelText;
@property () BOOL enabled;
- (id) initWithFrame:(CGRect)frame andDropDownHeight:(CGFloat)height;
- (void) buttonPressed;
- (void) controlPressed;
- (NSInteger) selectedIndex;

@end
