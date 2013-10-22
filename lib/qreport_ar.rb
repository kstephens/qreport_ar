
module QreportAr
  class << self
    attr_accessor :verbose, :connection, :schema
    attr_accessor :report_query_dir
  end
  self.connection = "no_pooling"
  self.report_query_dir = lambda { | | "#{Rails.root}/db/qreport" }
end

require "qreport_ar/version"
