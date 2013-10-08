# To change this template, choose Tools | Templates
# and open the template in the editor.

module Spree
  class ProductAvailableNotifierMailer < ActionMailer::Base

    def notify_email(mail_method, product,user)
      @product = product
      @mail_method = mail_method
      subject = "#{Spree::Config[:site_name]} Notifiction that product is in stock"
      mail(:to => user.email,
        :subject => subject)
    end
  end
end
