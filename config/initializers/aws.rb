AWS.config(
  ses: { region: 'us-west-2' },
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)

S3_BUCKET = AWS::S3.new.buckets[ENV['AWS_S3_BUCKET']]
SES = AWS::SimpleEmailService.new