module ImportProducts
  class ImportJob
    attr_accessor :product_import_id
    attr_accessor :user_id
    attr_accessor :import_type

    def initialize(product_import_record, user,import_type)
      self.product_import_id = product_import_record.id
      self.user_id = user.id
      self.import_type = import_type
    end

    def perform
      begin
        product_import = Spree::ProductImport.find(self.product_import_id)
        results = product_import.import_data!(self.import_type)
        #UserMailer.product_import_results(User.find(self.user_id)).deliver
      rescue Exception => exp
        #UserMailer.product_import_results(User.find(self.user_id), exp.message).deliver
      end
    end
  end
end

