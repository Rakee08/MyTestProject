//
//  ListView.m
//  N Bazaar
//
//  Created by Srinivasa Ganesan on 30/03/17.
//  Copyright © 2017 SupremeTechnologies. All rights reserved.
//

#import "ListView.h"
#import "CollectionCell.h"
#import "Utilities.h"


@interface ListView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    NSArray *objListArray;
}




@end
@implementation ListView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:@"ListView" owner:self options:nil];
        _objMainView.frame=CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self addSubview:_objMainView];
        // EVIL: Register your own cell class (or comment this out)
        [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
        
        // allow multiple selections
        self.collectionView.allowsMultipleSelection = YES;
        self.collectionView.allowsSelection = YES;
    }
    return self;
    
}


-(IBAction)didClickArroe:(id)sender{
    [self.delegate getView:self];
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return objListArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    
    NSDictionary *objDict = [objListArray objectAtIndex:indexPath.item];
    cell.objitemName.text=[objDict valueForKey:@"ItemName"];
    NSString *ImageURL = [objDict valueForKey:@"ItemImageUrl"];
    //NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    
    [Utilities setThumbNailImage:cell.objItemImage imageUrlString:ImageURL thumbImage:NO];
    // cell.objItemImage.image = [UIImage imageWithData:imageData];
    
    
    
    return cell;
}


-(void)getValuesFromDic:(NSDictionary *)objDic{
    _objtitle.text = [objDic valueForKey:@"CatagoryName"];
    _objDescription.text=[objDic valueForKey:@"Description"];
    objListArray = [objDic valueForKey:@"ItemsArray"];
    [_collectionView reloadData];
    NSString *ImageURL = [objDic valueForKey:@"CatogoryImage"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    _objThumbImg.image = [UIImage imageWithData:imageData];
}
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    CGFloat size = (collectionView.bounds.size.width/4);
    
    CGSize objsize = collectionView.contentSize;
    CGFloat objheight = objsize.height;
    int collctionviewHeight = objheight/size;
    
    CGSize mElementSize = CGSizeMake(size-0.75, size);
    //CGSize mElementSize = CGSizeMake(78.75, 78.75);
    
    [_collectionView setFrame:CGRectMake(_collectionView.frame.origin.x, _collectionView.frame.origin.y, _collectionView.frame.size.width, size * collctionviewHeight)];
    
    
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 1.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // return UIEdgeInsetsMake(0,8,0,8);  // top, left, bottom, right
    return UIEdgeInsetsMake(0,0,0,0);  // top, left, bottom, right
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectatindex:indexPath];
}


@end
