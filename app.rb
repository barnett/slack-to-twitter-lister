require 'slack-ruby-client'
require 'twitter'

SLACK_USER_TOKEN = 'XXXX'
SLACK_TWITTER_PROFILE_ID = 'XXXX'

TWITTER_CONSUMER_KEY = 'XXXX'
TWITTER_CONSUMER_SECRET = 'XXXX'
TWITTER_ACCESS_TOKEN = 'XXXX'
TWITTER_ACCESS_SECRET = 'XXXX'
TWITTER_LIST_ID = 12345

slack_client = Slack::Web::Client.new(token: SLACK_USER_TOKEN)

users = []
deleted_users = []
slack_client.users_list.members.each do |user|
  twitter_handle = slack_client.users_profile_get(user: user.id)
                               .profile
                               .fields
                               .to_h
                               .dig(SLACK_TWITTER_PROFILE_ID, 'value')
                               &.gsub('@','')

  next unless twitter_handle.present?

  ary = user.deleted ? deleted_users : users

  ary << twitter_handle
end

twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = TWITTER_CONSUMER_KEY
  config.consumer_secret     = TWITTER_CONSUMER_SECRET
  config.access_token        = TWITTER_ACCESS_TOKEN
  config.access_token_secret = TWITTER_ACCESS_SECRET
end

current_list_members = twitter_client.list_members(TWITTER_LIST_ID).map(&:screen_name)

users_to_add = users.select do |user_twitter_handle|
  current_list_members.exclude? user_twitter_handle
end

twitter_client.add_list_members(TWITTER_LIST_ID, users_to_add)
twitter_client.remove_list_members(TWITTER_LIST_ID, deleted_users)
