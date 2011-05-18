#
#  rb_main.rb
#  photouploader
#
#  Created by orta on 26/03/2011.
#  Copyright (c) 2011 http://www.ortatherox.com. All rights reserved.
#

# Loading the Cocoa framework. If you need to load more frameworks, you can
# do that here too.
framework 'Cocoa'

require 'rubygems'
require 'rest_client'
#require 'aws/s3'
require 'json'

# Loading all the Ruby project files.
main = File.basename(__FILE__, File.extname(__FILE__))
dir_path = NSBundle.mainBundle.resourcePath.fileSystemRepresentation
Dir.glob(File.join(dir_path, '*.{rb,rbo}')).map { |x| File.basename(x, File.extname(x)) }.uniq.each do |path|
  if path != main
    if !path.include? "_test" 
      require(path)
    end
  end
end

# Starting the Cocoa main loop.
NSApplicationMain(0, nil)
