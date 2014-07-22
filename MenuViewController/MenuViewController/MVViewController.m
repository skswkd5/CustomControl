//
//  MVViewController.m
//  MenuViewController
//
//  Created by Jeesun Kim on 2014. 6. 30..
//  Copyright (c) 2014년 ___FULLUSERNAME___. All rights reserved.
//

#import "MVViewController.h"

@interface MVViewController () <UIGestureRecognizerDelegate>
{
    CGRect _rectTableWiew;
    CGRect _rectWebView;
    
    CGFloat _xPosStart;
    CGFloat _xPosLastSample;
    CGFloat _xPosCurrent;
    CGFloat _xPosEnd;
    CGFloat _direction;
    
    BOOL isShowLeftMenu;
}

@property (nonatomic, retain) UIPanGestureRecognizer *panRecognizer;

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIWebView *web;

@property (nonatomic, strong) NSDictionary *dicData;
@end


static const NSString *http = @"http://";
static const NSString *homeURL = @"m.huffpost.com/kr";

@implementation MVViewController

static const NSInteger kDefaultLeftViewMargin = 50;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initializingControllers];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - local functions

- (void)initializingControllers
{
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"더보기" style:UIBarButtonItemStylePlain target:self action:@selector(pressedLeftButton)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(goHomeWeb)];
    
    self.navigationController.navigationBar.barTintColor = [UIColor lightGrayColor];
    
    [self.navigationItem.leftBarButtonItem setAction:@selector(pressedLeftButton)];
    [self.navigationItem.rightBarButtonItem setAction:@selector(goHomeWeb)];
    
    self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panRecognizer.delegate = self;
    self.panRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panRecognizer];
    
    _xPosStart = 0;
    _xPosLastSample = 0;
    _xPosCurrent = 0;
    _xPosEnd = 0;
    _direction = 0;
    
    isShowLeftMenu = NO;
    
    [self initWebView];
    [self initTableView];
    
}

- (void) initWebView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = rect.origin.y + rect.size.height;
    rect.size.height = screenRect.size.height - rect.origin.y;
    _rectWebView = rect;
    
    self.web = [[UIWebView alloc] initWithFrame:rect];
    [self.view addSubview:self.web];
    
    [self loadWebView:homeURL];
}

- (void) initTableView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect rect = self.navigationController.navigationBar.frame;
    rect.origin.y = rect.origin.y + rect.size.height;
    rect.size.height = screenRect.size.height - rect.origin.y;
    
    rect.origin.x = (self.web.frame.size.width - kDefaultLeftViewMargin) * -1;
    rect.size.width = self.web.frame.size.width - kDefaultLeftViewMargin;
    _rectTableWiew = rect;
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"PortalSite" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.dicData = [NSDictionary dictionaryWithDictionary:dic];
    
    self.tableView = [[UITableView alloc] initWithFrame:_rectTableWiew];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor darkGrayColor];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
}


- (void)loadWebView:(NSString *)url
{
    if ( [url length] == 0)
    {
        url = homeURL;
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", http, url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [self.web loadRequest:request];
}


#pragma mark - pan Gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    
    if(![otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]])
    {
        otherGestureRecognizer.enabled = YES;
    }
    
    return NO;
}


