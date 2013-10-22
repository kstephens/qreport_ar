require 'qreport_ar'
require 'qreport/connection'
require 'qreport/report_run'
require 'qreport/report_runner'

module QreportAR
  # An ActiveRecord model for Qreport report_runs table.
  class ReportRun < ActiveRecord::Base
    establish_connection QreportAR.connection
    self.table_name = 'qr_report_runs'
    serialize :arguments, JSON
    serialize :error, JSON
    serialize :additional_columns, JSON
    serialize :base_columns, JSON

    def data
      @data ||= self.class.conn.run("SELECT * FROM #{report_table} WHERE qr_run_id = #{id} ORDER BY qr_run_row")
    end

    def reload
      @data = nil
      super
    end

    def self.generate params
      name = params[:name]
      raise ArgumentError, "expected report name" if name.blank?
      raise ArgumentError, "invalid report name" unless name =~ /\A[-_a-z0-9]+\Z/i

      arguments = { }
      (params[:arguments] || { }).each { | k, v | arguments[k.to_sym] = v }
      arguments[:now] ||= Time.now

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

