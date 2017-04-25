//
//  HomeVc.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 29/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "HomeVc.h"
#import "Constant.h"
#import "QuartzCore/CALayer.h"
#import "MenuView.h"
#import <GooglePlaces/GooglePlaces.h>
#import "AppDelegate.h"
#import "Utilities.h"
#import <CoreLocation/CoreLocation.h>
#import "ChooseLocationType.h"
#import "ListView.h"
#import "ItemListVc.h"
#import "SearchController.h"


@interface HomeVc ()<MenuViewDelegete, GMSAutocompleteViewControllerDelegate,CLLocationManagerDelegate, UIGestureRecognizerDelegate, ChooseLocationDelegate,ListViewDelegate>{
    NSMutableArray *objimg;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    MenuView *objMenuview;
    ListView *objListView;
    NSTimer *myTimer;
    int LastIndex;
    NSArray *objCatagoryArray;
    UISearchBar *objsearchBar;
}

@property (nonatomic, weak)IBOutlet MarqueeLabel *objDeliveryaddress;
@property (nonatomic, weak)IBOutlet UIScrollView *objScrollView;
@property (nonatomic, weak)IBOutlet UIView *objSliderView;
@property (nonatomic, weak)IBOutlet UIView *objMenuBlurView;
@property (nonatomic, weak)IBOutlet UIScrollView *objContentScrollView;
@property (nonatomic, weak)IBOutlet UIScrollView *objCategoryScrollView;
@property (nonatomic, weak)IBOutlet NSLayoutConstraint *objCategoryScrollViewHeight;

@property (nonatomic, weak)IBOutlet UIButton *objSearchBtn;
@property (nonatomic, weak)IBOutlet UILabel *objYourLocationLbl;
@property (nonatomic, weak)IBOutlet UIImageView *objeditImg;
@property (nonatomic, weak)IBOutlet UIButton *objeditBtn;
@property (nonatomic, weak)IBOutlet UIView *objHeaderView;




@end




@implementation HomeVc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.objCategoryScrollView.scrollEnabled = NO;
    self.objDeliveryaddress.trailingBuffer = 20.0;
    NSString *objusrlat = [[NSUserDefaults standardUserDefaults]valueForKey:Current_Lat];
    if (objusrlat) {
        [Utilities showLoadingWithText:@"Loading..."];
        [self setUserLocation];
    }
    else{
        [Utilities showLoadingWithText:@"Getting your Location..."];
        [self getCurrentLocation];
    }
    [self autocompleteview];
    [self setImageSlider];
    [self setTapgestures];
    LastIndex=0;
    [self parseJsonFile];
    [self loadAnimate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    
    
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    if (scrollView == self.objContentScrollView) {
        if (scrollView.contentOffset.y > 190) {
            self.objContentScrollView.scrollEnabled = NO;
            self.objCategoryScrollView.scrollEnabled = YES;
        }
        else{
            self.objContentScrollView.scrollEnabled =YES ;
            self.objCategoryScrollView.scrollEnabled = NO;
        }
    }
    else if (scrollView == self.objCategoryScrollView){
        if (scrollView.contentOffset.y > 0) {
             self.objContentScrollView.scrollEnabled = NO;
             self.objCategoryScrollView.scrollEnabled = YES;
        }
        else{
            self.objContentScrollView.scrollEnabled =YES ;
            self.objCategoryScrollView.scrollEnabled = NO;
        }
    }
}

-(void)viewDidLayoutSubviews{
    
    self.objCategoryScrollViewHeight.constant = self.view.frame.size.height-70;
    
}

-(void)parseJsonFile{
    NSError *error;
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Catagory" ofType:@"json"];
    NSData *data = [[NSData alloc]initWithContentsOfFile:filePath];
    NSDictionary *jsonDic= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    objCatagoryArray = [jsonDic valueForKey:@"GetCatagoryArray"];
}

