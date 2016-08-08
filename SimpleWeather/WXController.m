//
//  WXController.m
//  SimpleWeather
//
//  Created by Derek Doherty on 21/12/2015.
//  Copyright © 2015 Derek Doherty. All rights reserved.
//

#import "WXController.h"
#import <LBBlurredImage/UIImageView+LBBlurredImage.h>

#import "WXManager.h"

@interface WXController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;

@property (nonatomic, strong) WXCondition * currentCondition;
@property (nonatomic, strong) NSArray *hourlyForecast;
@property (nonatomic, strong) NSArray *dailyForecast;


@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *temperatureLabel;
@property (nonatomic, strong) UILabel *hiloLabel;
@property (nonatomic, strong) UILabel *cityLabel;
@property (nonatomic, strong) UILabel *conditionsLabel;
@property (nonatomic, strong) UIImageView *iconView;

@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;

@end

@implementation WXController

//
// Only called once !!
//
- (id)init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
        
        //
        // Add a KVO to client for property currentCondition
        //
        [[WXManager sharedManager] addObserver:self forKeyPath:@"currentCondition" options:NSKeyValueObservingOptionNew context:NULL];
        [[WXManager sharedManager] addObserver:self forKeyPath:@"hourlyForecast" options:NSKeyValueObservingOptionNew context:NULL];
        [[WXManager sharedManager] addObserver:self forKeyPath:@"dailyForecast" options:NSKeyValueObservingOptionNew context:NULL];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    //self.view.backgroundColor = [UIColor redColor];
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    UIImage * background = [UIImage imageNamed:@"bg"];
    
    self.backgroundImageView = [[UIImageView alloc ] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    //
    // Set up the Table View Programatically
    //
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor]; // Makes it Transparent !!
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorColor= [UIColor colorWithWhite:1 alpha:0.2];
    
    
    //
    //
    //
    self.tableView.pagingEnabled = YES; //causes scrolling on a page by page basis
    
    [self.view addSubview:self.tableView]; // Third view on top of hierarchy
    
    //
    // Add Layout
    //
    //
    // The header of the table view is set up as a full screen
    //
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;
    
    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - hiloHeight,
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight),
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight);
    
    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    self.header = [[UIView alloc] initWithFrame:headerFrame];
    self.header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = self.header;
    
    // 2
    // bottom left
    self.temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    self.temperatureLabel.backgroundColor = [UIColor clearColor];
    self.temperatureLabel.textColor = [UIColor whiteColor];
    self.temperatureLabel.text = @"0°";
    self.temperatureLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:120];
    [self.header addSubview:self.temperatureLabel];
    
    // bottom left
    self.hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    self.hiloLabel.backgroundColor = [UIColor clearColor];
    self.hiloLabel.textColor = [UIColor whiteColor];
    self.hiloLabel.text = @"0° / 0°";
    self.hiloLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:28];
    [self.header addSubview:self.hiloLabel];
    
    // top
    self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 30)];
    self.cityLabel.backgroundColor = [UIColor clearColor];
    self.cityLabel.textColor = [UIColor whiteColor];
    self.cityLabel.text = @"Loading...";
    self.cityLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.cityLabel.textAlignment = NSTextAlignmentCenter;
    [self.header addSubview:self.cityLabel];
    
    self.conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    self.conditionsLabel.backgroundColor = [UIColor clearColor];
    self.conditionsLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    self.conditionsLabel.textColor = [UIColor whiteColor];
    [self.header addSubview:self.conditionsLabel];
    
    // 3
    // bottom left
    self.iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    self.iconView.contentMode = UIViewContentModeScaleAspectFit;
    self.iconView.backgroundColor = [UIColor clearColor];
    [self.header addSubview:self.iconView];
    
    //
    // This kicks everything off
    //
    [[WXManager sharedManager] findCurrentLocation];
    

    
}



#pragma - mark KVO on WXCLient property currentCondition, hourlyForecast, dailyForecast

//
//
//
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    //
    // OKAY, here we get the change from the client which means currentCondition has been updated
    //
    if ([keyPath isEqualToString:@"currentCondition"])
    {
        //NSLog(@"CurrentCondition in the client has been Updated with change = >%@<", change);
        NSLog(@"CurrentCondition in the client has been Updated inthe ViewCOntroller");
        self.currentCondition = (WXCondition *)(change[@"new"]);
        
        // Cpuld to it this way either instead of having local properties as WXManager is a singleton
        //self.currentCondition = [WXManager sharedManager].currentCondition;
        
        //self.currentCondition.tempLow.floatValue;
        
        //
        // Update the UI NOW!! Need to be on the main Q
        //((Weather *)(self.weather[0]))
        
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           self.temperatureLabel.text = [NSString stringWithFormat:@"%.0f°", self.currentCondition.temperature.floatValue];
                           self.conditionsLabel.text = [((Weather *)self.currentCondition.weather[0]).weather_description capitalizedString];
                           self.cityLabel.text = [self.currentCondition.locationName capitalizedString];
                           self.iconView.image = [UIImage imageNamed:[self.currentCondition imageName]];
                           
                           self.hiloLabel.text = [NSString  stringWithFormat:@"%.0f° / %.0f°",self.currentCondition.tempHigh.floatValue,self.currentCondition.tempLow.floatValue];
                       });
        

    }
    else if ([keyPath isEqualToString:@"hourlyForecast"])
    {
        self.hourlyForecast = (NSArray *)(change[@"new"]);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.tableView reloadData];
                       });
        
    }
    else if ([keyPath isEqualToString:@"dailyForecast"])
    {
        self.dailyForecast =(NSArray *)(change[@"new"]);
        dispatch_async(dispatch_get_main_queue(),
                       ^{
                           [self.tableView reloadData];
                       });
    }
    
}



//
// Unsubscribe KVO
//
-(void)dealloc
{
    [[WXManager sharedManager]  removeObserver:self forKeyPath:@"currentCondition"];
}




- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//
// Need this as there is no AutoLayout
//
-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}



// 1
#pragma mark - UITableViewDataSource

// 2
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 1
    if (section == 0) {
        return MIN([[WXManager sharedManager].hourlyForecast count], 6) + 1;
    }
    // 2
    return MIN([[WXManager sharedManager].dailyForecast count], 6) + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // 3
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    
    if (indexPath.section == 0)
    {
        // 1
        if (indexPath.row == 0)
        {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        }
        else {
            // 2
            WXCondition *weather = [WXManager sharedManager].hourlyForecast[indexPath.row - 1];
            [self configureHourlyCell:cell weather:weather];
        }
    }
    else if (indexPath.section == 1)
    {
        // 1
        if (indexPath.row == 0)
        {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        }
        else
        {
            // 3
            WXCondition *weather = [WXManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell:cell weather:weather];
        }
    }
    return cell;
}


// 1
- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

// 2
- (void)configureHourlyCell:(UITableViewCell *)cell weather:(WXCondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

// 3
- (void)configureDailyCell:(UITableViewCell *)cell weather:(WXCondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",
                                 weather.tempHigh.floatValue,
                                 weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}






#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSInteger section = indexPath.section;
//    NSInteger row = indexPath.row;
    
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    CGFloat screenHeight =  self.screenHeight / (CGFloat)cellCount;
    
    return screenHeight;
    //return 40;
}

#pragma mark - UIScrollViewDelegate

//
// Converting scroll position to amout of Blur of Background image
//
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 1
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    // 2
    CGFloat percent = MIN(position / height, 1.0);
    // 3
    self.blurredImageView.alpha = percent;
}


@end
