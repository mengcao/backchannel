class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :votable, :polymorphic => true
  attr_accessible :votable_id, :votable_type,:user_id

end