-(void)loadAnimate {
    CGFloat yPos = 2;
    for (int i=0; i<objCatagoryArray.count; i++) {
        objListView = [[ListView alloc]initWithFrame:CGRectMake(0, yPos, self.view.frame.size.width, 100)];
        yPos +=100+3;
        objListView.delegate=self;
        objListView.backgroundColor=[UIColor whiteColor];
        objListView.objCollectionViewHeight.constant=0.0;
        [objListView getValuesFromDic:[objCatagoryArray objectAtIndex:i]];
        objListView.tag=i+1;
        CATransition *transition = nil;
        transition = [CATransition animation];
        transition.duration = 1.0;//kAnimationDuration
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromRight;
        transition.delegate = self;
        [objListView.layer addAnimation:transition forKey:nil];
        [self.objCategoryScrollView addSubview:objListView];
        [self.objCategoryScrollView setContentSize:CGSizeMake(0,yPos)];
        
    }
}

-(void)getView:(id)sender{
    ListView *objView = (ListView *)sender;
    __block CGFloat yPos = 2;
    if (LastIndex==objView.tag) {
        for (ListView *objSubsView in self.objCategoryScrollView.subviews) {
            
            if (objSubsView.tag==objView.tag) {
                if ([objSubsView isKindOfClass:[objListView class]]) {
                    [UIView animateWithDuration:0.5 animations:^{
                        objSubsView.frame = CGRectMake(0, yPos, self.view.frame.size.width, 100);
                        objSubsView.objCollectionViewHeight.constant=0.0;
                        [objSubsView.objArrowOutlet setTransform:CGAffineTransformMakeRotation(0)];
                        objSubsView.backgroundColor=[UIColor whiteColor];
                        objSubsView.objtitle.textColor=[UIColor blackColor];
                        yPos+=100+3;
                        [objSubsView.objArrowOutlet setImage:[UIImage imageNamed:@"DownArrow.png"] forState:UIControlStateNormal];
                    }completion:^(BOOL finished) {
                    }];
                    
                    LastIndex=0;
                    [self.objCategoryScrollView setContentSize:CGSizeMake(0, yPos)];
                    
                }
                
            }
            else{
                
                if ([objSubsView isKindOfClass:[objListView class]]) {
                    [UIView animateWithDuration:0.5 animations:^{
                        
                        objSubsView.frame = CGRectMake(0, yPos, self.view.frame.size.width, 100);
                        objSubsView.objCollectionViewHeight.constant=0.0;
                        [objSubsView.objArrowOutlet setTransform:CGAffineTransformMakeRotation(0)];
                        objSubsView.backgroundColor=[UIColor whiteColor];
                        objSubsView.objtitle.textColor=[UIColor blackColor];
                        yPos+=100+3;
                        [objSubsView.objArrowOutlet setImage:[UIImage imageNamed:@"DownArrow.png"] forState:UIControlStateNormal];
                    }
                     
                                     completion:^(BOOL finished) {
                                         
                                     }];
                }
                LastIndex=0;
                [self.objCategoryScrollView setContentSize:CGSizeMake(0, yPos)];
            }
        }
        
    }
    else{
        for (ListView *objSubsView in self.objCategoryScrollView.subviews) {
            
            if ([objSubsView isKindOfClass:[objListView class]]) {
                
                if (objSubsView.tag==objView.tag) {
                    
                    objSubsView.collectionView.hidden=YES;
                    NSArray *objArray = [[objCatagoryArray objectAtIndex:objView.tag-1] valueForKey:@"ItemsArray"];
                    CGFloat count = objArray.count;
                    CGFloat rowValue = count/4;
                    NSInteger roundedValue = ceil(rowValue);
                    CGFloat approxheight = (self.view.frame.size.width - 16)/4;
                    CGFloat height = roundedValue*approxheight;
                    //[self.objCategoryScrollView setContentOffset:CGPointMake(0, yPos)];
                    [UIView animateWithDuration:0.5 animations:^{
                        
                      
                        objSubsView.frame = CGRectMake(0, yPos, self.view.frame.size.width, height+100+10);
                        objSubsView.objtitle.textColor=[UIColor whiteColor];
                        objSubsView.objCollectionViewHeight.constant=height;
                        [objSubsView.collectionView reloadData];
                        [objSubsView.objArrowOutlet setTransform:CGAffineTransformMakeRotation(M_PI )];
                        objSubsView.backgroundColor=[UIColor colorWithRed:0.0/255.0 green:80.0/255.0 blue:120.0/255.0 alpha:1.0f];
                        yPos += height+100+10;
                        LastIndex=objSubsView.tag;
                        
                        
;
                    }completion:^(BOOL finished) {
                        objSubsView.collectionView.hidden=NO;
                        [objSubsView.objArrowOutlet setImage:[UIImage imageNamed:@"DownWhite"] forState:UIControlStateNormal];
                        
                        
                        
                    }];
                }else{
                    
                    [UIView animateWithDuration:0.5 animations:^{
                        objSubsView.frame = CGRectMake(0, yPos, self.view.frame.size.width, 100);
                        objSubsView.objCollectionViewHeight.constant=0.0;
                        [objSubsView.objArrowOutlet setTransform:CGAffineTransformMakeRotation(0)];
                        objSubsView.backgroundColor=[UIColor whiteColor];
                        objSubsView.objtitle.textColor=[UIColor blackColor];
                        yPos+=100+3;
                        [objSubsView.objArrowOutlet setImage:[UIImage imageNamed:@"DownArrow.png"] forState:UIControlStateNormal];
                    }
                    completion:^(BOOL finished) {
                    }];
                }
            }
        }
        [self.objCategoryScrollView setContentSize:CGSizeMake(0, yPos)];
        
        int countView = 0;
        
        for (UIView *objsubviews in self.objCategoryScrollView.subviews) {
            
            if ([objsubviews isKindOfClass:[ListView class]]) {
                countView+=1;
            }
        }
        
        

        int Scolltop = countView/2;
        
        if(Scolltop+1 >= objView.tag){
            if (self.objContentScrollView.contentOffset.y > 189) {
                
                [self.objCategoryScrollView setContentOffset:CGPointZero animated:YES];
            }
            else{
                CGFloat yOffset = self.objContentScrollView.contentOffset.y;
                
                CGFloat height = self.objContentScrollView.frame.size.height;
                
                CGFloat contentHeight = self.objContentScrollView.contentSize.height;
                
                CGFloat distance = (contentHeight  - height) - yOffset;
                
                if(distance < 0)
                {
                    return ;
                }
                
                CGPoint offset = self.objContentScrollView.contentOffset;
                
                offset.y += distance;
                
                [self.objContentScrollView setContentOffset:offset animated:YES];
            }

        }
        else{
        if (self.objContentScrollView.contentOffset.y > 189) {

        CGFloat yOffset = self.objCategoryScrollView.contentOffset.y;
        
        CGFloat height = self.objCategoryScrollView.frame.size.height;
        
        CGFloat contentHeight = self.objCategoryScrollView.contentSize.height;
        
        CGFloat distance = (contentHeight  - height) - yOffset;
        
        if(distance < 0)
        {
            return ;
        }
        
        CGPoint offset = self.objCategoryScrollView.contentOffset;
        
        offset.y += distance;
        
            [self.objCategoryScrollView setContentOffset:offset animated:YES];
        }
        else{
            CGFloat yOffset = self.objContentScrollView.contentOffset.y;
            
            CGFloat height = self.objContentScrollView.frame.size.height;
            
            CGFloat contentHeight = self.objContentScrollView.contentSize.height;
            
            CGFloat distance = (contentHeight  - height) - yOffset;
            
            if(distance < 0)
            {
                return ;
            }
            
            CGPoint offset = self.objContentScrollView.contentOffset;
            
            offset.y += distance;
            
            [self.objContentScrollView setContentOffset:offset animated:YES];
        }
        }
    }
}

