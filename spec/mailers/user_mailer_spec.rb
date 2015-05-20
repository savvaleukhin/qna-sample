require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
=begin
  describe "notify_question_owner" do
    let(:mail) { UserMailer.notify_question_owner }

    it "renders the headers" do
      expect(mail.subject).to eq("Notify question owner")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
=end
end
