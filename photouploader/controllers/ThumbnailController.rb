#
#  ThumbnailController.rb
#  photouploader
#
#  Created by orta on 27/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#


class ThumbnailController
  
  def self.thumbnailForPhoto photo, name, width, height
    image = NSImage.alloc.initWithContentsOfFile(photo.filepath)    
    scaledImage = NSImage.alloc.initWithSize(NSMakeSize(width, height))
    scaledImage.lockFocus
    NSGraphicsContext.currentContext.setImageInterpolation NSImageInterpolationHigh
    if photo.crop
      image.drawInRect(NSMakeRect(0, 0, width, height), fromRect: photo.crop, operation: NSCompositeCopy, fraction: 1.0)
    else
      image.drawInRect(NSMakeRect(0, 0, width, height), fromRect: NSZeroRect, operation: NSCompositeCopy, fraction: 1.0)
    end
    scaledImage.unlockFocus
    
    properties = NSDictionary.dictionaryWithObject( 0.7, forKey: NSImageCompressionFactor)
    bitmap = NSBitmapImageRep.imageRepWithData scaledImage.TIFFRepresentation
    jpg_data = bitmap.representationUsingType( NSJPEGFileType,  properties:properties )
    jpg_data.writeToFile("/tmp/#{name}.jpg", atomically:true)
    "/tmp/#{name}.jpg"
  end
end