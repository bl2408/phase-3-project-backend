class ApplicationController < Sinatra::Base
  set :default_content_type, 'application/json'

  # Add your routes here
  get "/" do
    { result: "Nothing going on here." }.to_json
  end

  get "/roles" do
    to_response(
      suc: true, 
      res: Role.all, 
  )
  end

  # create post
  post "/new/post" do    
    verify = verify_user(request.POST["user"])

    viewable = Viewable.find_by(name: request.POST["viewable"]);

    if viewable == nil
      verify[:success] = false
    end

    if verify[:success]

      results = Post.new_post user: verify[:value], post: request.POST, view: viewable

      to_response(
          suc: true, 
          res: results, 
      )  

    else
      to_response(
          suc: false, 
          res: "Failed to create new post!", 
      )  
    end  
end

put "/edit/post/:id" do   


  verify = verify_user(params["user"])

  viewable = Viewable.find_by(name: params["viewable"]);

  if viewable == nil
    verify[:success] = false
  end

  if verify[:success]

    results = Post.edit_post postId: params["id"], user: verify[:value], post: params, view: viewable

    to_response(
        suc: true, 
        res: results, 
    )  

  else
    to_response(
        suc: false, 
        res: "Failed to update new post!", 
    )  
  end  
end

  get "/viewables" do
    to_response(
        suc: true, 
        res: Viewable.all, 
    ) 
  end


  def verify_user userHash

    results = {success: false, value: {} }

    return results if !userHash["id"] || !userHash["name"] || !userHash["role_id"]

    db = User.find(userHash["id"]);

    if userHash["id"] != db.id|| userHash["name"] != db.name || userHash["role_id"] != db.role_id
      results
    else
      results[:success] = true
      results[:value] = db
      results
    end

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
