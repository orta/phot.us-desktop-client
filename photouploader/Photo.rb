#
#  Photo.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class Photo
  attr_accessor :imageUID, :imageTitle, :crop
  
  def filepath
    imageUID
  end
  
  def imageRepresentation
      imageUID
  end
  
  def imageRepresentationType
    IKImageBrowserPathRepresentationType
  end 

  def initWithCoder(decoder)
    puts "coder"
    super
    @imageUID = decoder.decodeObjectForKey(:image_uid)
    @imageTitle = decoder.decodeObjectForKey(:image_title)
    @imageCrop = NSRectFromString( decoder.decodeObjectForKey(:crop) )
    self
  end

  def encodeWithCoder coder    
    coder.encodeObject(@imageUID, forKey:'image_uid') if @imageTitle
    coder.encodeObject(@imageTitle, forKey:'image_title') if @imageTitle
    coder.encodeObject( NSStringFromRect( @crop ), forKey:'crop') if @crop
    coder.finishEncoding
  end
  
  def describe
    puts "Photo - #{ @imageUID } - #{ imageTitle } - #{ NSStringFromRect( @crop ) if @crop }"
  end
end