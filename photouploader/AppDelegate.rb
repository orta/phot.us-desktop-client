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
  end
  
  def application(sender, openFiles:files)
    add_files file
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
    url = NSURL.fileURLWithPath @images[index].imageUID
    
    imageView.setImageWithURL url
  end

  #stuff for imageView
  def selectionRectAdded(imageView)
    puts "OK"
  end
  
end

