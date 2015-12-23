AWS.config(
  :access_key_id => 'AKIAJS2YONYPZ2ZECG4Q',
  :secret_access_key => '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'
)
S3_BUCKET =  AWS::S3.new.buckets['eatathome']