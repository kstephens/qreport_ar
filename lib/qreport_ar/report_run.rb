require 'qreport_ar'
require 'qreport/connection'
require 'qreport/report_run'
require 'qreport'
require 'qreport/report_runner'

module QreportAR
  # An ActiveRecord model for Qreport report_runs table.
  class ReportRun < ActiveRecord::Base
    establish_connection QreportAR.connection
    self.table_name = [ QreportAR.schema, 'qr_report_runs' ].compact * '.'

    serialize :arguments, JSON
    serialize :error, JSON
    serialize :additional_columns, JSON
    serialize :base_columns, JSON

    def data
      @data ||= _report_run.data
    end

    def _report_run
      @_report_run ||= Qreport::ReportRun.new(attributes.symbolize_keys.merge(:conn => self.class.conn))
    end

    def reload
      @data = @_report_run = nil
      super
    end

    def self.generate report_name, params
      raise ArgumentError, "expected report_name" if report_name.blank?
      raise ArgumentError, "invalid report_name" unless report_name =~ /\A[-_a-z0-9]+\Z/i

      arguments = { }
      params.each { | k, v | arguments[k.to_sym] = v }
      arguments[:now] ||= Time.now
      arguments[:now] = Time.parse(arguments[:now]) if arguments[:now].is_a?(String)
      interval = arguments[:interval] ||= '24 hour'

      report_run = Qreport::ReportRun.new(params)
      report_run.arguments = arguments
      begin
        report_run.sql = File.read("#{QreportAR.report_query_dir.call}/#{name}.sql")
      rescue StandardError
        raise "Unknown report: #{name}"
      end
      report_run.run! conn
      self.find(report_run.id)
    end

    def self.conn
      ar_conn = self.connection
      conn = Qreport::Connection.new(:conn => ar_conn.raw_connection)
      conn.schemaname = QreportAR.schemaname
      conn.verbose = QreportAR.verbose
      conn
    end

  end
end