-(void)setTapgestures{
    
    UITapGestureRecognizer *objtap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didclickhideMenu)];
    
    [self.objMenuBlurView addGestureRecognizer:objtap];
    
}

-(void)didclickhideMenu{
    [UIView animateWithDuration:0.5 animations:^{
        self.objMenuBlurView.hidden = YES;
        objMenuview.frame=CGRectMake(0, 0,(IS_IPAD)?-450:(isiPhone6Plus_7Plus)?-300:-250,(IS_IPAD)?1024:(isiPhone6Plus_7Plus)?736:(isiPhone6_7)?667:(isiPhone5s)?568:480);
    } completion:^(BOOL finished) {
        [objMenuview removeFromSuperview];
    }];
}


-(IBAction)didclickMenuList:(UIButton *)sender{
    objMenuview = [[MenuView alloc]initWithFrame:CGRectMake((IS_IPAD)?-450:(isiPhone6Plus_7Plus)?-300:-250, 0,(IS_IPAD)?450:(isiPhone6Plus_7Plus)?300:250,(IS_IPAD)?1024:(isiPhone6Plus_7Plus)?736:(isiPhone6_7)?667:(isiPhone5s)?568:480)];
    objMenuview.delegate = self;
    [self.view addSubview:objMenuview];
    [UIView animateWithDuration:0.5 animations:^{
        self.objMenuBlurView.hidden = NO;
        objMenuview.frame=CGRectMake(0, 0,(IS_IPAD)?450:(isiPhone6Plus_7Plus)?300:250,(IS_IPAD)?1024:(isiPhone6Plus_7Plus)?736:(isiPhone6_7)?667:(isiPhone5s)?568:480);
    } completion:^(BOOL finished) {
    }];
}

