//
//  DetailsVC.m
//  sigmaSoftTask
//
//  Created by Michael Bielodied on 10/20/15.
//  Copyright © 2015 Michael Bielodied. All rights reserved.
//

#import "DetailsVC.h"
#import "DetailViewCell.h"
#import "Constants.h"

#define CELL_ID @"detailsCell"

@interface DetailsVC ()
    @property (nonatomic, strong) NSArray* placeInfoData;
    @property (nonatomic, weak) IBOutlet UITableView * detailsInfoTable;
@end

@implementation DetailsVC

@synthesize placeObject;
@synthesize placeInfoData;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Venue information";
    
    //set a separator color
    [self.detailsInfoTable setSeparatorColor:UIColorFromRGB(orangeColor)];
    
    // This will remove extra separators from tableview
    self.detailsInfoTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setPlaceObject:(Place *)placeObjectValue {
    placeObject = placeObjectValue;
    
    placeInfoData = [[NSArray alloc] initWithArray:[placeObject convertToArray]];
    [self.detailsInfoTable reloadData];
}

#pragma mark UItableView delegate

//set offset for separator to 0.0
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [placeInfoData count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailViewCell *cell = (DetailViewCell *) [tableView dequeueReusableCellWithIdentifier:CELL_ID forIndexPath:indexPath];
    
    cell.mainLabel.text = placeInfoData[indexPath.row];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
