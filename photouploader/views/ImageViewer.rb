#
#  ImageBrowser.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

framework 'Quartz'

class ImageViewer < IKImageView
  attr_accessor :imageBrowser, :cropInfoField
  alias super_mouseUp mouseUp
  alias super_setSelectionRect setSelectionRect
  
  def awakeFromNib
    cool_image = NSImage.imageNamed "somethingcool"
    self.image = cool_image
    self.backgroundColor = NSColor.blackColor
  end
  
  #pass key events to the browser
  def keyDown(event)
    imageBrowser.keyDown event
  end

  def keyUp(event)
    imageBrowser.keyUp event
  end
  
  def mouseUp(event)
    super_mouseUp event
    rect = self.selectionRect
    
    image = NSImage.alloc.initWithCGImage( self.image, size: self.imageSize) 
    
    #make square
    if rect.size.width > rect.size.height
      rect.size.height = rect.size.width
    else
      rect.size.width = rect.size.height
    end
    
    #make max size
    if rect.size.width > image.size.width
      rect.size.width = image.size.width
    end

    if rect.size.height > image.size.height
      rect.size.height = image.size.height
    end

    #make sure the right edge is in
    right_x = rect.origin.x + rect.size.width
    if right_x > image.size.width
      rect.origin.x = image.size.width- rect.size.width
    end

    bottom_x = rect.origin.y + rect.size.height
    if bottom_x > image.size.height
      rect.origin.y = image.size.height - rect.size.height
    end
    
    rect.origin.x = [rect.origin.x, 0].max 
    rect.origin.y = [rect.origin.y, 0].max 
    
    self.setSelectionRect rect
    cropInfoField.setStringValue "Crop info : w:#{rect.size.width} h:#{rect.size.height} x:#{rect.origin.x} y:#{rect.origin.y}"
  end
    
  def setSelectionRect(rect)
    super_setSelectionRect rect
    cropInfoField.setStringValue "Crop info : w:#{rect.size.width} h:#{rect.size.height} x:#{rect.origin.x} y:#{rect.origin.y}"
  end
end