//
//  TaskCDTVC.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 11/17/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "TaskCDTVC.h"
#import "Task.h"
#import "Context.h"
#import "CloudTask.h"
#import "NetworkActivity.h"
#import "Task+Cloud.h"
#import "FormatHelper.h"
#import "DetailsTVC.h"
#import "Location.h"
#import "Location+Cloud.h"
#import "Radius+Cloud.h"
#import "Radius.h"
#import "TaskLocation.h"
#import "TaskLocation+Cloud.h"
#import "NotificationManager.h"
#import "LocationManager.h"
#import "NotificationManager.h"

@interface TaskCDTVC ()

@end

@implementation TaskCDTVC

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
    [self refresh];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    [[LocationManager sharedLocationManager] startMonitoringLocationChanges];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            [self refresh];
        }];
    } else
    {
        [self refresh];
    }
}

- (void) refresh
{

    [self.refreshControl beginRefreshing];
    
    dispatch_queue_t flickrFetcher = dispatch_queue_create("Web API Loading", NULL);
    dispatch_async(flickrFetcher, ^{
        
        [NetworkActivity startIndicator];
        NSArray *tasks = [CloudTask fetchTasks];
        NSArray *locations = [CloudTask fetchLocations];
        NSArray *radii = [CloudTask fetchRadii];
        [NetworkActivity stopIndicator];
        
        [self.context performBlock:^{
            for(NSDictionary *locationDictionary in locations)
            {
                [Location createLocation:locationDictionary
                                 context:self.context];
            }
            
            for(NSDictionary *radiusDictionary in radii)
            {
                [Radius createRadius:radiusDictionary context:self.context];
            }
            
            for(NSDictionary *taskDictionary in tasks)
            {
                [Task createTask:taskDictionary context:self.context];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            [[LocationManager sharedLocationManager] registerRegions];
            [[NotificationManager sharedNotificationManager] registerNotifications];
        });
    });
    

}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    if(context)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"update_date" ascending:NO selector:@selector(compare:)]];
        
        request.predicate = [NSPredicate predicateWithFormat:@"active = %d", YES];
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else
    {
        self.fetchedResultsController = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Task"];
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Last update: %@", [FormatHelper formatDate:task.update_date]];
        
    return cell;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([sender isKindOfClass:[UITableViewCell class]])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        
        if(indexPath)
        {
            if([segue.identifier isEqualToString:@"Details for Task"])
            {
                if([segue.destinationViewController respondsToSelector:@selector(setTask:)])
                {
                    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
                    [segue.destinationViewController performSelector:@selector(setTask:) withObject:task];
                }
            }
        }
    }
    
    if([sender isKindOfClass:[UIBarButtonItem class]])
    {
        if([segue.identifier isEqualToString:@"Add Task"])
        {
            if([segue.destinationViewController respondsToSelector:@selector(setTask:)])
            {
                Task *task = nil;
                [segue.destinationViewController performSelector:@selector(setTask:) withObject:task];
            }
        }
    }
}

- (IBAction)refreshTasks:(UIBarButtonItem *)sender
{
    [self refresh];
}

- (IBAction)cancelTask:(UIStoryboardSegue *) segue
{
    //Do nothing intentionally
}

- (IBAction) doneTask:(UIStoryboardSegue *) segue
{
    DetailsTVC *vc = [segue sourceViewController];
    
    if(vc)
    {
        vc.task.active = @1;
        [self postTask:vc];
    }
}

- (IBAction) deleteTask:(UIStoryboardSegue *) segue
{
    DetailsTVC *vc = [segue sourceViewController];
    
    if(vc)
    {
        vc.task.active = @0;
        [self postTask:vc];
    }
}

- (void) postTask:(DetailsTVC*) vc
{
    NSMutableDictionary *taskDictionary = [[NSMutableDictionary alloc] init];
    NSDate *currentDate = [[NSDate alloc] init];
    NSString *currentDateString = [FormatHelper localeDateToJsonDate:currentDate];
    
    if(vc.task)
    {
        vc.task.title = vc.getTitle;
        vc.task.update_date = currentDate;
        vc.task.due_date = [FormatHelper formatString:vc.getDueDate];
        
        [taskDictionary setObject:vc.task.title forKey:@"title"];
        [taskDictionary setObject:vc.task.task_id  forKey:@"task_id"];
        [taskDictionary setObject:currentDateString forKey:@"update_date"];
        [taskDictionary setObject:vc.task.active forKey:@"active"];
        
        if(vc.task.due_date)
        {
            [taskDictionary setObject:[FormatHelper localeDateToJsonDate:vc.task.due_date] forKey:@"due_date"];
        }
        
        if(vc.radius && vc.location)
        {
            NSMutableDictionary *taskLocationDictionary = [[NSMutableDictionary alloc] init];
            [taskLocationDictionary setObject:vc.task.task_id forKey:@"task_id"];
            [taskLocationDictionary setObject:vc.radius.radius_id forKey:@"radius_id"];
            [taskLocationDictionary setObject:vc.location.location_id forKey:@"location_id"];
            
            NSArray *taskLocationArray = [[NSArray alloc] initWithObjects:taskLocationDictionary, nil];
            
            [taskDictionary setObject:taskLocationArray forKey:@"TaskLocations"];
        }
        
    } else {
        [taskDictionary setObject:vc.getTitle forKey:@"title"];
        [taskDictionary setObject:@0 forKey:@"task_id"];
        [taskDictionary setObject:currentDateString forKey:@"update_date"];
        [taskDictionary setObject:currentDateString forKey:@"create_date"];
        [taskDictionary setObject:[NSNumber numberWithDouble:[[LocationManager sharedLocationManager] currentLocation].coordinate.latitude] forKey:@"latitude"];
        [taskDictionary setObject:[NSNumber numberWithDouble:[[LocationManager sharedLocationManager] currentLocation].coordinate.longitude] forKey:@"longitude"];
        
        if(vc.getDueDate)
        {
            [taskDictionary setObject:[FormatHelper localeDateToJsonDate:[FormatHelper formatString:vc.getDueDate]] forKey:@"due_date"];
        }
        
        if(vc.radius && vc.location)
        {
            NSMutableDictionary *taskLocationDictionary = [[NSMutableDictionary alloc] init];
            [taskLocationDictionary setObject:vc.radius.radius_id forKey:@"radius_id"];
            [taskLocationDictionary setObject:vc.location.location_id forKey:@"location_id"];
            
            NSArray *taskLocationArray = [[NSArray alloc] initWithObjects:taskLocationDictionary, nil];
            
            [taskDictionary setObject:taskLocationArray forKey:@"TaskLocations"];
        }
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
    
    NSDictionary *results = returnData ? [NSJSONSerialization JSONObjectWithData:returnData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    vc.task.task_id = [results objectForKey:@"task_id"];
    vc.task.alternate_id = [results objectForKey:@"alternate_id"];
    
    [self.context performBlock:^{
        NSArray *taskLocationsArray = [results objectForKey:@"TaskLocations"];
        
        for(NSDictionary *taskLocation in taskLocationsArray)
        {
            [TaskLocation createTaskLocation:taskLocation context:self.context];
        }
    }];
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    [[LocationManager sharedLocationManager] registerRegions];
    [[NotificationManager sharedNotificationManager] registerNotifications];
    
}

@end