#pragma mark MenuViewDelegate

-(void)getSelectedMenuDetails:(NSInteger)selectedValues{
    [Utilities displayMenuViewSelectedControllers:self index:selectedValues];
    self.objMenuBlurView.hidden = YES;
    
}


#pragma mark CurrentUserLocation

-(void)getCurrentLocation{
    
    [Utilities showLoadingWithText:@"Getting your Location..."];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self->locationManager requestWhenInUseAuthorization];
    
    [locationManager startUpdatingLocation];
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    [locations lastObject];
    
    currentLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    
    double userCurrentLat = currentLocation.coordinate.latitude;
    double userCurrentLong = currentLocation.coordinate.longitude;
    
    NSString *objLatstr = [NSString stringWithFormat:@"%f",userCurrentLat];
    NSString *objLongstr = [NSString stringWithFormat:@"%f",userCurrentLong];
    
    [[NSUserDefaults standardUserDefaults]setValue:objLatstr forKey:Current_Lat];
    [[NSUserDefaults standardUserDefaults]setValue:objLongstr forKey:Current_Long];
    
    [self setUserLocation];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"%@",error.description);
    [Utilities showInfo:error.description];
    [Utilities hideLoading];
}



-(void) setUserLocation {
    NSString *objusrlat = [[NSUserDefaults standardUserDefaults]valueForKey:Current_Lat];
    NSString *objusrlong = [[NSUserDefaults standardUserDefaults]valueForKey:Current_Long];
    
    if (![objusrlat isEqualToString:@""]) {
        NSString *strAddressFromLatLong = [self getAddressFromLatLon:objusrlat withLongitude:objusrlong];
        NSLog(@"%@",strAddressFromLatLong);
        self.objDeliveryaddress.text = strAddressFromLatLong;
    }
    else{
        NSLog(@"Location not found");
    }
    [Utilities hideLoading];
}

-(void)setImageSlider{
    
    
    objimg = [[NSMutableArray alloc]init];
    [objimg addObject:@"http://www.webfinver.com/wp-content/uploads/2016/10/shop-1.png"];
    [objimg addObject:@"http://demo.abantecart.com/storefront/view/default/image/banner_image_5.png"];
    [objimg addObject:@"http://d152j5tfobgaot.cloudfront.net/wp-content/uploads/2015/08/yourstory-research-online-retail-brand-feature.jpg"];
    [objimg addObject:@"http://d152j5tfobgaot.cloudfront.net/wp-content/uploads/2015/10/yourstory-delhi-online-shopping.jpg"];
    
    
    
    UIView *objImageContentview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width *[objimg count] , 190)];
    objImageContentview.backgroundColor = [UIColor clearColor];
    [self.objScrollView addSubview:objImageContentview];
    
    [self.objScrollView setContentSize:CGSizeMake(objImageContentview.frame.size.width , 190)];
    self.objScrollView.pagingEnabled = YES;
    int xPosition = 10;
    
    for (int i = 0; i < objimg.count ; i++) {
        
        UIView *container = [[UIView alloc]initWithFrame:CGRectMake(xPosition, 10, self.view.frame.size.width - 20, 170)];
        UIImageView *objimageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, container.frame.size.width, 170)];
        NSString *objimgurl = [objimg objectAtIndex:i];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:objimgurl]]];
        objimageview.image = image;
        objimageview.layer.cornerRadius = 5.0;
        objimageview.layer.masksToBounds = YES;
        objimageview.clipsToBounds = YES;
        
        container.layer.shadowColor = [UIColor blackColor].CGColor;
        container.layer.shadowOffset = CGSizeMake(0, 1);
        container.layer.shadowOpacity = 1;
        container.layer.shadowRadius = 5.0;
        
        [container addSubview:objimageview];
        [objImageContentview addSubview:container];
        xPosition += objimageview.frame.size.width + 20;
        
    }
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollingTimer) userInfo:nil repeats:YES];
}


