#
#  AppDelegate.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class AppDelegate
  attr_accessor :window
  @images = []
  
  def application(sender, openFiles:files)
    files.each do |file|
      puts file
    end
  end
  
  
  def applicationDidFinishLaunching(a_notification)
    # Insert code here to initialize your application
  end
end

