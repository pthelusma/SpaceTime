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
#import "CloudLocation.h"
#import "CloudTask.h"
#import "NetworkActivity.h"
#import "Task+Cloud.h"
#import "FormatHelper.h"
#import "LocationService.h"

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
        [NetworkActivity stopIndicator];
        
        [self.context performBlock:^{
            for(NSDictionary *dictionary in tasks)
            {
                [Task createTask:dictionary context:self.context];
            }
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
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
        
        request.predicate = nil;
        
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
    UITableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"Task"];
    
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

- (IBAction)refreshTasks:(UIBarButtonItem *)sender {
    [self refresh];
}
@end
