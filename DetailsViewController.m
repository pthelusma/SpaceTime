//
//  DetailsViewController.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/19/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "DetailsViewController.h"
#import "Task+Cloud.h"
#import "FormatHelper.h"
#import "Context.h" 

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblCreateDate;
@property (weak, nonatomic) IBOutlet UILabel *lblUpdateDate;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UIDatePicker *dueDate;


@end

@implementation DetailsViewController

CLLocationManager *locationManager;
CLLocation *currentLocation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.txtTitle.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    [self updateUI];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_txtTitle resignFirstResponder];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if(textField)
    {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            [self updateUI];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setTask:(Task *) task
{
    _task = task;
    
    [self updateUI];
    
}

- (void) updateUI
{
    
    self.lblCreateDate.font = [UIFont systemFontOfSize:8.0];
    self.lblUpdateDate.font = [UIFont systemFontOfSize:8.0];
 
    if(self.task)
    {
        self.txtTitle.text = self.task.title;
        
        self.lblCreateDate.text = [NSString stringWithFormat:@"Created: %@", [FormatHelper formatDate:self.task.create_date]];
        self.lblUpdateDate.text = [NSString stringWithFormat:@"Updated: %@", [FormatHelper formatDate:self.task.update_date]];
    }
}

- (IBAction)done:(UIBarButtonItem *)sender {
    
    NSMutableDictionary *taskDictionary = [[NSMutableDictionary alloc] init];
    
    if(self.task)
    {
        self.task.title = self.txtTitle.text;
        self.task.update_date = [[NSDate alloc] init];
        self.task.due_date = self.dueDate.date;
        
        [taskDictionary setObject:self.task.title forKey:@"title"];
        [taskDictionary setObject:self.task.task_id  forKey:@"task_id"];
        [taskDictionary setObject:[FormatHelper localeDateToJsonDate:self.task.update_date] forKey:@"update_date"];
        [taskDictionary setObject:[FormatHelper localeDateToJsonDate:self.task.due_date] forKey:@"due_date"];
        [taskDictionary setObject:@1 forKey:@"active"];
        
    } else {
        [taskDictionary setObject:self.txtTitle.text forKey:@"title"];
        [taskDictionary setObject:@0 forKey:@"task_id"];
        [taskDictionary setObject:[FormatHelper localeDateToJsonDate:[[NSDate alloc] init]] forKey:@"update_date"];
        [taskDictionary setObject:[FormatHelper localeDateToJsonDate:[[NSDate alloc] init]] forKey:@"due_date"];
        [taskDictionary setObject:[FormatHelper localeDateToJsonDate:[[NSDate alloc] init]] forKey:@"create_date"];
        [taskDictionary setObject:[NSNumber numberWithDouble:currentLocation.coordinate.longitude] forKey:@"latitude"];
        [taskDictionary setObject:[NSNumber numberWithDouble:currentLocation.coordinate.latitude] forKey:@"longitude"];
        
        [self.context performBlock:^{
            self.task = [Task createTask:taskDictionary context:self.context];
        }];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:taskDictionary
                                                       options:kNilOptions
                                                         error:&error];
    
    NSString *url = @"http://pierrethelusma.com/Services/api/task/SetTask/";
    
    NSString *jsonLength = [NSString stringWithFormat:@"%d", [jsonData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:jsonLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    
    NSURLResponse *response;
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSDictionary *results = returnData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    //do nothing and return to main list
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
}



@end
