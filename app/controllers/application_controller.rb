class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Add your routes here
  get "/" do
    { result: "Good luck with your project!" }.to_json
  end

  def create_response suc:false, res: ""
      {
        success: suc,
        result: res
      }.to_json
    end

end
