# frozen_string_literal: true

require 'json'
require 'yaml'
require 'optparse'

require 'google_drive'

Version = "1.0.0"

class SpreadsheetWriter
  attr_reader :params

  def initialize
    @params = parse_options
  end

  def call
    update_rows
  end

  def update_rows
    primary_key = params[:primary_key]

    while line = gets
      json = JSON.parse(line)

      if worksheet.list.size == -1
        worksheet.insert_rows(1, [json.keys])
        worksheet.save
      end

      list_row = worksheet.list.find { |x| x[primary_key] == json[primary_key] } if primary_key

      if list_row
        list_row.merge!(json)
      else
        worksheet.list.push(json)
      end
    end

    worksheet.save
  end

  def worksheet
    @worksheet ||= begin
      session = GoogleDrive::Session.from_service_account_key(params[:service_account_key])
      spreadsheet = session.spreadsheet_by_key(params[:key])
      worksheet = spreadsheet.worksheet_by_sheet_id(params[:gid] || 0)
      worksheet
    end
  end

  def parse_options
    params = {}

    opts = OptionParser.new do |opts|
      opts.on('--service-account-key=') { |v| params[:service_account_key] = v }
      opts.on('--key=') { |v| params[:key] = v }
      opts.on('--gid=') { |v| params[:gid] = v }
      opts.on('--primary-key=') { |v| params[:primary_key] = v }
    end
    opts.parse!(ARGV)

    required_keys_ok = %i[service_account_key key].all? { |x| params.key?(x) }
    unless required_keys_ok
      puts(opts.help)
      exit(1)
    end

    params
  end
end

SpreadsheetWriter.new.call if $PROGRAM_NAME == __FILE__