- (void)scrollingTimer {
    
    CGFloat contentOffset = self.objScrollView.contentOffset.x;
    int nextPage = (int)(contentOffset/self.objScrollView.frame.size.width)+1;
    if( nextPage!=objimg.count)  {
        [self.objScrollView scrollRectToVisible:CGRectMake(nextPage*self.objScrollView.frame.size.width, 0, self.objScrollView.frame.size.width, self.objScrollView.frame.size.height) animated:YES];
    } else {
        [self.objScrollView scrollRectToVisible:CGRectMake(0, 0, self.objScrollView.frame.size.width, self.objScrollView.frame.size.height) animated:YES];
    }
    
}

-(NSString *)getAddressFromLatLon:(NSString *)pdblLatitude withLongitude:(NSString *)pdblLongitude
{
    NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=false",pdblLatitude, pdblLongitude];
    NSError* error;
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSASCIIStringEncoding error:&error];
    NSData *data = [locationString dataUsingEncoding:NSUTF8StringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSDictionary *dic = [[json objectForKey:@"results"] objectAtIndex:0];
    //    NSString *cityName = [[[dic objectForKey:@"address_components"] objectAtIndex:1] objectForKey:@"long_name"];
    NSString *objmyAddress = [dic objectForKey:@"formatted_address"];
    return objmyAddress;
}




#pragma mark Place search autocomplete

-(void)autocompleteview{
    // Define some colors.
    UIColor *apptheme = [UIColor colorWithRed:0.0 green:0.193 blue:0.350 alpha:1.0];
    
    [[UINavigationBar appearance] setBarTintColor:apptheme];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    
    
    NSDictionary *searchBarTextAttributes = @{
                                              NSForegroundColorAttributeName: [UIColor whiteColor],
                                              NSFontAttributeName : [UIFont systemFontOfSize:[UIFont systemFontSize]]
                                              };
    [UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]]
    .defaultTextAttributes = searchBarTextAttributes;
}

#pragma mark setNewlocation delegate
-(void)setMynewLocationonText : (NSString *)objLocation{
    self.objDeliveryaddress.text = objLocation;
}

- (IBAction)searchPlaces:(id)sender {
    ChooseLocationType * objChooseLocationType = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseLocationTypeID"];
    objChooseLocationType.delegate = self;
    [self presentViewController:objChooseLocationType animated:YES completion:nil];
}


- (void)viewController:(GMSAutocompleteViewController *)viewController
didAutocompleteWithPlace:(GMSPlace *)place {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.objDeliveryaddress.text = place.formattedAddress;
    // Do something with the selected place.
    NSLog(@"Place name %@", place.name);
    NSLog(@"Place address %@", place.formattedAddress);
    NSLog(@"Place attributions %@", place.attributions.string);
}

- (void)viewController:(GMSAutocompleteViewController *)viewController
didFailAutocompleteWithError:(NSError *)error {
    [self dismissViewControllerAnimated:YES completion:nil];
    // TODO: handle the error.
    NSLog(@"Error: %@", [error description]);
}

- (void)wasCancelled:(GMSAutocompleteViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRequestAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [Utilities showLoadingWithText:@"Getting location..."];
}

- (void)didUpdateAutocompletePredictions:(GMSAutocompleteViewController *)viewController {
    [Utilities hideLoading];
}


#pragma mark Collectioncell Delegate

-(void)didSelectatindex:(NSIndexPath *)objindex{
    ItemListVc *objvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ItemListVcID"];
    [self.navigationController pushViewController:objvc animated:YES];
}

-(IBAction)didClickSearch:(id)sender{
    
    SearchController *objvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchControllerID"];

    [self.navigationController pushViewController:objvc animated:YES];
    

}

@end
