#
#  ImageBrowser.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

framework 'Quartz'

class ImageViewer < IKImageView
  attr_accessor :imageBrowser

  #pass key events to the browser
  def keyDown(event)
    imageBrowser.keyDown event
  end

  def keyUp(event)
    imageBrowser.keyUp event
  end
end