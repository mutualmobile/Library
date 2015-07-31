//
//  LibraryTableViewController.m
//  Library
//
//  Created by Sam Solomon on 7/29/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import "LibraryTableViewController.h"
#import "BookDetailViewController.h"
#import <CoreSpotlight/CoreSpotlight.h>
#import "BookTableViewCell.h"
#import "Book.h"

@interface LibraryTableViewController ()
{
    NSMutableArray *bookArray;
    NSMutableArray *genreArray;
    NSUserActivity *libraryActivity;
    Book *bookToSend;
}

@end

@implementation LibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBooksFromLibraryAndIndexForSearch];
    [self loadGenresAndIndexForSearch];
    [self initActivities];
    [self.tableView reloadData];
}

- (void)initActivities {
    libraryActivity = [[NSUserActivity alloc] initWithActivityType:@"com.library"];
    libraryActivity.title = @"Library";
    libraryActivity.keywords = [NSSet setWithArray:@[]];
    libraryActivity.userInfo = @{};
    libraryActivity.eligibleForSearch = YES;
}

- (void)loadBooksFromLibraryAndIndexForSearch {
    NSData *libraryData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"libraryJSON" ofType:@"json"]];
    
    NSArray *library = [[NSJSONSerialization JSONObjectWithData:libraryData options:kNilOptions error:nil] valueForKey:@"books"];
    
    bookArray = [NSMutableArray new];
    
    for(NSDictionary *book in library) {
        Book *tempBook = [[Book alloc] initWithDictionary:book];
        [self indexBookForSearch:tempBook];
        [bookArray addObject:tempBook];
    }
}

- (void)loadGenresAndIndexForSearch {
    NSData *genreData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"genreData" ofType:@"json"]];
    
    genreArray = [NSMutableArray new];
    genreArray = [[NSJSONSerialization JSONObjectWithData:genreData options:kNilOptions error:nil] valueForKey:@"genres"];
    
    for (NSString *genre in genreArray) {
        [self indexGenre:genre];
    }
}

- (void)indexBookForSearch:(Book *)book {
    
    CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"book"];
    attributeSet.title = book.title;
    attributeSet.authorNames = @[book.author];
    attributeSet.publishers = @[book.publishingHouse];
    attributeSet.genre = book.genre;
    attributeSet.identifier = book.bookID;
    attributeSet.contentDescription = [NSString stringWithFormat:@"Read '%@' using Library now", book.title];
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:book.bookID domainIdentifier:@"com.library" attributeSet:attributeSet];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error) {
        NSLog(@"Book indexed");
    }];
}

- (void)indexGenre:(NSString *)genre {
    
    CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:@"book"];
    attributeSet.title = genre;
    attributeSet.identifier = genre;
    
    attributeSet.contentDescription = [NSString stringWithFormat:@"Read '%@' books using Library now", genre];
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:genre domainIdentifier:@"com.library" attributeSet:attributeSet];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error) {
        NSLog(@"Genre indexed");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"All Books";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [bookArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = [[bookArray objectAtIndex:indexPath.row] title];
    return cell;
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Book *book = [bookArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    [self goToDetailWithBook:book.bookID];
}

-(void)goToDetailWithBook:(NSString *)bookID {
    bookToSend = [self getBookForBookID:bookID];
    [self performSegueWithIdentifier:@"goToDetail" sender:self];
}

-(Book *)getBookForBookID:(NSString *)bookID {
    for(Book *book in bookArray){
        if(bookID == book.bookID) {
            return book;
        }
    }
    return nil;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass:[BookDetailViewController class]]) {
        BookDetailViewController *vc = [segue destinationViewController];
        vc.book = bookToSend;
    }
}

- (IBAction)switch:(id)sender {
}
@end
