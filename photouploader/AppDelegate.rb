#
#  AppDelegate.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class AppDelegate
  attr_accessor :window, :imageView
  
  def application(sender, openFiles:files)
    files.each do |file_path|
      photo = Photo.new
      photo.imageUID = file_path
      photo.imageTitle = file_path
      @images << photo
    end
    imageView.reloadData
  end
  
  #pragma --
  
  def numberOfItemsInImageBrowser(view)
    @images.count
  end
  
  def imageBrowser(view, itemAtIndex: index)
    @images[index]
  end
  
  def applicationDidFinishLaunching(a_notification)
    @images = NSMutableArray.array
  end
end

