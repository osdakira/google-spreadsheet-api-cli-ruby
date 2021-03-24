# google-spreadsheet-api-cli-ruby

I want to add row to google-spreadsheet via cli

## Installation

Clone the git repository and do a bundle install.

```
git clone git@github.com:osdakira/google-spreadsheet-api-cli-ruby.git
cd google-spreadsheet-api-cli-ruby
bundle install
```

## Prepare

1. Create a google service account key
  - https://cloud.google.com/iam/docs/creating-managing-service-account-keys
2. Share the spreadsheet you want to write to the account key you created.

## Run

If primary_key is specified, it will be overwritten.
If it is not specified, it will be added.

```
cat any.json | bundle exec ruby main.rb --service-account-key "service-account-key.json" --key 'spreadsheet-key' --gid 'sheet_id' --primary-key 'timestamp'
```
