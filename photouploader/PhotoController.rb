#
#  PhotoController.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class PhotoController
  attr_accessor :images, :imageView, :imageBrowserView
   
  def self.sharedController
    @@sharedController
  end

  def awakeFromNib
    @images = NSMutableArray.array
    imageView.setDoubleClickOpensImageEditPanel false
    imageView.setCurrentToolMode IKToolModeCrop

    imageBrowserView.window.delegate = imageBrowserView
    @@sharedController = self

  #      Dir.chdir "/Users/orta/Desktop/morgan/"  
  #     add_files Dir.glob "*.jpg"
  end

  def set_images image_array
    @images = image_array
    imageBrowserView.reloadData
  end

  def add_files files
    files.each do |file_path|
      break unless file_path.downcase.include? "jpg"
      photo = Photo.new
      photo.imageUID = file_path
      photo.imageTitle = File.basename(file_path)
      @images << photo
    end
    imageBrowserView.reloadData
  end

  # IKImageBrowserView delegate bits

  def numberOfItemsInImageBrowser(view)
    images.count
  end

  def imageBrowser(view, itemAtIndex: index)
    images[index]
  end

  def imageBrowser(aBrowser, removeItemsAtIndexes:indexes)
    images.removeObjectsAtIndexes indexes
    imageBrowserView.reloadData
  end  

  def imageBrowserSelectionDidChange(browser)
    index = browser.selectionIndexes.firstIndex
    image = images[index]   
    
    if image
      url = NSURL.fileURLWithPath image.imageUID
      imageView.setImageWithURL url
      
      if image.crop
        imageView.selectionRect = NSRectFromString( image.crop )
      end
    end
  end

  def draggingEntered(sender)
    self.draggingUpdated sender
  end

  def draggingUpdated(sender)
    NSDragOperationCopy
  end

  def performDragOperation(sender)
    return if sender == imageBrowserView
    
    filenames = sender.draggingPasteboard.propertyListForType NSFilenamesPboardType
    add_files filenames    
  end

  # stuff for IKImageView
  # this method is both private, and the selectionRect is too
  def selectionRectChanged(imageView)
    if imageBrowserView.selectionIndexes.count == 1
      index = imageBrowserView.selectionIndexes.firstIndex
      images[index].crop = NSStringFromRect( imageView.selectionRect )
    end
  end
end