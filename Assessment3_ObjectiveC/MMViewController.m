//
//  MMViewController.m
//  Assessment3_ObjectiveC
//
//  Created by Kevin McQuown on 8/5/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

#import "MMViewController.h"
#import "MMDivvyStation.h"
#import "MMMapViewController.h"

#define urlToRetrieveDivvyData @"http://www.divvybikes.com/stations/json/"

@interface MMViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property NSArray *bikeStations;


@end

@implementation MMViewController


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bikeStations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"divvyCell"];
    NSDictionary *currentStation = [self.bikeStations objectAtIndex:indexPath.row];
    cell.textLabel.text = [currentStation objectForKey:@"stationName"];
    NSString *availableBikes = [currentStation objectForKey:@"availableBikes"];
    NSString *availableDocks = [currentStation objectForKey:@"availableDocks"];
    NSString *bikeInfo = [NSString stringWithFormat:@"Open Bikes: %@  Open Docks: %@",availableBikes,availableDocks];
    cell.detailTextLabel.text = bikeInfo;

    return cell;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    MMMapViewController *newViewController = segue.destinationViewController;
    NSIndexPath *selectedIndexPath = self.myTableView.indexPathForSelectedRow;
    NSDictionary *currentStation = [self.bikeStations objectAtIndex:selectedIndexPath.row];
    newViewController.currentStation = currentStation;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"Divvy Bike Locator";
    [self searchForBikes];
}

-(void)searchForBikes
{
    NSString *urlString = [NSString stringWithFormat:@"http://www.divvybikes.com/stations/json/"];
    NSURL *url = [NSURL URLWithString: urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]
    completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

    NSDictionary *stuff = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&connectionError];

    self.bikeStations = [stuff objectForKey:@"stationBeanList"];
                               
    [self.myTableView reloadData];
                               
    }];

}

@end
