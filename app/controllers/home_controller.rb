class HomeController < ApplicationController

  def index
    @plans = Plan.all
    @features = Feature.all
    @faqs = Faq.all

  end

  def contact
    contact = ContactUs.new(contact_params)
    contact.save

    flash[:success] = "Thank you for contact us!"
    redirect_to root_url + "#contactus"
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    params.require(:contact).permit(:email, :subject, :body)
  end
end
