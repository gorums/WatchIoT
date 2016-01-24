##
# Home controller
#
class HomeController < ApplicationController
  ##
  # Get /
  #
  def index
    @faqs = Faq.where(lang: 'en').all
    @descrips = Descrip.where(lang: 'en').all
    @contactus = ContactUs.new
  end

  ##
  # POST /contactus
  #
  def contact
    @contactus = ContactUs.new(contact_params)
    @contactus.save

    flash[:success] = 'Thank you for contact us!'
    redirect_to root_url + '#contactus'
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact_us).permit(:email, :subject, :body)
  end
end
