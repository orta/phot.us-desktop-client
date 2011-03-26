#
#  AppDelegate.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class AppDelegate
  attr_accessor :window, :photoController
  
  def applicationDidFinishLaunching(a_notification)
  end
  
  def application(sender, openFiles:files)
    photoController.add_files files
  end
end

