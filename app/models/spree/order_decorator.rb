Spree::Order.class_eval do

  DOTPAY_REDIRECT_TYPE = "0" unless const_defined?(:DOTPAY_REDIRECT_TYPE)

  def get_dotpay_payment
    payments.valid.detect{|p| p.payment_method.type == 'Spree::PaymentMethod::DotpayPl'}
  end


  def self.dotpay_payment_method
    Spree::PaymentMethod.select{ |pm| pm.name.downcase =~ /dotpay/}.first
  end

  def get_dotpay_link

    preferences = get_dotpay_payment.payment_method.preferences

    host = preferences[:dotpay_host]

    comeback_url = "#{preferences[:store_host]}/dotpay_pl/webhooks/redirect_to_order/#{number}"

    params = "/?id=#{preferences[:merchant_id]}
              &URL=#{comeback_url}
              &type=#{DOTPAY_REDIRECT_TYPE}
              &amount=#{total}
              &currency=#{currency}
              &description=#{number}
              &control=#{number}
              &chk=#{calculate_chk(preferences, comeback_url)}"

    (host+params).gsub(/\s+/, "")
  end

  private

  def calculate_chk(preferences, comeback_url)

    Digest::SHA256.hexdigest preferences[:merchant_pin]+preferences[:merchant_id]+total.to_s+currency+number+number+comeback_url+DOTPAY_REDIRECT_TYPE
  end
end
