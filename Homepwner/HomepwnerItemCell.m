//
//  HomepwnerItemCell.m
//  Homepwner
//
//  Created by Fabrice Guillaume on 1/28/13.
//  Copyright (c) 2013 Fabrice Guillaume. All rights reserved.
//

#import "HomepwnerItemCell.h"
#import "Possession.h"

@implementation HomepwnerItemCell

// When an instance of HomepwnerItemCell is created, it will instantiate its
// valueLabel, nameLabel, and imageView. Then, these subviews will be added to the
// cell’s contentView. Override the designated initializer to do this.
- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        // Create a subview - don't need to specify its position/size
        valueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        // Put it on the content view of the cell
        [[self contentView] addSubview:valueLabel];
        
        // It is being retained by its superview
        [valueLabel release];
        
        // Same thing with the name
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:nameLabel];
        [nameLabel release];
        
        // Same thing with the image view
        imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [[self contentView] addSubview:imageView];
        
        // Tell the imageview to center its image inside its frame
        [imageView setContentMode:UIViewContentModeCenter];
        [imageView release];
        
    }
    
    return self;
}

// override layoutSubviews to give each of the subviews a frame.
// When a view changes size, it is sent the message layoutSubviews. Because
// UITableViewCell (and therefore HomepwnerItemCell) is a subclass of UIView,
// it also is sent layoutSubviews when its size changes.
- (void)layoutSubviews
{
    // We always call this, the table view cell needs to do its own work first
    [super layoutSubviews];
    
    // We'll use this to add spacing between borders
    float inset = 5.0;
    
    // How much space do we have to work with?
    CGRect bounds = [[self contentView] bounds];
    
    // Let's pull out of the height and width
    // into easier-to-type variable names
    float h = bounds.size.height;
    float w = bounds.size.width;
    
    // This will be a constant value for the valueField's width
    float valueWidth = 40.0;

    // Create a rectangle on the left hand side of the cell for the imageView
    // Set the imageView’ s frame according to the Possession’s desired thumbnail size
    CGSize thumbnailSize = [Possession thumbnailSize];
    float imageSpace = h - thumbnailSize.height;
    //CGRect imageFrame = CGRectMake(inset, inset, 40, 40); 
    CGRect imageFrame = CGRectMake(inset, imageSpace / 2.0,
                                   thumbnailSize.width,
                                   thumbnailSize.height);
    [imageView setFrame:imageFrame];
    
    // Create a rectangle in the middle for the name
    CGRect nameFrame = CGRectMake(imageFrame.size.width + imageFrame.origin.x + inset,
                                  inset,
                                  w - (h + valueWidth + inset * 4.0),
                                  h - inset * 2.0);
    [nameLabel setFrame:nameFrame];
    
    // Create a rectangle on the right side of the cell for the value
    CGRect valueFrame = CGRectMake(nameFrame.size.width + nameFrame.origin.x + inset,
                                   inset,
                                   valueWidth,
                                   h - inset * 2.0);
    [valueLabel setFrame:valueFrame];

}

// Implement the method setPossession: to extract values from a Possession instance
// and display them in the cell.
- (void)setPossession:(Possession *)possession
{
    // Using a Possession instance, we can set the values of the subviews
    [valueLabel setText:
        [NSString stringWithFormat:@"$%d", [possession valueInDollars]]];
    [nameLabel setText:[possession possessionName]];
    
    // use this thumbnail to set the imageView of the cells when they are configured
    // for the table view.
    [imageView setImage:[possession thumbnail]];
}

@end