- (void)handlePanGesture:(UIPanGestureRecognizer *)panRecognizer
{
	 NSLog(@"%s", __FUNCTION__);
 
    CGPoint touchPointinView = [panRecognizer locationInView:self.view];
    
    switch (panRecognizer.state)
    {
        case UIGestureRecognizerStateBegan:
            
            NSLog(@"UIGestureRecognizerStateBegan");
            _xPosStart = touchPointinView.x;
            _xPosLastSample = touchPointinView.x;
            
            NSLog(@" _xPosStart : %.2f _xPosLastSample: %.2f", _xPosStart, _xPosLastSample);
            break;
            
        case UIGestureRecognizerStateChanged:
            
            NSLog(@"UIGestureRecognizerStateChanged");
            
            _xPosCurrent = touchPointinView.x;
            
            NSLog(@" xposeCurrent : %.2f xPoseLastSample: %.2f", _xPosCurrent, _xPosLastSample);
            
            if(_xPosCurrent > _xPosLastSample)
            {
                //오른쪽으로 이동
                _direction = 1;
            }
            else if(_xPosCurrent < _xPosLastSample)
            {
                _direction = -1;
            }
            
            NSLog(@"_xPosCurrent - _xPosLastSample: %.2f", _xPosCurrent - _xPosLastSample);
            
            if((_direction == 1 && isShowLeftMenu == NO) || (_direction == -1 && isShowLeftMenu == YES))
            {
                CGRect rectWeb = CGRectOffset(self.web.frame, _xPosCurrent - _xPosLastSample, 0);
                NSLog(@"rectWeb: %@", NSStringFromCGRect(rectWeb));
                
                CGRect rectTable = CGRectOffset(self.tableView.frame, _xPosCurrent - _xPosLastSample, 0);
                NSLog(@"rectTable: %@", NSStringFromCGRect(rectTable));

                self.web.frame = rectWeb;
                self.tableView.frame = rectTable;
                
                [self animatingViews:rectWeb rectForTable:rectTable];
                //프레임 이동시키기
            }
            
            _xPosLastSample = _xPosCurrent;
        
            break;
        case UIGestureRecognizerStateEnded:
            
            NSLog(@"UIGestureRecognizerStateEnded");
            
            _xPosCurrent = touchPointinView.x;
            
            if(_xPosCurrent > _xPosLastSample)
            {
                //오른쪽으로 이동
                _direction = 1;
                if(!isShowLeftMenu)
                    break;
            }
            else if(_xPosCurrent < _xPosLastSample)
            {
                _direction = -1;
            }
            
            CGPoint center = self.view.center;
            NSLog(@"center.x: %.2f self.web.frame.origin.x: %.2f",center.x, self.web.frame.origin.x);
            
            if(_direction == 1)
            {
                if(self.web.frame.origin.x > center.x)
                {
                    [self showLeftMenu];
                }
                else
                {
                    [self hideLeftMenu];
                }
            }
            else
            {
                if(self.web.frame.origin.x > center.x)
                {
                    [self showLeftMenu];
                }
                else
                {
                    [self hideLeftMenu];
                }
            }
            
            break;
            
        case UIGestureRecognizerStateCancelled:
            
            NSLog(@"UIGestureRecognizerStateCancelled");

            break;
            
        case UIGestureRecognizerStateFailed:
            
            NSLog(@"UIGestureRecognizerStateFailed");
            
            break;
        default:
            break;
    }
    
}


#pragma mark -buttonAction
- (void)goHomeWeb
{
    NSLog(@"%s", __FUNCTION__);
    [self loadWebView:@""];
    [self hideLeftMenu];
}

- (void)animatingViews:(CGRect) rectWeb rectForTable:(CGRect) rectTable
{
    [UIView animateWithDuration:1.0 animations:^ {
        
        self.web.frame= rectWeb;
        self.tableView.frame = rectTable;
    }];
}

- (void)pressedLeftButton
{
    NSLog(@" %s, self.tableView.frame: %@", __FUNCTION__, NSStringFromCGRect(self.tableView.frame));

    if(!isShowLeftMenu)
    {
        //왼쪽 메뉴를 보여준다.
        [self showLeftMenu];
    }
    else
    {
        //왼쪽 메뉴를 숨긴다.
        [self hideLeftMenu];
    }
}

- (void)showLeftMenu
{
    isShowLeftMenu = YES;
    
    CGRect rectWeb = self.web.frame;
    CGRect rectTable = self.tableView.frame;
    
    //왼쪽 메뉴를 보여준다.
    [self.navigationItem.leftBarButtonItem setTitle:@"숨기기"];
    rectWeb.origin.x = rectWeb.size.width - kDefaultLeftViewMargin;
    rectTable.origin.x = 0;
    NSLog(@" %s, rectWeb: %@ rectTable: %@", __FUNCTION__, NSStringFromCGRect(rectWeb), NSStringFromCGRect(rectTable));
    [self animatingViews:rectWeb rectForTable:rectTable];
    
}

- (void)hideLeftMenu
{
    isShowLeftMenu = NO;
    
    CGRect rectWeb = self.web.frame;
    CGRect rectTable = self.tableView.frame;
    
    //왼쪽 메뉴를 숨긴다.
    [self.navigationItem.leftBarButtonItem setTitle:@"더보기"];
    rectWeb = _rectWebView;
    rectTable = _rectTableWiew;
    
    NSLog(@" %s, rectWeb: %@ rectTable: %@", __FUNCTION__, NSStringFromCGRect(rectWeb), NSStringFromCGRect(rectTable));
    
    [self animatingViews:rectWeb rectForTable:rectTable];
}

#pragma mark - tableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = [self.dicData objectForKey:@"url"];
    NSString *str = arr[indexPath.row];
    
    [self loadWebView:str];
    [self pressedLeftButton];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dicData objectForKey:@"url"] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    NSArray *arr = [self.dicData objectForKey:@"SiteName"];
    NSInteger i = indexPath.row;
    NSString *str = arr[i];
    
    cell.textLabel.text = str;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

#pragma mark - Orientation
- (BOOL)shouldAutorotate
{
    NSLog(@"%s", __FUNCTION__);
    
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"%s", __FUNCTION__);
    
    return UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight ;
}




@end
