//
//  LocationCDTVC.m
//  ConsumeWSDL
//
//  Created by Pierre Thelusma on 12/10/13.
//  Copyright (c) 2013 Pierre Thelusma. All rights reserved.
//

#import "LocationCDTVC.h"
#import "Context.h"

@interface LocationCDTVC ()

@end

@implementation LocationCDTVC

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
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!self.context)
    {
        [Context createContext:^(NSManagedObjectContext *context){
            self.context = context;
        } refresh:^{
            nil;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setLocation: (Location *) location
{
    _location = location;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Location"];
    
    Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.font = [UIFont systemFontOfSize:12.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
    
    cell.textLabel.text = location.title;
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(location.location_id == self.location.location_id)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    
    if(context)
    {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Location"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else
    {
        self.fetchedResultsController = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSIndexPath *currentIndexPath = [self.fetchedResultsController indexPathForObject:self.location];

    if (currentIndexPath == indexPath) {
        return;
    }
    
    UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
    if (newCell.accessoryType == UITableViewCellAccessoryNone) {
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }

    UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:currentIndexPath];
    if (oldCell.accessoryType == UITableViewCellAccessoryCheckmark) {
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
}
@end
