defmodule ChatDemo.ConversationView do
  use ChatDemo.Web, :view

  def name_id_map(users) do
    Enum.reduce(users, HashDict.new, fn (u, dict) -> 
                                                Dict.put(dict, u.email, u.id) 
                                              end)
  end 
end
