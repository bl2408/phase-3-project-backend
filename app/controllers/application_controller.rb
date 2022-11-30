class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Add your routes here
  get "/" do
    { result: "Nothing going on here." }.to_json
  end


  def to_response suc:false, res: nil, options: nil
    {
      success: suc,
      results: res,
    }.to_json(options)

  end

  def is_numeric?(obj) 
    obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
  end

end
