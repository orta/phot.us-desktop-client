#
#  Uploader.rb
#  photouploader
#
#  Created by orta on 11/05/2011.
#  Copyright 2011 http://www.ortatherox.com. All rights reserved.
#

class Uploader
  def self.toS3 file_path, filename
    file = File.new(file_path, 'rb')
    s3_access_key = NSUserDefaults.standardUserDefaults.stringForKey "access_key_id"
    s3_secret_access_key = NSUserDefaults.standardUserDefaults.stringForKey "secret_access_key"
    s3_bucket = NSUserDefaults.standardUserDefaults.stringForKey "bucket"

    AWS::S3::Base.establish_connection!(
      :access_key_id     => s3_access_key,
      :secret_access_key => s3_secret_access_key
    )

  object = AWS::S3::S3Object.store(filename, file, s3_bucket, :access => :public_read)
    "http://s3.amazonaws.com/" + s3_bucket  + "/" + filename
  end
end
