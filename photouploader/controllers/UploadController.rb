#
#  UploadController.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#


class UploadController
  attr_accessor :photoController
  
  def photos
    photoController.images
  end

  def submit(sender)
    puts "hi"
  end
  
end
