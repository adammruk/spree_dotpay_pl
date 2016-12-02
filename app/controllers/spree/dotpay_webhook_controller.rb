module Spree
  class DotpayWebhookController < BaseController
    skip_before_filter :verify_authenticity_token

    def notification

      # checking signature and validating amounts etc for payment,
      # returns nil or order object for this payment

      order = PaymentMethod::DotpayPl.validate_dotpay_notification(params)

      if order && payment = order.get_dotpay_payment
        payment.capture!
        render json: "OK"
      else
        head :forbidden
      end

    end

    def redirect_to_order
      redirect_to '/orders/'+params[:number]
    end


  end
end
