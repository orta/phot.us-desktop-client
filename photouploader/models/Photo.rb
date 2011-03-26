#
#  Photo.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class Photo
  attr_accessor :imageUID, :imageTitle
  
  def imageRepresentation
      imageUID
  end
  
  def imageRepresentationType
    IKImageBrowserPathRepresentationType
  end 

end