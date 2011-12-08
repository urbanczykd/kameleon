require 'spec_helper'

describe "Kameleon::User::Guest" do
  include ::Capybara::DSL

  before(:all) do
    Capybara.app = Hey
  end


  context "guest user" do
    before(:all) do
      @guest = Kameleon::User::Guest.new(self, {:session_name => :see_world})
      @selenium = Kameleon::User::Guest.new(self, {:session_name => :new_world, :driver => :selenium})
      @another_guest = Kameleon::User::Guest.new(self)
    end

    context "sessions" do
      it "by default user should get current session" do
        @another_guest.session.should == Capybara.current_session
      end

      it "guests should have separate session if param :session_name defined" do
        @guest.session.should_not == Capybara.current_session
      end
    end

    context "driver" do
      it "will not change if not defined in params" do
        @guest.session.driver.should be_a Capybara.current_session.driver.class
      end

      context "selecting custom driver" do
        it "should set Selenium if params :driver => :selenium" do
          @selenium.session.driver.should be_a Capybara::Selenium::Driver
        end
        it "shouldn't change drivers for other users'" do
          [@guest, @another_guest].each do |user|
            user.session.driver.should be_a Capybara::RackTest::Driver
          end
        end
      end
    end
  end
end