# AppDelegate.rb
# phot.us_uploader
#
# Created by orta on 08/06/2011.
# Copyright 2011 __MyCompanyName__. All rights reserved.

class AppDelegate
  attr_accessor :window, :photoController
    
  def application(sender, openFiles:files)
    photoController.add_files files
  end
end

