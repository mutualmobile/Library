//
//  LibraryTableViewController.m
//  Library
//
//  Created by Sam Solomon on 7/29/15.
//  Copyright © 2015 Sam Solomon. All rights reserved.
//

#import <CoreSpotlight/CoreSpotlight.h>

#import "LibraryTableViewController.h"
#import "BookDetailViewController.h"

#import "Book.h"
#import "BookTableViewCell.h"

static NSString * const kContentTypeBook = @"book";
static NSString * const kDomainIdentifierLibrary = @"com.library";
static NSString * const kSectionHeaderForAllBooks = @"All Books";

@interface LibraryTableViewController ()

@property (strong, nonatomic) NSMutableArray *bookArray;
@property (strong, nonatomic) NSMutableArray *genreArray;
@property (strong, nonatomic) Book *bookToSend;

@end

@implementation LibraryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBooksFromLibraryAndIndexForSearch];
    [self loadGenresAndIndexForSearch];
    [self.tableView reloadData];
}

#pragma mark - Deserialization
- (void)loadBooksFromLibraryAndIndexForSearch {
    NSData *libraryData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"libraryJSON" ofType:@"json"]];
    NSArray *library = [[NSJSONSerialization JSONObjectWithData:libraryData options:kNilOptions error:nil] valueForKey:@"books"];
    
    self.bookArray = [NSMutableArray new];
    
    for(NSDictionary *book in library) {
        Book *tempBook = [[Book alloc] initWithDictionary:book];
        [self indexBookForSearch:tempBook];
        [self.bookArray addObject:tempBook];
    }
}

- (void)loadGenresAndIndexForSearch {
    NSData *genreData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"genreData" ofType:@"json"]];
    
    self.genreArray = [NSMutableArray new];
    self.genreArray = [[NSJSONSerialization JSONObjectWithData:genreData options:kNilOptions error:nil] valueForKey:@"genres"];
    
    for (NSString *genre in self.genreArray) {
        [self indexGenre:genre];
    }
}

#pragma mark - Indexing
- (void)indexBookForSearch:(Book *)book {
    
    CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:kContentTypeBook];
    attributeSet.title = book.title;
    attributeSet.authorNames = @[book.author];
    attributeSet.publishers = @[book.publishingHouse];
    attributeSet.genre = book.genre;
    attributeSet.identifier = book.bookID;
    attributeSet.contentDescription = [NSString stringWithFormat:@"Read '%@' using Library now", book.title];
    
    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:book.bookID domainIdentifier:kDomainIdentifierLibrary attributeSet:attributeSet];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error) {
        UIAlertController *errorAlertController = [UIAlertController alertControllerWithTitle:@"Indexing error!" message:[NSString stringWithFormat:@"Failed to index a search item.\n\nHere's why;\n%@",error] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
        [errorAlertController addAction:okAction];
        
        [self presentViewController:errorAlertController animated:YES completion:nil];
    }];
}

- (void)indexGenre:(NSString *)genre {
    
    CSSearchableItemAttributeSet* attributeSet = [[CSSearchableItemAttributeSet alloc] initWithItemContentType:kContentTypeBook];
    attributeSet.title = genre;
    attributeSet.identifier = genre;
    
    attributeSet.contentDescription = [NSString stringWithFormat:@"Read '%@' books using Library now", genre];

    CSSearchableItem *item = [[CSSearchableItem alloc] initWithUniqueIdentifier:genre domainIdentifier:kDomainIdentifierLibrary attributeSet:attributeSet];
    [[CSSearchableIndex defaultSearchableIndex] indexSearchableItems:@[item] completionHandler: ^(NSError * __nullable error) {
        
        UIAlertController *errorAlertController = [UIAlertController alertControllerWithTitle:@"Indexing error!" message:[NSString stringWithFormat:@"Failed to index a search item.\n\nHere's why;\n%@",error] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil];
        [errorAlertController addAction:okAction];
        
        [self presentViewController:errorAlertController animated:YES completion:nil];
    }];
}

#pragma mark - Table view data source

-(NSString *)tableView:(nonnull UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return kSectionHeaderForAllBooks;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.bookArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    //TODO: fixed, lower case `C` in cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.textLabel.text = [[self.bookArray objectAtIndex:indexPath.row] title];
    return cell;
}

-(void)tableView:(nonnull UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    Book *book = [self.bookArray objectAtIndex:[[self.tableView indexPathForSelectedRow] row]];
    [self goToDetailWithBook:book.bookID];
}

#pragma mark - Convenience Methods
-(Book *)getBookForBookID:(NSString *)bookID {
    for(Book *book in self.bookArray){
        if(bookID == book.bookID) {
            return book;
        }
    }
    return nil;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue destinationViewController] isKindOfClass:[BookDetailViewController class]]) {
        BookDetailViewController *vc = [segue destinationViewController];
        vc.book = self.bookToSend;
    }
}

-(void)goToDetailWithBook:(NSString *)bookID {
    self.bookToSend = [self getBookForBookID:bookID];
    [self performSegueWithIdentifier:@"goToDetail" sender:self];
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

@end
