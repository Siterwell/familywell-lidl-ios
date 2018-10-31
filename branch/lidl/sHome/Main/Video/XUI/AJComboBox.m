#import "AJComboBox.h"
#import <QuartzCore/QuartzCore.h>

@implementation AJComboBox
@synthesize arrayData, delegate;
@synthesize dropDownHeight;
@synthesize labelText;
@synthesize enabled;

- (void)__show {
    viewControl.alpha = 0.0f;
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:viewControl];
	[UIView animateWithDuration:0.3f
					 animations:^{
						 viewControl.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)__hide {
	[UIView animateWithDuration:0.2f
					 animations:^{
						 viewControl.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [viewControl removeFromSuperview];
					 }];
}


- (id) initWithFrame:(CGRect)frame andDropDownHeight:(CGFloat)height
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button setTitle:@"--Select--" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [self addSubview:button];
        if (height < 40) {
             dropDownHeight = 40;
        }
        else
        {
            dropDownHeight = height;
        }
       
        viewControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [viewControl setBackgroundColor:RGBA(0, 0, 0, 0.1f)];
        [viewControl addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat x = self.frame.origin.x;
        _table = [[UITableView alloc] initWithFrame:CGRectMake(x, 130, frame.size.width, dropDownHeight) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _table.rowHeight = 44;
        CALayer *layer = _table.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 5.0f;
        layer.borderWidth = 1.5f;
//        [layer setBorderColor:StrokeAndSeparate.CGColor];
        [viewControl addSubview:_table];
    }
    return self;
}

- (void) setLabelText:(NSString *)_labelText
{
//    [labelText release];
//    labelText = [_labelText retain];
    [button setTitle:labelText forState:UIControlStateNormal];
}

- (void) setEnable:(BOOL)_enabled
{
    enabled = _enabled;
    [button setEnabled:_enabled];
}

- (void) setArrayData:(NSArray *)_arrayData
{
//    [arrayData release];
//    arrayData = [_arrayData retain];
    [_table reloadData];
}

//- (void) dealloc
//{
//
//    [viewControl release];
//    [_table release];
//    [arrayData release];
//    [labelText release];
//    [super dealloc];
//}

- (void) buttonPressed
{
    [self __show];
}

- (void) controlPressed
{
    //[viewControl removeFromSuperview];
    [self __hide];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 35;
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [arrayData count];
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
	cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
	return cell;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = [indexPath row];
    //[viewControl removeFromSuperview];
    [self __hide];
    [button setTitle:[self.arrayData objectAtIndex:[indexPath row]] forState:UIControlStateNormal];
    [delegate didChangeComboBoxValue:self selectedIndex:[indexPath row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0;
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return @"";
}	

- (NSInteger) selectedIndex
{
    return selectedIndex;
}

#pragma mark -
#pragma mark AJComboBoxDelegate

-(void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
	
}	


@end
