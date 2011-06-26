#
# MyDocument.rb
# phot.us_uploader
#
# Created by orta on 08/06/2011.
# Copyright __MyCompanyName__ 2011. All rights reserved.
#

class MyDocument < NSDocument

	# Name of nib containing document window
	def windowNibName
		'MyDocument'
	end
	
  def writeToURL( url, ofType:type, error:error)
    File.open(url.path, 'w') {|f| f.write(YAML.dump( PhotoController.sharedController.images)) }
  end
  
  def readFromURL( url, ofType:type, error:error)
    @loaded_images = YAML.load(File.read(url.path))
  end

  def awakeFromNib
    PhotoController.sharedController.set_images @loaded_images if @loaded_images
  end
  
	# Return lowercase 'untitled', to comply with HIG
	def displayName
		fileURL ? super : super.sub(/^[[:upper:]]/) {|s| s.downcase}
	end
end