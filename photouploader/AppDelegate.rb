#
#  AppDelegate.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class AppDelegate
  attr_accessor :window, :imageBrowserView, :imageView
  
  def applicationDidFinishLaunching(a_notification)
    @images = NSMutableArray.array
    imageView.setDoubleClickOpensImageEditPanel false
    imageView.setCurrentToolMode IKToolModeCrop
  end
  
  def application(sender, openFiles:files)
    add_files files
  end
  
  def add_files files
    files.each do |file_path|
      photo = Photo.new
      photo.imageUID = file_path
      photo.imageTitle = file_path
      @images << photo
    end
    imageBrowserView.reloadData
  end
  
  #stuff for IKBrowser
  
  def numberOfItemsInImageBrowser(view)
    @images.count
  end
  
  def imageBrowser(view, itemAtIndex: index)
    @images[index]
  end
  
  def imageBrowser(aBrowser, removeItemsAtIndexes:indexes)
    @images.removeObjectsAtIndexes indexes
    imageBrowserView.reloadData
  end  
  
  def imageBrowserSelectionDidChange(browser)
    index = browser.selectionIndexes.firstIndex
    image = @images[index]   
    url = NSURL.fileURLWithPath image.imageUID
    imageView.setImageWithURL url
    
    if image.crop
      imageView.selectionRect = image.crop
    end
  end

  # stuff for imageView
  # this method is both private, and the selectionRect is too
  def selectionRectChanged(imageView)
    index = imageBrowserView.selectionIndexes.firstIndex
    @images[index].crop = @imageView.selectionRect
  end
end

