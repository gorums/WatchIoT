class HomeController < ApplicationController

  def index
    @plans = Plan.all
    @features = Feature.all
    @faqs = Faq.all
    @contactus = ContactUs.new
  end

  def contact
    @contactus = ContactUs.new(contact_params)
    @contactus.save

    flash[:success] = "Thank you for contact us!"
    redirect_to root_url + "#contactus"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact_us).permit(:email, :subject, :body)
  end
end
