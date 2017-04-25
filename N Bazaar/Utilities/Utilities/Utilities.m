//
//  Utilities.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "Utilities.h"
#import "MBProgressHUD.h"
#import "Constant.h"
#import "LoginVc.h"
#import <DigitsKit/DigitsKit.h>


static MBProgressHUD *HUD = nil;


@implementation Utilities


#pragma MBProgressHUD Loader Handerler
+(void) showLoadingWithText:(NSString *)string
{
    [self hideLoading];
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    
    HUD = [[MBProgressHUD alloc] initWithView:mainWindow];
    [mainWindow addSubview:HUD];
    
    HUD.labelText = string;
    [HUD show:YES];
    
}

+(void) hideLoading
{
    [HUD hide:YES];
    [HUD removeFromSuperview];
}

+(void) showInfo:(NSString*)errorInfo
{
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    if([errorInfo length] <25)
    {
        //hud.labelFont = [self getfontNameandSizeRegular:14];
        hud.labelText = errorInfo;
    }
    else{
        //  hud.detailsLabelFont = [self getfontNameandSizeRegular:15];
        hud.detailsLabelText = errorInfo;
    }
    
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:1.5];
    
}


#pragma mark AlerView

+(void)showalertwithMessage:(NSString *)objmessage{
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@""
                          message:objmessage
                          delegate: nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil];
    [alert show];
}


#pragma mark NavigateController 

+(void)displayMenuViewSelectedControllers:(id)controller index:(NSInteger)index{
    
    UIViewController *objViewController=(UIViewController *)controller;
    UIStoryboard *objStoryboard;
    
    if (IS_IPAD) {
        objStoryboard=[UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    }
    else{
        objStoryboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }
    
    if (index == 0){
       // LoginVc *objHomeVc = [objStoryboard instantiateViewControllerWithIdentifier:@"LoginVcID"];
       // [objViewController.navigationController pushViewController:objHomeVc animated:YES];
        NSString *objLoggeduser = [[NSUserDefaults standardUserDefaults]valueForKey:@"LoggedUser"];
        if (objLoggeduser) {
            Digits *digits = [Digits sharedInstance];
            [digits logOut];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Logged Out successfully"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            [[NSUserDefaults standardUserDefaults]setValue:nil forKey:@"LoggedUser"];
        }
        else{
        Digits *digits = [Digits sharedInstance];
        DGTAuthenticationConfiguration *configuration = [[DGTAuthenticationConfiguration alloc] initWithAccountFields:DGTAccountFieldsDefaultOptionMask];
        
        DGTAppearance *appearance = [[DGTAppearance alloc] init];
        appearance.backgroundColor = [UIColor colorWithRed:0/255.0 green:80.0/255.0 blue:120.0/255.0 alpha:1.0];
        appearance.accentColor = [UIColor whiteColor];
        configuration.appearance = appearance;
        
        configuration.phoneNumber = @"+91";
        [digits authenticateWithViewController:nil configuration:configuration completion:^(DGTSession *newSession, NSError *error){
            
            if (newSession.userID) {
                
                [[NSUserDefaults standardUserDefaults]setValue:newSession.userID forKey:@"LoggedUser"];
                // TODO: associate the session userID with your user model
                NSString *authToken = [NSString stringWithFormat:@"AuthToken: %@", newSession.authToken];
                NSString *authTokenSecret = [NSString stringWithFormat:@"AuthTokenSecret: %@", newSession.authTokenSecret];
                NSString *UserID = [NSString stringWithFormat:@"UserID: %@", newSession.userID];
                NSString *Mobile = [NSString stringWithFormat:@"Phone number: %@", newSession.phoneNumber];
                
                NSString *msg = [NSString stringWithFormat:@"%@ \n%@ \n%@ \n%@",authToken,authTokenSecret,UserID,Mobile];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"User details"
                                                                message:msg
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            } else if (error) {
                NSLog(@"Authentication error: %@", error.localizedDescription);
            }
        }];
      }
    }
}





#pragma mark imageLoader

+(void)setThumbNailImage:(AsyncImageView *)objImageView imageUrlString:(NSString *)objImageURL thumbImage:(BOOL)thumbImage
{
    if(thumbImage)
    {
        objImageView.image=[UIImage imageNamed:@"defaultmenuicon.png"];
    }else
    {
        objImageView.image=[UIImage imageNamed:@"sliderloading.png"];
        
    }
    
    if (![objImageURL isKindOfClass:[NSNull class]])
    {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0],objImageURL];
        [[AsyncImageLoader sharedLoader] cancelLoadingImagesForTarget:objImageView];
        if([objImageURL isEqualToString:@""])
        {
            if(thumbImage)
            {
                objImageView.image=[UIImage imageNamed:@"defaultmenuicon.png"];
                
            }else
            {
                objImageView.image=[UIImage imageNamed:@"sliderloading.png"];
            }
            
        }else
        {
            if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
                
                objImageView.imageURL =[NSURL URLWithString:objImageURL];
                [self imageConvertToData:[NSURL URLWithString:objImageURL] PathString:filePath];
                
            }else
            {
                
                NSData *imagecontentData=[NSData dataWithContentsOfFile:filePath];
                objImageView.image=[UIImage imageWithData:imagecontentData];
            }
        }
    }
    
}

+(void)imageConvertToData:(NSURL *)imgUrl PathString:(NSString *)filepath
{
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc]initWithURL:imgUrl];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue  completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if([data length] > 0 && [[NSString stringWithFormat:@"%@",error] isEqualToString:@"(null)"])
         {
             //make your image here from data.
             [self getImageData:data PathString:filepath];
         }
     }];
}

+(void) getImageData:(NSData *)imageData PathString:(NSString *)filePath
{
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:imageData attributes:nil];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"Exists!");
        
    }
    
}




@end
