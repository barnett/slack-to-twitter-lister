require 'slack-ruby-client'
require 'twitter'

SLACK_USER_TOKEN = 'XXXX'
SLACK_TWITTER_PROFILE_ID = 'XXXX'

TWITTER_CONSUMER_KEY = 'XXXX'
TWITTER_CONSUMER_SECRET = 'XXXX'
TWITTER_ACCESS_TOKEN = 'XXXX'
TWITTER_ACCESS_SECRET = 'XXXX'
TWITTER_LIST_ID = 12345

class User
  attr_accessor :slack_id, :slack_name, :twitter_handle
end

slack_client = Slack::Web::Client.new(token: SLACK_USER_TOKEN)

users = []
deleted_users = []
slack_client.users_list.members.each do |user|
  new_user = User.new
  new_user.slack_id = user.id
  new_user.slack_name = user.name
  new_user.twitter_handle = slack_client.users_profile_get(user: user.id).profile.fields.to_h.dig(SLACK_TWITTER_PROFILE_ID, 'value')

  ary = user.deleted ? deleted_users : users

  ary << new_user
end

twitter_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = TWITTER_CONSUMER_KEY
  config.consumer_secret     = TWITTER_CONSUMER_SECRET
  config.access_token        = TWITTER_ACCESS_TOKEN
  config.access_token_secret = TWITTER_ACCESS_SECRET
end

twitter_client.add_list_members(TWITTER_LIST_ID, users.map(&:twitter_handle).compact)
twitter_client.remove_list_members(TWITTER_LIST_ID, deleted_users.map(&:twitter_handle).compact)
